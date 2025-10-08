import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0066CC),
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  );

  static ThemeData get darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF66AAFF),
      brightness: Brightness.dark,
    ),
      scaffoldBackgroundColor: Color(0xFF2C2F41),
    useMaterial3: true,
  );
}
