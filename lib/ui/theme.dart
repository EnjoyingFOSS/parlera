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
//
// This file is derived from work covered by the following license notice:
//
//   Copyright 2021 Kamil Rykowski, Kamil Lewandowski, and Ewa Osiecka
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

const Color primaryColor = Color(0xFF102636);
const Color primaryDarkColor = Color(0xFF0a1822);
const Color primaryLightColor = Color(0xFF16344a);

const Color secondaryColor = Color(0xFF984E99);
const Color secondaryDarkColor = Color(0xFF874588);
const Color secondaryLightColor = Color(0xFFa857a9);

const Color successColor = Colors.green;

const Color textColor = Color(0xFFEEEEEE);

final isTablet = Device.get().isTablet;

ThemeData createTheme(BuildContext context) {
  ThemeData theme = ThemeData(
    fontFamily: 'MontserratAlternates',
    brightness: Brightness.dark,
    backgroundColor: primaryDarkColor,
    indicatorColor: secondaryColor,
    scaffoldBackgroundColor: Colors.transparent,
    primaryColorDark: primaryDarkColor,
    primaryColorLight: primaryLightColor,
    primaryColor: primaryColor,
    toggleableActiveColor: secondaryLightColor,
    iconTheme: const IconThemeData(
      color: Color(0xFFFFFFFF),
    ),
    dividerColor: Colors.white30,
    textTheme: Theme.of(context).textTheme.apply(
      fontFamily: 'MontserratAlternates',
          bodyColor: textColor,
          displayColor: const Color(0xFF757575),
          fontSizeFactor: isTablet ? 1.75 : 1.0,
        ),
    buttonTheme: ButtonThemeData(
      height: isTablet ? 56.0 : 42.0,
      minWidth: 180,
      buttonColor: secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1000),
      ),
    ),
    sliderTheme: SliderTheme.of(context).copyWith(
      activeTickMarkColor: Colors.transparent,
      activeTrackColor: secondaryDarkColor,
      thumbColor: secondaryColor,
      inactiveTickMarkColor: secondaryColor,
      inactiveTrackColor: primaryDarkColor,
      overlayColor: secondaryLightColor.withOpacity(0.5),
    ),
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(secondary: secondaryColor, brightness: Brightness.dark),
  );

  return theme;
}

class ThemeConfig {
  static final appBarHeight = isTablet ? 74.0 : 32.0;
  static final appBarIconSize = isTablet ? 50.0 : 24.0;
  static final appBarFontSize = isTablet ? 36.0 : 20.0;

  static final backButtonHeight = isTablet ? 80.0 : 50.0;

  static final categoriesGridCount = isTablet ? 3 : 2;
  static final categoriesTextHeight = isTablet ? 55.0 : 35.0;
  static final categoriesMetaSize = isTablet ? 14.0 : 10.0;
  static final categoryImageSize = isTablet ? 280.0 : 170.0;

  static final fullScreenIconSize = isTablet ? 164.0 : 96.0;
}
