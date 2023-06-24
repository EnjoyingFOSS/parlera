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

class EmojiHelper {
  // TODO add search!
  static String getImagePath(String emoji) {
    if (emoji.runes.length > 1) {
      var nameString = "assets/emoji/${emoji.runes.first.toRadixString(16)}";
      for (int i = 1; i < emoji.runes.length; i++) {
        //skips the fe0f indicator, which indicates color emoji versions and isn't present in svg names
        final r = emoji.runes.elementAt(i);
        if (r == 0xfe0f) {
          continue;
        } else {
          nameString += "_${emoji.runes.elementAt(i).toRadixString(16)}";
        }
      }
      return "$nameString.svg";
    } else {
      return "assets/emoji/${emoji.runes.first.toRadixString(16)}.svg";
    }
  }

  static Future<bool> imageExists(
      BuildContext context, String imagePath) async {
    try {
      final bundle = DefaultAssetBundle.of(context);
      await bundle.load(imagePath);
      return true;
    } catch (_) {
      return false;
    }
  }
}
