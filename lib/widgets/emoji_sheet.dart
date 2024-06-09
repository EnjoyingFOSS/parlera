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

import 'dart:io';
import 'dart:math';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parlera/helpers/layout.dart';

class EmojiSheet extends StatelessWidget {
  final Function(Category?, Emoji)? onEmojiSelected;

  const EmojiSheet({required this.onEmojiSelected, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final mediaSize = MediaQuery.sizeOf(context);
    
    final columnCount = min(mediaSize.width.toInt() ~/ 60, 12);
    final bgColor = theme.colorScheme.surface;
    final fgColor = theme.colorScheme.onSurface;
    final searchBgColor = theme.colorScheme.surfaceContainerLow;

    return EmojiPicker(
        config: Config(
            skinToneConfig: SkinToneConfig(
              dialogBackgroundColor: bgColor,
              indicatorColor: fgColor,
            ),
            emojiViewConfig: EmojiViewConfig(
              buttonMode: (Platform.isMacOS || Platform.isIOS)
                  ? ButtonMode.CUPERTINO
                  : ButtonMode.MATERIAL,
              replaceEmojiOnLimitExceed: true,
              noRecents: Text(
                l10n.txtNoRecentEmoji,
                style: TextStyle(fontSize: 20, color: fgColor),
                textAlign: TextAlign.center,
              ),
              verticalSpacing:
                  mediaSize.width < LayoutHelper.breakpointSheet ? 0 : 12,
              columns: columnCount,
              backgroundColor: bgColor,
            ),
            searchViewConfig: SearchViewConfig(
              hintText: l10n.btnSearchEmojis,
              backgroundColor: searchBgColor,
              buttonIconColor: fgColor,
            ),
            categoryViewConfig: CategoryViewConfig(
              backgroundColor: bgColor,
              iconColor: fgColor.withOpacity(0.6),
              iconColorSelected: Theme.of(context).colorScheme.secondary,
              indicatorColor: Theme.of(context).colorScheme.secondary,
              dividerColor: searchBgColor,
            ),
            bottomActionBarConfig: BottomActionBarConfig(
              backgroundColor: searchBgColor,
              buttonIconColor: fgColor,
              buttonColor: bgColor,
              customBottomActionBar: (config, state, showSearchView) {
                return Material(
                    color: config.bottomActionBarConfig.backgroundColor,
                    child: InkWell(
                        onTap: showSearchView,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search,
                                color: config
                                    .bottomActionBarConfig.buttonIconColor,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  l10n.btnSearchEmojis,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                      color: config.bottomActionBarConfig
                                          .buttonIconColor),
                                ),
                              )
                            ],
                          ),
                        )
                        ));
              },
            ),
            checkPlatformCompatibility: false,
            emojiTextStyle: Platform.isLinux
                ? TextStyle(
                    fontFamily: "NotoEmoji",
                    color: Theme.of(context).colorScheme.onSurface)
                : TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        onEmojiSelected: onEmojiSelected);
  }
}
