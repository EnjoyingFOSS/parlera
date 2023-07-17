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

import 'dart:io';
import 'dart:math';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmojiSheet extends StatelessWidget {
  final Function(Category?, Emoji)? onEmojiSelected;

  const EmojiSheet({super.key, required this.onEmojiSelected});

  @override
  Widget build(BuildContext context) {
    //TODO add search
    final columnCount =
        min(MediaQuery.of(context).size.width.toInt() ~/ 60, 12);
    return EmojiPicker(
        config: Config(
            replaceEmojiOnLimitExceed: true,
            buttonMode: (Platform.isMacOS || Platform.isIOS)
                ? ButtonMode.CUPERTINO
                : ButtonMode.MATERIAL,
            bgColor: Theme.of(context).colorScheme.surface,
            iconColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            iconColorSelected: Theme.of(context).colorScheme.secondary,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            skinToneDialogBgColor: Theme.of(context).colorScheme.surface,
            skinToneIndicatorColor: Theme.of(context).colorScheme.onSurface,
            checkPlatformCompatibility: false,
            columns: columnCount,
            noRecents: Text(
              AppLocalizations.of(context).txtNoRecentEmoji,
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            emojiTextStyle: Platform.isLinux
                ? TextStyle(
                    fontFamily: "NotoEmoji",
                    color: Theme.of(context).colorScheme.onSurface)
                : TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        onEmojiSelected: onEmojiSelected);
  }
}
