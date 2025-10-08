import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:praying_app/app/helpers/colors.dart';
import '../../app/providers/all_app_provider.dart';

class ExScreen extends ConsumerStatefulWidget {
  const ExScreen({super.key});
  @override
  ConsumerState createState() => _ExScreenState();
}

class _ExScreenState extends ConsumerState<ExScreen> {
  int selectedIndex = 0 ;

  @override
  Widget build(BuildContext context) {
    final refreshValue = ref.watch(refreshProvider);
    final List<String> options = ["stretching".tr(), "breathing".tr()];

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 0.07.sh),
              Row(
                children: [
                  Text("after_salah_exercise".tr(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(options.length, (index) {
                  return ChoiceChip(
                    label: Text(options[index]),
                    labelStyle: TextStyle(
                      color: selectedIndex == index ? AppColors.mainColor : Colors.grey,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    selected: selectedIndex == index,
                    backgroundColor: Colors.transparent,
                    selectedColor: AppColors.mainColor.withOpacity(0.1),
                    // selectedColor: Colors.blue.shade200,
                    onSelected: (selected) {
                      setState(() {
                        selectedIndex = selected ? index : 0;
                      });
                    },
                  );
                }),
              ),
              Builder(
                builder: (context) {
                  if (selectedIndex == 0){
                    return Column(
                      children: [
                        cardDesign(
                          'assets/icons/ex/1.png',
                          Color(0xffF8F9FD),
                          'plank_pose'.tr(),
                          'des6'.tr()
                        ),
                        cardDesign(
                          'assets/icons/ex/2.png',
                          Color(0xffFFEABF),
                          'bridge_pose'.tr(),
                          'des7'.tr()
                        ),
                        cardDesign(
                          'assets/icons/ex/3.png',
                          Color(0xffA9B0FF),
                          'child_pose'.tr(),
                          'des8'.tr()
                        ),
                        cardDesign(
                          'assets/icons/ex/4.png',
                          Color(0xffF8F9FD),
                          'downward_facing_pose'.tr(),
                          'des9'.tr()
                        ),
                        cardDesign(
                          'assets/icons/ex/5.png',
                          Color(0xffFFEABF),
                          'cobra_pose'.tr(),
                          'des10'.tr()
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      cardDesign(
                        'assets/icons/ex/breath.png',
                        Color(0xffF8F9FD),
                        'box_breathing'.tr(),
                        'des1'.tr()
                      ),
                      cardDesign(
                        'assets/icons/ex/breath.png',
                        Color(0xffFFEABF),
                        'alternate_nostril_breathing'.tr(),
                          'des2'.tr()
                      ),
                      cardDesign(
                        'assets/icons/ex/breath.png',
                        Color(0xffA9B0FF),
                        'breathing_4_7_8'.tr(),
                          'des3'.tr()
                      ),
                      cardDesign(
                        'assets/icons/ex/breath.png',
                        Color(0xffF8F9FD),
                        'deep_belly_breathing'.tr(),
                          'des4'.tr()
                      ),
                      cardDesign(
                        'assets/icons/ex/breath.png',
                        Color(0xffFFEABF),
                        'equal_breathing'.tr(),
                          'des5'.tr()
                      ),
                    ],
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardDesign(String path, Color color, String name, String subtitle) {
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Color(0xff2C2F41)
          : Colors.white,
      elevation: 10,
      shadowColor: AppColors.mainColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 80,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: color,
            ),
            child: Image.asset(path),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.w300),
                ),
                Row(
                  children: [
                    Image.asset('assets/icons/ex/timer.png', width: 20, height: 20),
                    SizedBox(width: 5),
                    Text(
                      'timing1'.tr(),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(width: 5),
                    Image.asset('assets/icons/ex/redo.png', width: 20, height: 20),
                    SizedBox(width: 5),
                    Text(
                      'timing2'.tr(),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
