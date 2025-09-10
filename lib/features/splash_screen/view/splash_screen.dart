import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/routes/app_router.dart';
import '../../../app/routes/routes.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(appRouterProvider);

    Future.delayed(const Duration(seconds: 2), () {
      router.go(AppRoutes.home);
    });

    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.png'),
      )
    );
  }
}
