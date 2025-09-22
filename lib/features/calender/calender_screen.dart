import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:praying_app/features/calender/widget/circules.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends ConsumerStatefulWidget {
  const CalenderScreen({super.key});
  @override
  CalenderScreenState createState() => CalenderScreenState();
}

class CalenderScreenState extends ConsumerState<CalenderScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  double outer = 0.25;
  double middle = 0.5;
  double inner = 0.15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calender')),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                            DateFormat("d MMMM y").format(DateTime.now()),
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(children: []),
                        ],
                      ),
                    ),
                    ConcentricProgress(
                      size: 150,
                      outerProgress: outer,
                      middleProgress: middle,
                      innerProgress: inner,
                      outerColor: Colors.blue,
                      middleColor: Colors.orange,
                      innerColor: Colors.green,
                      strokeWidths: const [10, 10, 20],
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
                    return Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
