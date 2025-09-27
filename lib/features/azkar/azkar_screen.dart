import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/helpers/notifications.dart';
import '../../app/routes/routes.dart';
import 'package:timezone/timezone.dart' as tz;


class AzkarScreen extends ConsumerWidget {
  const AzkarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('azkar'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              height: 120,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.push(AppRoutes.azkharEvening);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.all(10),
                        color: Color(0xffEAEEFB),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'evening'.tr(),
                                    style: TextStyle(
                                      color: Color(0xff3551F2),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset('assets/icons/azkar/1.png'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.push(AppRoutes.azkharMorning);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.all(10),
                        color: Color(0xff3551F2),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset('assets/icons/azkar/2.png'),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'morning'.tr(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 120,
              width: double.infinity,
              child: InkWell(
                onTap: () {
                  context.push(AppRoutes.azkharPraying);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: EdgeInsets.all(10),
                  color: Color(0xffFFEBC2),
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'after_salah'.tr(),
                                style: TextStyle(
                                  color: Color(0xffF9BF29),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -15,
                              left: -8,
                              child: Image.asset(
                                'assets/icons/azkar/3.png',
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ElevatedButton(onPressed: ()async {
            //   // showImmediateNotification();
            //   // setupPrayerNotifications();
            //   final now = TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 1)));
            //   await scheduleNotification(99, "Test", "Test in 1 minute", now);
            //
            //   final now_ = DateTime.now();
            //   debugPrint("📱 Device local time: $now_");
            //   final tzNow = tz.TZDateTime.now(tz.local);
            //   debugPrint("🌍 TZ local time: $tzNow");
            //
            // }, child: Text('test'))
          ],
        ),
      ),
    );
  }
}
