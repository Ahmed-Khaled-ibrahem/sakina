import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:praying_app/app/routes/routes.dart';
import '../../features/navigation_layout/navigation_screen.dart';
import '../../features/splash_screen/view/splash_screen.dart';
import '../wrapper/app_wrapper.dart';

final _rootNavigatorKeyProvider = Provider<GlobalKey<NavigatorState>>(
  (ref) => GlobalKey<NavigatorState>(),
);

final appRouterProvider = Provider<GoRouter>((ref) {
  final GlobalKey<NavigatorState> rootKey = ref.watch(
    _rootNavigatorKeyProvider,
  );

  return GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppWrapper(child: child);
        },
        routes: [
          GoRoute(path: AppRoutes.base, builder: (context, state) => const SplashScreen()),
          GoRoute(path: AppRoutes.home, builder: (context, state) => const NavigationLayout()),
        ],
      ),

      // other routes...
    ],
  );
});
