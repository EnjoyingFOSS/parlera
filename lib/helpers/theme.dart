// This file is part of Parlera.
//
// Parlera is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version. As an additional permission under
// section 7, you are allowed to distribute the software through an app
// store, even if that store has restrictive terms and conditions that
// are incompatible with the AGPL, provided that the source is also
// available under the AGPL with or without this permission through a
// channel without those restrictive terms and conditions.
//
// Parlera is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with Parlera.  If not, see <http://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';

class ThemeHelper {
  static const _darkColors = ColorScheme(
      primary: Color(0xFFE33E46),
      secondary: Color(0xFFF7D0A1),
      surface: Color(0xFF48392a),
      background: Color(0xFF33291E),
      error: Color(0xFFE33E46),
      onPrimary: Colors.white,
      onSecondary: Colors.black87,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
      brightness: Brightness.dark);
  static const _fontFamily = 'MontserratAlternates';

  static const successColorLighter = Color(0xFF6b8f71); //417B5A 91c9bb 6b8f71
  static const failColorLighter = Color(0xFFE33E46);
  static const successColorDarker = Color(0xFF607B60);
  static const failColorDarker = Color(0xFFC0393E);
  static const successColorDarkest = Color(0xFF49523F);
  static const failColorDarkest = Color(0xFF7A312E);

  static final ThemeData darkTheme = _getThemeFromScheme(_darkColors);

  static ThemeData _getThemeFromScheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      iconTheme: const IconThemeData(weight: 700.0, grade: 200.0),
      colorScheme: colorScheme,
      visualDensity: VisualDensity.comfortable,
      brightness: colorScheme.brightness,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.background,
      cardColor: colorScheme.surface,
      dialogBackgroundColor: colorScheme.surface,
      pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder()
          }),
      dialogTheme: DialogTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
      fontFamily: _fontFamily,
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        filled: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
      bottomAppBarTheme:
          const BottomAppBarTheme(height: 48, padding: EdgeInsets.all(0)),
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: colorScheme.surface,
          surfaceTintColor: Colors.transparent),
      snackBarTheme: SnackBarThemeData(
        actionTextColor: colorScheme.onSecondary,
        backgroundColor: colorScheme.secondary,
      ),
      buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          height: 48),
      textTheme:
          TextTheme(headlineMedium: TextStyle(color: colorScheme.onBackground)),
      canvasColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
          color: colorScheme.background,
          iconTheme: IconThemeData(color: colorScheme.onBackground),
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: colorScheme.onBackground),
          centerTitle: false,
          elevation: 0),
      switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color?>((states) =>
              (!states.contains(MaterialState.disabled) &&
                      states.contains(MaterialState.selected))
                  ? colorScheme.primary
                  : null),
          trackColor: MaterialStateProperty.resolveWith<Color?>(
              (states) => //TODO check
                  (!states.contains(MaterialState.disabled) &&
                          states.contains(MaterialState.selected))
                      ? colorScheme.primary.withAlpha(80)
                      : null)),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>((states) =>
            (!states.contains(MaterialState.disabled) &&
                    states.contains(MaterialState.selected))
                ? colorScheme.primary
                : null),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>((states) =>
            (!states.contains(MaterialState.disabled) &&
                    states.contains(MaterialState.selected))
                ? colorScheme.primary
                : null),
      ),
    );
  }
}
