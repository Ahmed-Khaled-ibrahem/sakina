import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:praying_app/features/azkar/azkar_screen.dart';
import 'package:praying_app/features/excersise/ex_screen.dart';
import 'package:praying_app/features/navigation_layout/provider/navigation_provider.dart';
import '../calender/calender_screen.dart';
import '../home/view/home_screen.dart';
import '../qibla/qibla_screen.dart';
import '../settings/provider/device_id_provider.dart';
import '../settings/settings_screen.dart';
import '../splash_screen/providers/real_time_data.dart';

class NavigationLayout extends ConsumerStatefulWidget {
  const NavigationLayout({super.key});
  @override
  ConsumerState createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<NavigationLayout> {
  final List<Widget> pages = [
    HomeScreen(),
    QiblaScreen(),
    AzkarScreen(),
    ExScreen(),
    CalenderScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final currentData = ref.read(realtimeDataStateProvider);
    final data = ref.watch(textValueProvider);

    if(currentData?.keys.contains(data) ?? false){
      return Scaffold(
        extendBody: true,
        body: IndexedStack(index: currentIndex, children: pages),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            clipBehavior: Clip.antiAlias,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Color(0xff2C2F41)
                  : Colors.white,
              currentIndex: currentIndex,
              showSelectedLabels: false,
              selectedFontSize: 1,
              unselectedFontSize: 1,
              showUnselectedLabels: false,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              onTap: (index) {
                ref.read(navigationIndexProvider.notifier).state = index;
              },
              items: [
                buildBottomNavigationBar('assets/icons/nav/1.svg', "Home", false),
                buildBottomNavigationBar('assets/icons/nav/2.png', "Qibla", true),
                buildBottomNavigationBar(
                  'assets/icons/nav/3.svg',
                  "Azkar",
                  false,
                ),
                buildBottomNavigationBar(
                  'assets/icons/nav/4.svg',
                  "Exercise",
                  false,
                ),
                buildBottomNavigationBar(
                  'assets/icons/nav/5.svg',
                  "Calender",
                  false,
                ),
                buildBottomNavigationBar(
                  'assets/icons/nav/6.svg',
                  "Settings",
                  false,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return SettingsScreen();
  }

  BottomNavigationBarItem buildBottomNavigationBar(
    String path,
    String label,
    bool isPng,
  ) {
    final double iconsSize = 25;
    final double paddingValue = 10;
    return BottomNavigationBarItem(
      icon: isPng
          ? Padding(
              padding: EdgeInsets.only(top: paddingValue),
              child: Image.asset(
                path,
                color: Color(0xffB3B3B3),
                height: iconsSize,
              ),
            )
          : Padding(
              padding: EdgeInsets.only(top: paddingValue),
              child: SvgPicture.asset(
                path,
                color: Color(0xffB3B3B3),
                height: iconsSize,
              ),
            ),
      activeIcon: isPng
          ? Padding(
              padding: EdgeInsets.only(top: paddingValue),
              child: Image.asset(
                path,
                color: Color(0xff3551F2),
                height: iconsSize,
              ),
            )
          : Padding(
              padding: EdgeInsets.only(top: paddingValue),
              child: SvgPicture.asset(
                path,
                color: Color(0xff3551F2),
                height: iconsSize,
              ),
            ),
      label: label,
    );
  }
}
