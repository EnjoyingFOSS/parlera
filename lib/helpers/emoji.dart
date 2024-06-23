// Copyright Miroslav Mazel
//
// This file is part of Parlera.
//
// Parlera is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// As an additional permission under section 7, you are allowed to distribute
// the software through an app store, even if that store has restrictive terms
// and conditions that are incompatible with the AGPL, provided that the source
// is also available under the AGPL with or without this permission through a
// channel without those restrictive terms and conditions.
//
// As a limitation under section 7, all unofficial builds and forks of the app
// must be clearly labeled as unofficial in the app's name (e.g. "Parlera
// UNOFFICIAL", never just "Parlera") or use a different name altogether.
// If any code changes are made, the fork should use a completely different name
// and app icon. All unofficial builds and forks MUST use a different
// application ID, in order to not conflict with a potential official release.
//
// Parlera is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with Parlera.  If not, see <http://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class EmojiHelper {
  static String getImagePath(String emoji) {
    if (emoji.runes.length > 1) {
      var nameString = p.join(
        'assets',
        'emoji',
        emoji.runes.first.toRadixString(16),
      );
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
      return p.join(
        'assets',
        'emoji',
        '${emoji.runes.first.toRadixString(16)}.svg',
      );
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
