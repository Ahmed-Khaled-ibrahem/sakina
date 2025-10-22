import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:praying_app/features/home/view/widgets/counter.dart';
import 'package:praying_app/features/home/view/widgets/progress_bar.dart';
import 'package:praying_app/features/home/view/widgets/togle_button.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../../app/helpers/colors.dart';
import '../../../app/helpers/convert_to_12h.dart';
import '../../../app/helpers/notifications.dart';
import '../../../app/providers/all_app_provider.dart';
import '../../splash_screen/providers/prayer_entry.dart';
import '../provider/city_provider.dart';
import '../provider/prayer_provider.dart';
import '../provider/praying_bool_notifications.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isNawaflOn = false;
  static const MethodChannel _channel = MethodChannel('android_app_settings');
  List<bool> _values = List<bool>.filled(10, false);

  Future<void> _loadPrefs() async {
    final values = await BoolListPrefs.load();
    setState(() => _values = values);
  }

  Future<void> _updateValue(int index, bool value) async {
    setState(() => _values[index] = value);
    await BoolListPrefs.save(_values);
    setupPrayerNotifications(_values);
  }

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    requestNotificationPermission();
    checkExactAlarmPermission();
  }

  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> checkExactAlarmPermission() async {
    await ensureGranted();
    final status = await Permission.scheduleExactAlarm.status;
    debugPrint("⏰ Exact alarm permission: $status");
  }

  /// Check if exact alarm is already granted
  static Future<bool> isGranted() async {
    if (!Platform.isAndroid) return true;

    final status = await Permission.scheduleExactAlarm.status;
    return status.isGranted;
  }

  /// Ensure the permission is granted
  static Future<void> ensureGranted() async {
    if (!Platform.isAndroid) return;

    final granted = await isGranted();
    if (granted) {
      debugPrint("✅ Exact alarm already granted");
      return;
    }

    debugPrint("⚠️ Exact alarm not granted, opening settings...");
    try {
      await _channel.invokeMethod('requestExactAlarmPermission');
    } catch (e) {
      debugPrint("⚠️ Failed to request exact alarm: $e");
    }
  }

  bool isPrayerDone(DateTime target, DateTime nextTarget) {
    final entries = ref.read(todaysEntriesProvider);
    for (final e in entries) {
      if (e.category == 'praying') {
        if (e.dateTime.isAfter(target) && e.dateTime.isBefore(nextTarget)) {
          return true;
        }
      }
    }
    return false;
  }

  bool isNaflaDone(DateTime target, DateTime nextTarget) {
    final entries = ref.read(todaysEntriesProvider);
    for (final e in entries) {
      if (e.category == 'nawafl') {
        if (e.dateTime.isAfter(target) && e.dateTime.isBefore(nextTarget)) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final cityAsync = ref.watch(locationProvider);
    final asyncPrayer = ref.watch(prayerProvider);
    ref.watch(todaysEntriesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final refreshValue = ref.watch(refreshProvider);


    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      cityAsync.when(
                        data: (city) => Text(
                          city,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (err, _) => Text(
                          "unKnown",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 50),
                      asyncPrayer.when(
                        data: (data) => Expanded(
                          child: Text(
                            "${data.hijriDate.day} ${data.hijriDate.month} ${data.hijriDate.year}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.end,
                          ),
                        ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, _) {
                          return Text(
                            'error',
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            asyncPrayer.when(
              data: (data) => Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: PrayerProgressWidget(
                          fajr: parseTime(data.timings.fajr),
                          isha: parseTime(data.timings.isha),
                          prayerTimes: [
                            parseTime(data.timings.fajr), // Fajr
                            parseTime(data.timings.dhuhr), // Dhuhr
                            parseTime(data.timings.asr), // Asr
                            parseTime(data.timings.maghrib), // Maghrib
                            parseTime(data.timings.isha), // Isha
                          ],
                        ),
                      ),
                      PrayerCountdownWidget(
                        prayers: {
                          'Fajr': parseTime(data.timings.fajr),
                          'Dhuhr': parseTime(data.timings.dhuhr),
                          'Asr': parseTime(data.timings.asr),
                          'Maghrib': parseTime(data.timings.maghrib),
                          'Isha': parseTime(data.timings.isha),
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/home/f.svg',
                              width: 50,
                              height: 50,
                              color: Color(0xFFFFDC80),
                            ),
                            SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'fajr'.tr(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  convertTo12Hour(
                                    data.timings.fajr,
                                    context.locale.languageCode,
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'isha'.tr(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  convertTo12Hour(
                                    data.timings.isha,
                                    context.locale.languageCode,
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 8),
                            SvgPicture.asset(
                              'assets/icons/home/i.svg',
                              width: 50,
                              height: 50,
                              color: Color(0xFFFFDC80),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text("Error")),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Color(0xFF171923)
                      : Colors.white,
                ),
                child: asyncPrayer.when(
                  data: (data) => Padding(
                    padding: const EdgeInsets.only(top: 2, left: 20, right: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomToggle(
                            isDark: isDark,
                            isNawaflOn: isNawaflOn,
                            onChanged: (val) {
                              setState(() {
                                isNawaflOn = val;
                              });
                            },
                          ),
                          Builder(
                            builder: (context) {
                              if (isNawaflOn) {
                                return ListView(
                                  shrinkWrap: true,
                                  children: [
                                    PrayItemList(
                                      prayName: 'before_fajr'.tr(),
                                      prayTime: data.timings.fajr,
                                      index: 0,
                                      beforePrayTime: data.timings.fajr,
                                      notificationIsOn: _values[5],
                                      onChanged: _updateValue,
                                      isNawafel: true,
                                      isDone: isNaflaDone(
                                        parseTime(
                                          data.timings.fajr,
                                        ).subtract(Duration(hours: 1)),
                                        parseTime(
                                          data.timings.fajr,
                                        ).add(Duration(minutes: 10)),
                                      ),
                                    ),
                                    PrayItemList(
                                      prayName: 'before_dhuhr'.tr(),
                                      prayTime: data.timings.dhuhr,
                                      beforePrayTime: data.timings.fajr,
                                      index: 1,
                                      notificationIsOn: _values[6],
                                      onChanged: _updateValue,
                                      isNawafel: true,
                                      isDone: isNaflaDone(
                                        parseTime(
                                          data.timings.dhuhr,
                                        ).subtract(Duration(hours: 1)),
                                        parseTime(data.timings.dhuhr),
                                      ),
                                    ),
                                    PrayItemList(
                                      prayName: 'after_dhuhr'.tr(),
                                      prayTime: data.timings.asr,
                                      beforePrayTime: data.timings.fajr,
                                      index: 2,
                                      onChanged: _updateValue,
                                      isNawafel: true,
                                      notificationIsOn: _values[7],
                                      isDone: isNaflaDone(
                                        parseTime(data.timings.dhuhr),
                                        parseTime(data.timings.asr),
                                      ),
                                    ),
                                    PrayItemList(
                                      prayName: 'after_maghrib'.tr(),
                                      prayTime: data.timings.maghrib,
                                      beforePrayTime: data.timings.asr,
                                      index: 3,
                                      notificationIsOn: _values[8],
                                      isNawafel: true,
                                      onChanged: _updateValue,
                                      isDone: isNaflaDone(
                                        parseTime(data.timings.maghrib),
                                        parseTime(data.timings.isha),
                                      ),
                                    ),
                                    PrayItemList(
                                      prayName: 'after_isha'.tr(),
                                      prayTime: data.timings.isha,
                                      beforePrayTime: data.timings.maghrib,
                                      index: 4,
                                      onChanged: _updateValue,
                                      notificationIsOn: _values[9],
                                      isNawafel: true,
                                      isDone: isNaflaDone(
                                        parseTime(data.timings.isha),
                                        parseTime(
                                          data.timings.fajr,
                                        ).add(Duration(days: 1)),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return ListView(
                                shrinkWrap: true,
                                children: [
                                  PrayItemList(
                                    prayName: 'fajr'.tr(),
                                    prayTime: data.timings.fajr,
                                    beforePrayTime: data.timings.fajr,
                                    index: 0,
                                    isNawafel: false,
                                    onChanged: _updateValue,
                                    notificationIsOn: _values[0],
                                    isDone: isPrayerDone(
                                      parseTime(data.timings.fajr),
                                      parseTime(data.timings.dhuhr),
                                    ),
                                  ),
                                  PrayItemList(
                                    prayName: 'dhuhr'.tr(),
                                    prayTime: data.timings.dhuhr,
                                    beforePrayTime: data.timings.fajr,
                                    index: 1,
                                    isNawafel: false,
                                    onChanged: _updateValue,
                                    notificationIsOn: _values[1],
                                    isDone: isPrayerDone(
                                      parseTime(data.timings.dhuhr),
                                      parseTime(data.timings.asr),
                                    ),
                                  ),
                                  PrayItemList(
                                    prayName: 'asr'.tr(),
                                    prayTime: data.timings.asr,
                                    beforePrayTime: data.timings.dhuhr,
                                    index: 2,
                                    isNawafel: false,
                                    onChanged: _updateValue,
                                    notificationIsOn: _values[2],
                                    isDone: isPrayerDone(
                                      parseTime(data.timings.asr),
                                      parseTime(data.timings.maghrib),
                                    ),
                                  ),
                                  PrayItemList(
                                    prayName: 'maghrib'.tr(),
                                    prayTime: data.timings.maghrib,
                                    beforePrayTime: data.timings.asr,
                                    index: 3,
                                    isNawafel: false,
                                    onChanged: _updateValue,
                                    notificationIsOn: _values[3],
                                    isDone: isPrayerDone(
                                      parseTime(data.timings.maghrib),
                                      parseTime(data.timings.isha),
                                    ),
                                  ),
                                  PrayItemList(
                                    prayName: 'isha'.tr(),
                                    prayTime: data.timings.isha,
                                    beforePrayTime: data.timings.maghrib,
                                    index: 4,
                                    isNawafel: false,
                                    onChanged: _updateValue,
                                    notificationIsOn: _values[4],
                                    isDone: isPrayerDone(
                                      parseTime(data.timings.isha),
                                      parseTime(
                                        data.timings.fajr,
                                      ).add(Duration(days: 1)),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text("Error")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime parseTime(String time) {
    final now = DateTime.now();
    final parts = time.split(':'); // ["05", "10"]
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}

class PrayItemList extends StatelessWidget {
  final String prayName;
  final String prayTime;
  final String beforePrayTime;
  final int index;
  final bool isDone;
  final bool notificationIsOn;
  final bool isNawafel;
  final Function(int, bool) onChanged; // callback

  const PrayItemList({
    super.key,
    required this.prayName,
    required this.prayTime,
    required this.beforePrayTime,
    required this.index,
    this.isDone = false,
    this.notificationIsOn = false,
    required this.onChanged,
    required this.isNawafel,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: index == 0,
      isLast: index == 4,
      indicatorStyle: IndicatorStyle(
        width: 12,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        color: isPrayerNow(prayTime, beforePrayTime)
            ? AppColors.mainColor
            : AppColors.mainColor.withOpacity(0.2),
      ),
      beforeLineStyle: LineStyle(
        color: AppColors.mainColor.withOpacity(0.2),
        thickness: 1,
      ),
      afterLineStyle: LineStyle(
        color: Colors.deepPurpleAccent.withOpacity(0.2),
        thickness: 1,
      ),
      endChild: Column(
        children: [
          Container(
            height: 65,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Color(0xFF2C2F41)
                  : Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow:  [
                      BoxShadow(
                        color: AppColors.mainColor.withOpacity(0.05),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 2),
                      ),
                    ],
            ),
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(10),
            child: Row(
              spacing: 10,
              children: [
                getPrayIconWidget(index,context),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        prayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        convertTo12Hour(prayTime, context.locale.languageCode),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    onChanged(
                      isNawafel ? index + 5 : index,
                      !notificationIsOn,
                    ); // use callback
                  },
                  color: notificationIsOn ? AppColors.mainColor : Colors.grey,
                  icon: Icon(
                    notificationIsOn
                        ? Icons.notifications_active
                        : Icons.notifications_off,
                  ),
                ),
                Icon(
                  isDone ? Icons.check_circle : Icons.circle_outlined,
                  color: isDone ? AppColors.mainColor : Colors.grey,
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getPrayIconWidget(int index, context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.1)
            : AppColors.mainColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SvgPicture.asset(
        'assets/icons/home/${index + 1}.svg',
        width: 40,
        height: 40,
        color:Theme.of(context).brightness == Brightness.dark
            ? Colors.grey: AppColors.mainColor,
      ),
    );
  }

  bool isPrayerNow(String time, String beforeTime) {
    final now = DateTime.now();
    final target = parseTime(time);
    final beforeTarget = parseTime(beforeTime);
    if (time == beforeTime) {
      return now.isBefore(target);
    }
    return now.isBefore(target) && now.isAfter(beforeTarget);
  }

  DateTime parseTime(String time) {
    final now = DateTime.now();
    final parts = time.split(':'); // ["05", "10"]

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}
