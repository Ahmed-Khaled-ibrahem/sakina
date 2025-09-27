import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:praying_app/app/providers/all_app_provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../../features/home/provider/prayer_provider.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);

  await notificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      debugPrint('Notification clicked: ${response.payload}');
    },
  );

  // Request notification permissions for Android 13+
  await _requestNotificationPermissions();

  // Create notification channels
  await _createNotificationChannels();
}

Future<void> _requestNotificationPermissions() async {
  final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
      notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

  if (androidPlugin != null) {
    await androidPlugin.requestNotificationsPermission();
    await androidPlugin.requestExactAlarmsPermission();
  }
}

Future<void> _createNotificationChannels() async {
  final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
      notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

  if (androidPlugin != null) {
    // Create test channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'test_channel',
        'Test Notifications',
        description: 'Channel for testing notifications',
        importance: Importance.max,
      ),
    );

    // Create prayer channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'prayer_channel',
        'Prayer Notifications',
        description: 'Daily prayer reminders',
        importance: Importance.max,
      ),
    );
  }
}

Future<void> setupTimezone() async {
  tz.initializeTimeZones();

  try {
    final timezoneName = await FlutterTimezone.getLocalTimezone();
    final location = tz.getLocation(timezoneName.identifier);
    tz.setLocalLocation(location);

    debugPrint("📍 Device timezone: $timezoneName");
    debugPrint("⏰ Current local time: ${DateTime.now()}");
    debugPrint("🌍 TZ local time: ${tz.TZDateTime.now(tz.local)}");
  } catch (e) {
    debugPrint("Error setting timezone: $e");
    // Fallback to UTC if timezone detection fails
    tz.setLocalLocation(tz.getLocation('UTC'));
  }
}

Future<void> showImmediateNotification() async {
  const androidDetails = AndroidNotificationDetails(
    'test_channel',
    'Test Notifications',
    channelDescription: 'Channel for testing notifications',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
    ticker: 'ticker',
    showWhen: true,
  );

  const details = NotificationDetails(android: androidDetails);

  await notificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique ID
    "📢 Test Notification",
    "This is working immediately!",
    details,
  );

  debugPrint("✅ Immediate notification sent");
}

Future<void> scheduleNotification(
  int id,
  String title,
  String body,
  bool active,
  TimeOfDay time, {
  bool repeatDaily = true,
}) async {
  try {
    if(!active){
      return;
    }
    final now = DateTime.now();
    var scheduleDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      0,
      // seconds
      0,
      // milliseconds
      0, // microseconds
    );

    // If the time already passed today and not repeating → schedule for tomorrow
    if (scheduleDate.isBefore(now) && !repeatDaily) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    // If repeating daily and time passed today, start from tomorrow
    else if (scheduleDate.isBefore(now) && repeatDaily) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }

    final tzDate = tz.TZDateTime.from(scheduleDate, tz.local);

    const androidDetails = AndroidNotificationDetails(
      'prayer_channel',
      'Prayer Notifications',
      channelDescription: 'Daily prayer reminders',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      ticker: 'ticker',
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: repeatDaily ? DateTimeComponents.time : null,
    );

    // debugPrint('✅ Scheduled notification:');
    // debugPrint('   ID: $id');
    // debugPrint('   Title: $title');
    // debugPrint('   Time: ${time.format}');
    // debugPrint('   Scheduled for: $tzDate');

    // Verify the notification was scheduled
    final pendingNotifications = await notificationsPlugin
        .pendingNotificationRequests();
    final isScheduled = pendingNotifications.any((n) => n.id == id);
    // debugPrint(
    //   '   Verification: ${isScheduled ? "✅ Scheduled" : "❌ Not found"}',
    // );
  } catch (e, stackTrace) {
    debugPrint('❌ Error scheduling notification: $e');
    debugPrint('Stack trace: $stackTrace');
  }
}

