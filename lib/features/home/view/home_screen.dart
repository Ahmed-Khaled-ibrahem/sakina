import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:praying_app/features/home/view/widgets/counter.dart';
import 'package:praying_app/features/home/view/widgets/progress_bar.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../provider/city_provider.dart';
import '../provider/prayer_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    print('building...');
    final cityAsync = ref.watch(locationProvider);
    final asyncPrayer = ref.watch(prayerProvider);

    return Scaffold(
      backgroundColor: Color(0xFF3551F2),
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
                          print(err);
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
                                  'Fajr',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  data.timings.fajr,
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
                                  'Isha',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  data.timings.isha,
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
            SizedBox(height: 10),
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
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        PrayItemList(
                          prayName: 'Fajr',
                          prayTime: data.timings.fajr,
                          index: 0,
                        ),
                        PrayItemList(
                          prayName: 'Dhuhr',
                          prayTime: data.timings.dhuhr,
                          index: 1,
                        ),
                        PrayItemList(
                          prayName: 'Asr',
                          prayTime: data.timings.asr,
                          index: 2,
                        ),
                        PrayItemList(
                          prayName: 'Maghrib',
                          prayTime: data.timings.maghrib,
                          index: 3,
                        ),
                        PrayItemList(
                          prayName: 'Isha',
                          prayTime: data.timings.isha,
                          index: 4,
                        ),
                      ],
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
  final int index;

  const PrayItemList({
    super.key,
    required this.prayName,
    required this.prayTime,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: index == 0,
      isLast: index == 4,
      indicatorStyle: IndicatorStyle(
        width: 12,
        padding: EdgeInsets.all(8),
        color: isPrayerNow(prayTime)
            ? Colors.deepPurpleAccent
            : Colors.deepPurpleAccent.withOpacity(0.2),
      ),
      beforeLineStyle: LineStyle(
        color: Colors.deepPurpleAccent.withOpacity(0.2),
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        color: Colors.deepPurpleAccent.withOpacity(0.2),
        thickness: 2,
      ),
      endChild: Column(
        children: [
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Color(0xFF2C2F41)
                  : Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: Theme.of(context).brightness == Brightness.dark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
            ),
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(10),
            child: Row(
              spacing: 10,
              children: [
                getPrayIconWidget(index),
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
                        prayTime,
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
                  onPressed: () {},
                  icon: Icon(Icons.notifications_active),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.check_circle)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getPrayIconWidget(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SvgPicture.asset(
        'assets/icons/home/${index + 1}.svg',
        width: 40,
        height: 40,
        color: Colors.blue,
      ),
    );
  }

  bool isPrayerNow(String time) {
    final now = DateTime.now();
    final target = parseTime(time);
    return now.isBefore(target) &&
        now.isAfter(target.subtract(const Duration(minutes: 30)));
  }

  DateTime parseTime(String time) {
    final now = DateTime.now();
    final parts = time.split(':'); // ["05", "10"]

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}
