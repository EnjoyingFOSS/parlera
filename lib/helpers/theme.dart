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

  static const emojiStyle = TextStyle(
      decoration: TextDecoration.none,
      textBaseline: TextBaseline.ideographic,
      fontFamily: "NotoColorEmoji");

  static final ThemeData darkTheme = _getThemeFromScheme(_darkColors);

  static ThemeData _getThemeFromScheme(ColorScheme colors) {
    return ThemeData(
        useMaterial3: false,
        colorScheme: colors,
        visualDensity: VisualDensity.comfortable,
        backgroundColor: colors.background,
        brightness: colors.brightness,
        primaryColor: colors.primary,
        scaffoldBackgroundColor: colors.background,
        cardColor: colors.surface,
        errorColor: colors.error,
        dialogBackgroundColor: colors.surface,
        dialogTheme: DialogTheme(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        toggleableActiveColor: colors.primary,
        fontFamily: _fontFamily,
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
          filled: true,
        ),
        navigationRailTheme: NavigationRailThemeData(
            useIndicator: false,
            backgroundColor: colors.secondary,
            unselectedIconTheme: IconThemeData(
                color: colors.onSecondary
                    .withAlpha(90)), //todo use with material 3, opacity: 0.35),
            selectedIconTheme: IconThemeData(color: colors.primary)),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100))),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            unselectedItemColor: colors.onSecondary.withAlpha(90),
            backgroundColor: colors.secondary,
            selectedItemColor: colors.primary),
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: colors.surface),
        snackBarTheme: SnackBarThemeData(
          actionTextColor: colors.onSecondary,
          backgroundColor: colors.secondary,
        ),
        buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            height: 48),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ))),
        textTheme: TextTheme(headline4: TextStyle(color: colors.onBackground)),
        canvasColor: colors.surface,
        appBarTheme: AppBarTheme(
            color: colors.background,
            iconTheme: IconThemeData(color: colors.onBackground),
            titleTextStyle: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: colors.onBackground),
            centerTitle: false,
            elevation: 0));
  }
}
