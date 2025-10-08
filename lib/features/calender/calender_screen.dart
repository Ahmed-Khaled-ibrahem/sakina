import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:praying_app/features/calender/widget/circules.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../app/providers/all_app_provider.dart';
import '../splash_screen/providers/prayer_entry.dart';
import '../splash_screen/providers/real_time_data.dart';

class CalenderScreen extends ConsumerStatefulWidget {
  const CalenderScreen({super.key});
  @override
  CalenderScreenState createState() => CalenderScreenState();
}

class CalenderScreenState extends ConsumerState<CalenderScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  int todayPrays = 0;
  int todayEx = 0;
  int todayNawafl = 0;
  int todayMistakes = 0;

  void updateValues() {
    todayEx = 0;
    todayPrays = 0;
    todayNawafl = 0;
    todayMistakes = 0;

    final entries = ref.read(todaysEntriesProvider);
    for (final e in entries) {
      if (e.category == 'ex') {
        todayEx++;
      } else if (e.category == 'nawafl') {
        todayMistakes += (e.value.abs() / 2).round();
        todayNawafl++;
      } else if (e.category == 'praying') {
        todayMistakes += (e.value.abs() / 2).round();
        todayPrays++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(todaysEntriesProvider);
    updateValues();
    final refreshValue = ref.watch(refreshProvider);


    return Scaffold(
      // appBar: AppBar(title: Text('calender'.tr())),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 0.04.sh),
              Row(
                children: [
                  SizedBox(width: 0.05.sw),
                  Text("calender".tr(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),

              Card(
                margin: const EdgeInsets.all(20),
                color: Colors.grey.withOpacity(0.3),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat("d MMMM y", context.locale.languageCode).format(DateTime.now()),
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'today'.tr(),
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/icons/calender/1.png',
                                          width: 20,
                                        ),
                                        Text(
                                          '$todayPrays/5',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/icons/calender/2.png',
                                          width: 20,
                                        ),
                                        Text(
                                          '$todayEx/10',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/icons/calender/3.png',
                                          width: 20,
                                        ),
                                        Text(
                                          '$todayMistakes/10',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/icons/calender/4.png',
                                          width: 20,
                                        ),
                                        Text(
                                          '$todayNawafl/5',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ConcentricProgress(
                        size: 150,
                        outerProgress: todayPrays / 5,
                        middleProgress: todayEx / 10,
                        innerProgress: todayMistakes / 10,
                        innermostProgress: todayNawafl / 5,
                        innermostColor: Colors.green,
                        outerColor: Colors.orange,
                        middleColor: Colors.white,
                        innerColor: Colors.blue,
                        strokeWidths: const [10, 10, 10, 10],
                        duration: const Duration(seconds: 2),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TableCalendar(
                  calendarFormat: CalendarFormat.month,
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(fontSize: 16),
                  ),
                  locale: context.locale.languageCode,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: DateTime.now(),
                  selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                  daysOfWeekHeight: 30,
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(fontSize: 10),
                    weekendStyle: TextStyle(fontSize: 10),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, _) {
                      return _buildDayWidget(day, isToday: false);
                    },
                    todayBuilder: (c, d, e) {
                      return _buildDayWidget(d, isToday: true);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double? getProgress(DateTime target) {
    int counter = 0;
    final entries = ref.read(realtimeDataStateProvider);
    final List<PrayerEntry> data = parseRealtimeData(entries ?? {});
    data.forEach((element) {
      if (element.dateTime.year == target.year &&
          element.dateTime.month == target.month &&
          element.dateTime.day == target.day) {
        if (element.category == 'praying') {
          counter++;
        }
      }
    });
    return counter / 5;
  }

  Widget _buildDayWidget(DateTime day, {required bool isToday}) {
    double progress = getProgress(day) ?? 0;
    return SizedBox(
      height: 40,
      width: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 3,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              isToday
                  ? Colors.blue
                  : (progress == 1 ? Colors.green : Colors.red),
            ),
          ),

          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: isToday
                  ? Colors.blue.withOpacity(0.3)
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isToday ? Colors.white : Colors.grey,
                width: 0.5,
              ),
            ),
            child: Center(
              child: Text(
                day.day.toString(),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
