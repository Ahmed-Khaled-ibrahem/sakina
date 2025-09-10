import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:praying_app/features/azkar/azkar_screen.dart';
import 'package:praying_app/features/excersise/ex_screen.dart';
import 'package:praying_app/features/navigation_layout/provider/navigation_provider.dart';
import '../home/view/home_screen.dart';
import '../qibla/qibla_screen.dart';
import '../settings/settings_screen.dart';

class NavigationLayout extends ConsumerStatefulWidget {
  const NavigationLayout({super.key});
  @override
  ConsumerState createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<NavigationLayout> {
  List<NavbarItem> items = [
    NavbarItem(
      Icons.home_outlined,
      'Home',
      backgroundColor: mediumPurple,
      selectedIcon: Icon(Icons.home, size: 26),
    ),
    NavbarItem(
      Icons.check_box_sharp,
      'Qibla',
      backgroundColor: Colors.orange,
      selectedIcon: Icon(Icons.shopping_bag, size: 26),
    ),
    NavbarItem(
      Icons.line_style,
      'Azkar',
      backgroundColor: Colors.teal,
      selectedIcon: Icon(Icons.line_style, size: 26),
    ),
    NavbarItem(
      Icons.data_saver_off,
      'Exercise',
      backgroundColor: Colors.teal,
      selectedIcon: Icon(Icons.data_saver_off, size: 26),
    ),
    NavbarItem(
      Icons.settings,
      'Settings',
      backgroundColor: Colors.teal,
      selectedIcon: Icon(Icons.settings, size: 26),
    ),
  ];

  final Map<int, Map<String, Widget>> _routes = {
    0: {'/': HomeScreen()},
    1: {'/': QiblaScreen()},
    2: {'/': AzkarScreen()},
    3: {'/': ExScreen()},
    4: {'/': SettingsScreen()},
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NavbarRouter(
      errorBuilder: (context) {
        return const Center(child: Text('Error 404'));
      },
      onBackButtonPressed: (isExiting) {
        return isExiting;
      },
      destinationAnimationCurve: Curves.fastOutSlowIn,
      destinationAnimationDuration: 300,
      decoration: NavbarDecoration(
        navbarType: BottomNavigationBarType.shifting,
        borderRadius: BorderRadius.circular(100),
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        isExtended: true,
        backgroundColor: Colors.black,
        elevation: 20,
        height: 60,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        showSelectedLabels: false,
      ),
      shouldPopToBaseRoute: true,
      type: NavbarType.floating,
      onChanged: (index) {
        ref.read(navigationIndexProvider.notifier).state = index;
      },
      destinations: [
        for (int i = 0; i < items.length; i++)
          DestinationRouter(
            navbarItem: items[i],
            destinations: [
              for (int j = 0; j < _routes[i]!.keys.length; j++)
                Destination(
                  route: _routes[i]!.keys.elementAt(j),
                  widget: _routes[i]!.values.elementAt(j),
                ),
            ],
            initialRoute: _routes[i]!.keys.first,
          ),
      ],
    );
  }
}
