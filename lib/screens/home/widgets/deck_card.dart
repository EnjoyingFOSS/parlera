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
import 'package:parlera/helpers/hero.dart';
import 'package:parlera/screens/home/widgets/parlera_card.dart';

class DeckCard extends StatelessWidget {
  final CardDeck deck;
  final Function() onTap;

  const DeckCard({required this.deck, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final imagePath =
        deck.emoji != null ? EmojiHelper.getImagePath(deck.emoji!) : null;
    return ParleraCard(
      onTap: onTap,
      child: Stack(
        children: [
          if (imagePath != null)
            PositionedDirectional(
              end: -6,
              top: 4,
              bottom: 4,
              child: AspectRatio(
                aspectRatio: 1,
                child: Hero(
                  tag: HeroHelper.tagForDeck(deck),
                  child: SvgPicture.asset(imagePath),
                ),
              ),
            ),
          PositionedDirectional(
            start: 16,
            end: 80,
            top: 2,
            bottom: 2,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                deck.name,
                style: const TextStyle(
                  fontSize: 21,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
