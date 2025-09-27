import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExScreen extends ConsumerStatefulWidget {
  const ExScreen({super.key});
  @override
  ConsumerState createState() => _ExScreenState();
}

class _ExScreenState extends ConsumerState<ExScreen> {
  int selectedIndex = 0 ;
  final List<String> options = ["stretching".tr(), "breathing".tr()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('after_salah_exercise'.tr())),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(options.length, (index) {
                  return ChoiceChip(
                    label: Text(options[index]),
                    labelStyle: TextStyle(
                      color: selectedIndex == index ? Colors.blue : Colors.grey,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    selected: selectedIndex == index,
                    backgroundColor: Colors.transparent,
                    selectedColor: Colors.blue.withOpacity(0.1),
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
                          'timing'.tr(),
                        ),
                        cardDesign(
                          'assets/icons/ex/2.png',
                          Color(0xffFFEABF),
                          'bridge_pose'.tr(),
                          'timing'.tr(),
                        ),
                        cardDesign(
                          'assets/icons/ex/3.png',
                          Color(0xffA9B0FF),
                          'child_pose'.tr(),
                          'timing'.tr(),
                        ),
                        cardDesign(
                          'assets/icons/ex/4.png',
                          Color(0xffF8F9FD),
                          'downward_facing_pose'.tr(),
                          'timing'.tr(),
                        ),
                        cardDesign(
                          'assets/icons/ex/5.png',
                          Color(0xffFFEABF),
                          'cobra_pose'.tr(),
                          'timing'.tr(),
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
                        'timing'.tr(),
                      ),
                      cardDesign(
                        'assets/icons/ex/breath.png',
                        Color(0xffFFEABF),
                        'alternate_nostril_breathing'.tr(),
                        'timing'.tr(),
                      ),
                      cardDesign(
                        'assets/icons/ex/breath.png',
                        Color(0xffA9B0FF),
                        'breathing_4_7_8'.tr(),
                        'timing'.tr(),
                      ),
                      cardDesign(
                        'assets/icons/ex/breath.png',
                        Color(0xffF8F9FD),
                        'deep_belly_breathing'.tr(),
                        'timing'.tr(),
                      ),
                      cardDesign(
                        'assets/icons/ex/breath.png',
                        Color(0xffFFEABF),
                        'equal_breathing'.tr(),
                        'timing'.tr(),
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

  Widget cardDesign(String path, Color color, String name, String description) {
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Color(0xff2C2F41)
          : Colors.white,
      elevation: 2,
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
