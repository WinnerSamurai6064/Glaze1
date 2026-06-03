import 'package:flutter/material.dart';

class GlazeTheme {
  static const orange = Color(0xFFFF6B00);
  static const oledBlack = Color(0xFF000000);
  static const cardBlack = Color(0xFF080808);
  static const softWhite = Color(0xFFEFEFEF);
  static const mutedWhite = Color(0x99FFFFFF);

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: oledBlack,
      colorScheme: ColorScheme.fromSeed(
        seedColor: orange,
        brightness: Brightness.dark,
        primary: orange,
        surface: cardBlack,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: softWhite,
        displayColor: softWhite,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: orange),
        ),
      ),
    );
  }
}
