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
import 'package:palette_generator/palette_generator.dart';

class DynamicColorHelper {
  static Color backgroundColorDark(PaletteGenerator paletteGenerator) {
    return paletteGenerator.darkMutedColor?.color ??
        _darkenColor(paletteGenerator.dominantColor?.color) ??
        Colors.transparent;
  }

  static Color backgroundColorLight(PaletteGenerator paletteGenerator) {
    return paletteGenerator.lightMutedColor?.color ??
        _brightenColor(paletteGenerator.dominantColor?.color) ??
        Colors.transparent;
  }

  static Color? _brightenColor(Color? color) {
    if (color == null) return null;

    final hslColor = HSLColor.fromColor(color);

    return hslColor
        .withLightness(1 - ((1 - hslColor.lightness) / 4))
        .withSaturation(1 - ((1 - hslColor.saturation) / 2))
        .toColor();
  }

  static Color? _darkenColor(Color? color) {
    if (color == null) return null;

    final hslColor = HSLColor.fromColor(color);

    return hslColor
        .withLightness(hslColor.lightness / 4)
        .withSaturation(hslColor.saturation / 2)
        .toColor();
  }
}
