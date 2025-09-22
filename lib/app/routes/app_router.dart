import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:praying_app/app/routes/routes.dart';
import 'package:praying_app/features/auth/view/login_page.dart';
import '../../features/auth/view/signup_page.dart';
import '../../features/azkar/views/evening_screen.dart';
import '../../features/azkar/views/prayer_screen.dart';
import '../../features/navigation_layout/navigation_screen.dart';
import '../../features/splash_screen/view/splash_screen.dart';
import '../wrapper/app_wrapper.dart';
import 'dart:async';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    // ensure broadcast so multiple listeners don't cause problems
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

final _rootNavigatorKeyProvider = Provider<GlobalKey<NavigatorState>>(
  (ref) => GlobalKey<NavigatorState>(),
);

final appRouterProvider = Provider<GoRouter>((ref) {
  final GlobalKey<NavigatorState> rootKey = ref.watch(
    _rootNavigatorKeyProvider,
  );

  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: AppRoutes.base,
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
    redirect: (context, state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final isLoggingIn =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup;

      if (!isLoggedIn && !isLoggingIn) {
        return AppRoutes.login;
      }

      if (isLoggedIn && isLoggingIn) {
        return AppRoutes.home;
      }

      return null; // no redirect
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppWrapper(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.base,
            builder: (context, state) => const SplashScreen(),
          ),
          GoRoute(
            path: AppRoutes.login,
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: AppRoutes.signup,
            builder: (context, state) => const SignupPage(),
          ),
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const NavigationLayout(),
          ),
          GoRoute(
            path: AppRoutes.azkharMorning,
            builder: (context, state) => const EveningScreen(isEvening: false),
          ),
          GoRoute(
            path: AppRoutes.azkharEvening,
            builder: (context, state) => const EveningScreen(isEvening: true),
          ),
          GoRoute(
            path: AppRoutes.azkharPraying,
            builder: (context, state) => const PrayerScreen(),
          ),
        ],
      ),
    ],
  );
});
