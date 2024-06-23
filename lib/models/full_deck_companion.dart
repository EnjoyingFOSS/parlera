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

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:parlera/database/database.dart';
import 'package:parlera/enums/license.dart';
import 'package:parlera/models/parlera_locale.dart';

class FullDeckCompanion {
  static const _jsonName = "name";
  static const _jsonCards = "questions";
  static const _jsonEmoji = "emoji";
  static const _jsonColor = "bgColor";
  static const _jsonLocaleCode = "locale";
  static const _jsonGameDurationS = "gameTime";
  static const _jsonAuthor = "author";
  static const _jsonLicense = "license";

  static const defaultEmoji = "❔";
  static const defaultColor = Color(0xFF484848);

  CardDeckTableCompanion deckCompanion;
  DeckContentTableCompanion contentCompanion;

  FullDeckCompanion._({
    required this.deckCompanion,
    required this.contentCompanion,
  });

  factory FullDeckCompanion.empty(ParleraLocale locale) => FullDeckCompanion._(
      deckCompanion: CardDeckTableCompanion(
        name: const Value(""),
        emoji: const Value(defaultEmoji),
        color: const Value(defaultColor),
        localeCode: Value(locale.getLocaleCode()),
        license: const Value(License.copyrighted),
        isBundled: const Value(false),
        isFavorited: const Value(false),
      ),
      contentCompanion: const DeckContentTableCompanion(cards: Value([])));

  factory FullDeckCompanion.fromExisting(
          CardDeck deck, DeckContents contents) =>
      FullDeckCompanion._(
          deckCompanion: deck.toCompanion(false),
          contentCompanion: contents.toCompanion(false));

  factory FullDeckCompanion.duplicateExisting(
          CardDeck deck, DeckContents contents) =>
      FullDeckCompanion._(
          deckCompanion: deck.toCompanion(false).copyWith(
              id: const Value.absent(),
              isBundled: const Value(false),
              isFavorited: const Value(false)),
          contentCompanion:
              contents.toCompanion(false).copyWith(deck: const Value.absent()));

  factory FullDeckCompanion.fromJson(
      Map<String, dynamic> json, ParleraLocale? newLocale) {
    final licenseString = json[_jsonLicense] as String?;
    return FullDeckCompanion._(
      deckCompanion: CardDeckTableCompanion(
        name: Value.absentIfNull(json[_jsonName] as String?),
        color: Value.absentIfNull(Color(json[_jsonColor] as int)),
        emoji: Value.absentIfNull(json[_jsonEmoji] as String?),
        mediumGameDurationS: Value.absentIfNull(json[_jsonGameDurationS] as int?),
        localeCode: Value.absentIfNull(
            newLocale?.getLocaleCode() ?? json[_jsonLocaleCode] as String?),
        author: Value.absentIfNull(json[_jsonAuthor] as String?),
        license: Value.absentIfNull(
            licenseString != null ? License.fromJson(licenseString) : null),
        isFavorited: const Value(false),
        isBundled: const Value(false),
      ),
      contentCompanion: DeckContentTableCompanion(
        cards: Value.absentIfNull((json[_jsonCards] as List<dynamic>?)
            ?.map((dynamic e) => e.toString())
            .toList(growable: false)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      _jsonName: deckCompanion.name.value,
      _jsonColor: deckCompanion.color.value.value,
      _jsonEmoji: deckCompanion.emoji.value,
      _jsonGameDurationS: deckCompanion.mediumGameDurationS.value,
      _jsonLocaleCode: deckCompanion.localeCode.value,
      _jsonAuthor: deckCompanion.author.value,
      _jsonLicense: deckCompanion.license.value.toJson(),
      _jsonCards: contentCompanion.cards.value,
    };
  }

  ColorScheme generateDarkColorScheme() => ColorScheme.fromSeed(
      seedColor: deckCompanion.color.value, brightness: Brightness.dark);
}
