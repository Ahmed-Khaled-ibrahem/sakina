import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:praying_app/app/helpers/colors.dart';
import 'package:praying_app/features/azkar/views/progress_bar.dart';
import '../model/azkar_model.dart';
import '../repo/azkar_helper.dart';

class EveningScreen extends ConsumerWidget {
  final bool isEvening;

  const EveningScreen({super.key, required this.isEvening});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Dhikr>?>(
      future: getData(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (asyncSnapshot.hasError) {
          return Center(child: Text('Error: ${asyncSnapshot.error}'));
        }
        List<Dhikr> dhikrList = asyncSnapshot.data!;
        if (dhikrList.isEmpty) {
          return const Center(child: Text('No data available'));
        }
        return DhikrScreen(dhikrList: dhikrList, isEvening: isEvening);
      },
    );
  }

  Future<List<Dhikr>?> getData() async {
    return await DhikrHelper.loadDhikr('assets/azkhar/ar.json');
  }
}

class DhikrScreen extends StatefulWidget {
  final List<Dhikr> dhikrList;
  final bool isEvening;

  const DhikrScreen({
    super.key,
    required this.dhikrList,
    required this.isEvening,
  });

  @override
  State<DhikrScreen> createState() => _DhikrScreenState();
}

class _DhikrScreenState extends State<DhikrScreen> {
  int currentIndex = 0;
  int remainingCount = 0;

  @override
  void initState() {
    super.initState();
    remainingCount = widget.dhikrList[currentIndex].count;
  }

  void nextDhikr() {
    if (currentIndex + 1 == widget.dhikrList.length) {
      Navigator.pop(context);
    }

    if (currentIndex < widget.dhikrList.length - 1) {
      setState(() {
        currentIndex++;
        remainingCount = widget.dhikrList[currentIndex].count;
      });
    }
  }

  void previousDhikr() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        remainingCount = widget.dhikrList[currentIndex].count;
      });
    }
  }

  void decreaseCount() {
    if (remainingCount > 0) {
      setState(() {
        remainingCount--;
      });
    }
    if (remainingCount == 0) {
      nextDhikr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dhikr = widget.dhikrList[currentIndex];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff2945e3), Color(0xff526bef)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Text(
              widget.isEvening ? 'evening'.tr() : 'morning'.tr(),
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
                '${currentIndex + 1} / ${widget.dhikrList.length}',
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
        backgroundColor: Colors.transparent,
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dhikr.countDescription,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: previousDhikr,
                      child: const Icon(Icons.arrow_back_ios_outlined),
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: Theme.of(context).brightness == Brightness.dark
                              ? Color(0xFF3142A4)
                              : Colors.white,
                        )
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
                        backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Color(0xFF3142A4)
                            : Colors.white,
                        foregroundColor: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.mainColor,
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
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: Theme.of(context).brightness == Brightness.dark
                              ? Color(0xFF3142A4)
                              : Colors.white,
                        )
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomProgressBar(
                    percentage:
                        currentIndex / (widget.dhikrList.length + 1) * 100,
                    progressColor: AppColors.mainColor,
                    backgroundColor: Colors.grey.shade300,
                    height: 6,
                  ),
                  SizedBox(
                    height: 0.8.sh,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dhikr.content.trim(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (dhikr.translation != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                dhikr.translation!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          const SizedBox(height: 20),
                          Divider(color: Colors.white, thickness: 0.5),
                          Text(
                            "Fadl: ${dhikr.fadl}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            "Source: ${dhikr.source}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
