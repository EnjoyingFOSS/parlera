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
import 'package:flutter_svg/svg.dart';
import 'package:parlera/database/database.dart';
import 'package:parlera/helpers/emoji.dart';
import 'package:parlera/helpers/layout.dart';

class ComboCard extends StatelessWidget {
  final CardDeck deck;

  const ComboCard({required this.deck, super.key});

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    final imagePath =
        deck.emoji != null ? EmojiHelper.getImagePath(deck.emoji!) : null;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: (imagePath != null)
                ? Container(
                    decoration: BoxDecoration(
                        color: deck.color,
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(16),
                    child: Center(child: SvgPicture.asset(imagePath)),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              deck.name,
              textAlign: TextAlign.center,
              style: mediaSize.width > LayoutHelper.breakpointXL
                  ? theme.textTheme.titleMedium
                  : theme.textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}
