import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../model/prayer_zekr_model.dart';
import '../repo/azkar_helper.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});
  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  int currentIndex = 0;
  int remainingCount = 0;
  List<PrayerDhikr> dhikrList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await PrayerDhikrHelper.loadPrayerDhikr(
      'assets/azkhar/pray.json',
    );
    setState(() {
      dhikrList = data;
      remainingCount = dhikrList.first.repeat;
    });
  }

  void nextDhikr() {
    if (currentIndex < dhikrList.length - 1) {
      setState(() {
        currentIndex++;
        remainingCount = dhikrList[currentIndex].repeat;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void previousDhikr() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        remainingCount = dhikrList[currentIndex].repeat;
      });
    }
  }

  void decreaseCount() {
    if (remainingCount > 0) {
      setState(() => remainingCount--);
    }
    if (remainingCount == 0) nextDhikr();
  }

  @override
  Widget build(BuildContext context) {
    if (dhikrList.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final dhikr = dhikrList[currentIndex];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff2945e3), Color(0xff526bef)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: previousDhikr,
                      child: const Icon(Icons.arrow_back_ios_outlined),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: decreaseCount,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        elevation: 10,
                        padding: const EdgeInsets.all(18),
                        // size of the button
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                      ),
                      child: Text(
                        '$remainingCount',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: nextDhikr,
                      child: const Icon(Icons.arrow_forward_ios_outlined),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Text(
              'after_salah'.tr(),
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          actions: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${currentIndex + 1} / ${dhikrList.length}',
                style: TextStyle(color: Colors.blue, fontSize: 12),
              ),
            ),
            SizedBox(width: 10),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  dhikr.arabicText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (dhikr.translatedText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      dhikr.translatedText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
