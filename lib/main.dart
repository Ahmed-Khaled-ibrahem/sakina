import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/app.dart';
import 'app/providers/all_app_provider.dart';

void main() {
  runZonedGuarded(
        () async {
      WidgetsFlutterBinding.ensureInitialized();
      await EasyLocalization.ensureInitialized();

      // Lock device orientation
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      try {
        await initializeDateFormatting(Intl.getCurrentLocale(), null);
      } catch (_) {
        await initializeDateFormatting('en', null);
      }


      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.dumpErrorToConsole(details);
      };

      ErrorWidget.builder = (FlutterErrorDetails details) {
        return Center(
          child: Text(
            "Something went wrong 😢",
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        );
      };

      runApp(
        EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('ar')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child: UncontrolledProviderScope(container: globalContainer,child: App(),),
        ),
      );
    },
        (error, stack) {
      print("Uncaught async error: $error");
      print(stack);
    },
  );
}
