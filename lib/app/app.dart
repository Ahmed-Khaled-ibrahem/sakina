import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:praying_app/app/routes/app_router.dart';
import 'package:praying_app/app/theme/app_theme.dart';
import 'package:praying_app/app/theme/theme_provider.dart';
import 'helpers/scafold_message.dart';

class App extends ConsumerWidget {
  App({super.key});

  final DateTime expiryDate = DateTime(2028, 3, 29);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime now = DateTime.now();
    final themeMode = ref.watch(themeModeProvider);
    final GoRouter router = ref.watch(appRouterProvider);

    if (now.isAfter(expiryDate)) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 100),
                Text(
                  "Sorry",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "This app is no longer available.",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ScreenUtilInit(
        designSize: Size(400, 900),
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          title: 'Sakina',
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          routerConfig: router,
        );
      }
    );
  }
}

