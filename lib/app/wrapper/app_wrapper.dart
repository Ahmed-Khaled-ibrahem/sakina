import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/home/provider/city_provider.dart';
import '../../features/home/provider/prayer_provider.dart';
import '../routes/app_router.dart';

class AppWrapper extends ConsumerWidget {
  final Widget child;

  const AppWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(locationProvider);

    return Builder(
      builder: (context) {
        final router = ref.read(appRouterProvider);
        WidgetsBinding.instance.addPostFrameCallback((_) {

        });
        return child;
      },
    );
  }
}
