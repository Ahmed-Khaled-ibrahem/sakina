import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/auth_provider/auth_provider.dart';
import '../../features/home/provider/city_provider.dart';
import '../routes/app_router.dart';
import '../routes/routes.dart';

class AppWrapper extends ConsumerStatefulWidget {
  const AppWrapper({super.key, required this.child});

  final Widget child;

  @override
  AppWrapperState createState() => AppWrapperState();
}

class AppWrapperState extends ConsumerState<AppWrapper> {

  @override
  Widget build(BuildContext context) {
    ref.read(locationProvider);

    return Builder(
      builder: (context) {
        final router = ref.read(appRouterProvider);
        WidgetsBinding.instance.addPostFrameCallback((_) {

        });
        return widget.child;
      },
    );
  }
}

