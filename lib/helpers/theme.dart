import 'package:flutter/material.dart';

class ThemeHelper {
  static const _darkColors = ColorScheme(
      primary: Color(0xFFE33E46),
      primaryVariant: Color(0xFFEB7076),
      secondary: Color(0xFFF7D0A1),
      secondaryVariant: Color(0xFFFAE3C6),
      surface: Colors.black,
      background: Colors.black,
      error: Color(0xFFB00020),
      onPrimary: Colors.black87,
      onSecondary: Colors.black87,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
      brightness: Brightness.dark);

  static final successColor = Colors.green;
  static final failColor = Colors.red;

  static final ThemeData darkTheme = _getThemeFromScheme(_darkColors);

  static ThemeData _getThemeFromScheme(ColorScheme colors) {
    return ThemeData(
        colorScheme: colors,
        visualDensity: VisualDensity.comfortable,
        backgroundColor: colors.background,
        brightness: colors.brightness,
        primaryColor: colors.primary,
        primaryColorDark: colors.primaryVariant,
        scaffoldBackgroundColor: colors.background,
        cardColor: colors.surface,
        errorColor: colors.error,
        toggleableActiveColor: colors.primary,
        fontFamily: 'MontserratAlternates',
        appBarTheme: AppBarTheme(
            color: colors.background,
            iconTheme: IconThemeData(color: colors.primary),
            titleTextStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: colors.primary),
            centerTitle: false,
            elevation: 0));
  }
}
