import 'package:flutter/material.dart';

class MyTheme {
  MyTheme._();

  // Colors
  static Color primary = Colors.red.shade900;

  static Color editButtonColor = Colors.green;

  // Constats
  static double sizeBtwnSections = 16.0;

  // ThemeData
  static ThemeData themeData = ThemeData(
      useMaterial3: true,
      elevatedButtonTheme: elevatedButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      appBarTheme: appBarTheme,
      primarySwatch: Colors.red,
      textSelectionTheme:
          TextSelectionThemeData(selectionHandleColor: MyTheme.primary, selectionColor: MyTheme.primary.withOpacity(0.4)));

  static ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.red.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(vertical: 20),
    ),
  );

  static OutlinedButtonThemeData outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.red.shade900,
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.red.shade900),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(vertical: 20),
    ),
  );

  static AppBarTheme appBarTheme = AppBarTheme(
      backgroundColor: Colors.red.shade900,
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      foregroundColor: Colors.white);
}
