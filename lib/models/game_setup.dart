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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parlera/database/database.dart';
import 'package:parlera/helpers/emoji.dart';
import 'package:parlera/helpers/hero.dart';
import 'package:parlera/models/full_deck_companion.dart';
import 'package:path/path.dart' as p;

enum GameSetupType {
  deck(defaultColor: FullDeckCompanion.defaultColor),
  combo(defaultColor: Color(0xFF503B2B));

  final Color defaultColor;

  const GameSetupType({required this.defaultColor});

  String getDefaultEmojiPath() => switch (this) {
        deck => EmojiHelper.getImagePath(FullDeckCompanion.defaultEmoji),
        combo => p.join('assets', 'emoji', 'parlera_combo.svg')
      };
}

class GameSetup {
  final GameSetupType gameSetupType;
  final List<String> gameCards;
  final CardDeck? deck;
  final DeckContents? deckContents;
  final int gameDurationS;
  final bool isUnlimitedCardMode;
  final ColorScheme darkColorScheme;

  GameSetup(
      {required this.gameSetupType,
      required this.gameCards,
      required this.deck,
      required this.deckContents,
      required this.gameDurationS,
      required this.isUnlimitedCardMode})
      : darkColorScheme = ColorScheme.fromSeed(
            seedColor: deck?.color ?? gameSetupType.defaultColor,
            brightness: Brightness.dark) {
    assert(gameSetupType != GameSetupType.deck || deck != null);
  }

  GameSetup copyWith({
    GameSetupType? gameSetupType,
    CardDeck? deck,
    DeckContents? deckContents,
    List<String>? gameCards,
    int? gameDurationS,
    bool? isUnlimitedCardMode,
  }) {
    return GameSetup(
      gameSetupType: gameSetupType ?? this.gameSetupType,
      deck: deck ?? this.deck,
      deckContents: deckContents ?? this.deckContents,
      gameCards: gameCards ?? this.gameCards,
      gameDurationS: gameDurationS ?? this.gameDurationS,
      isUnlimitedCardMode: isUnlimitedCardMode ?? this.isUnlimitedCardMode,
    );
  }

  String get emojiPath => deck?.emoji != null
      ? EmojiHelper.getImagePath(deck!.emoji!)
      : gameSetupType.getDefaultEmojiPath();

  String get heroTag => switch (gameSetupType) {
        GameSetupType.deck => HeroHelper.tagForDeck(deck!),
        GameSetupType.combo => HeroHelper.tagForCombo(),
      };

  String getName(BuildContext context) => switch (gameSetupType) {
        GameSetupType.deck => deck!.name,
        GameSetupType.combo => AppLocalizations.of(context).combo,
      };
}
