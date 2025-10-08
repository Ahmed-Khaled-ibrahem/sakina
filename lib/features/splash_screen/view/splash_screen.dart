import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/routes/app_router.dart';
import '../../../app/routes/routes.dart';
import '../providers/real_time_data.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(appRouterProvider);
    ref.watch(realtimeDatabaseProvider('/'));

    Future.delayed(const Duration(seconds: 2), () {
      router.go(AppRoutes.login);
    });

    return Scaffold(
      body: Center(child: Padding(
        padding: const EdgeInsets.all(30),
        child: Image.asset('assets/logo.png'),
      )),
    );
  }
}