Future<void> setupPrayerNotifications(List values) async {
  final prayerRepo = globalContainer.read(prayerProvider);
  final data = prayerRepo.value;

  if (data == null) {
    return;
  }

  await cancelAllNotifications();

  await scheduleNotification(
    0,
    "صلاة الفجر",
    "حان الآن وقت صلاة الفجر 🕌",
    values[0],
    TimeOfDay(
      hour: parseTime(data.timings.fajr).hour,
      minute: parseTime(data.timings.fajr).minute,
    ),
    repeatDaily: true,
  );

  await scheduleNotification(
    1,
    "صلاة الظهر",
    "حان الآن وقت صلاة الظهر 🕌",
    values[1],
    TimeOfDay(
      hour: parseTime(data.timings.dhuhr).hour,
      minute: parseTime(data.timings.dhuhr).minute,
    ),
    repeatDaily: true,
  );

  await scheduleNotification(
    2,
    "صلاة العصر",
    "حان الآن وقت صلاة العصر 🕌",
    values[2],
    TimeOfDay(
      hour: parseTime(data.timings.asr).hour,
      minute: parseTime(data.timings.asr).minute,
    ),
    repeatDaily: true,
  );

  await scheduleNotification(
    3,
    "صلاة المغرب",
    "حان الآن وقت صلاة المغرب 🕌",
    values[3],
    TimeOfDay(
      hour: parseTime(data.timings.maghrib).hour,
      minute: parseTime(data.timings.maghrib).minute,
    ),
    repeatDaily: true,
  );

  await scheduleNotification(
    4,
    "صلاة العشاء",
    "حان الآن وقت صلاة العشاء 🕌",
    values[4],
    TimeOfDay(
      hour: parseTime(data.timings.isha).hour,
      minute: parseTime(data.timings.isha).minute,
    ),
    repeatDaily: true,
  );

  await scheduleNotification(
    5,
    "سنه الفجر",
    "حان الآن وقت سنه الفجر 🕌",
    values[5],
    TimeOfDay(
      hour: parseTime(data.timings.fajr).subtract(Duration(minutes: 5)).hour,
      minute: parseTime(data.timings.fajr).subtract(Duration(minutes: 5)).minute,
    ),
    repeatDaily: true,
  );

  await scheduleNotification(
    6,
    "سنه الظهر",
    "حان الآن وقت سنه الظهر 🕌",
    values[6],
    TimeOfDay(
      hour: parseTime(data.timings.dhuhr).subtract(Duration(minutes: 5)).hour,
      minute: parseTime(data.timings.dhuhr).subtract(Duration(minutes: 5)).minute,
    ),
    repeatDaily: true,
  );
  await scheduleNotification(
    7,
    "سنه الظهر",
    "حان الآن وقت سنه الظهر 🕌",
    values[7],
    TimeOfDay(
      hour: parseTime(data.timings.dhuhr).add(Duration(minutes: 5)).hour,
      minute: parseTime(data.timings.dhuhr).add(Duration(minutes: 5)).minute,
    ),
    repeatDaily: true,
  );
  await scheduleNotification(
    8,
    "سنه المغرب",
    "حان الآن وقت سنه المغرب 🕌",
    values[8],
    TimeOfDay(
      hour: parseTime(data.timings.maghrib).add(Duration(minutes: 5)).hour,
      minute: parseTime(data.timings.maghrib).add(Duration(minutes: 5)).minute,
    ),
    repeatDaily: true,
  );
  await scheduleNotification(
    9,
    "سنه العشاء",
    "حان الآن وقت سنه العشاء 🕌",
    values[9],
    TimeOfDay(
      hour: parseTime(data.timings.isha).add(Duration(minutes: 5)).hour,
      minute: parseTime(data.timings.isha).add(Duration(minutes: 5)).minute,
    ),
    repeatDaily: true,
  );

  debugPrint("✅ All prayer notifications scheduled");
}

DateTime parseTime(String time) {
  final now = DateTime.now();
  final parts = time.split(':'); // ["05", "10"]
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return DateTime(now.year, now.month, now.day, hour, minute);
}

Future<void> cancelNotification(int id) async {
  await notificationsPlugin.cancel(id);
  debugPrint("🗑️ Cancelled notification with ID: $id");
}

Future<void> cancelAllNotifications() async {
  await notificationsPlugin.cancelAll();
  debugPrint("🗑️ Cancelled all notifications");
}

Future<List<PendingNotificationRequest>> getPendingNotifications() async {
  final pendingNotifications = await notificationsPlugin
      .pendingNotificationRequests();
  debugPrint("📋 Pending notifications: ${pendingNotifications.length}");
  for (final notification in pendingNotifications) {
    debugPrint("   - ID: ${notification.id}, Title: ${notification.title}");
  }
  return pendingNotifications;
}
