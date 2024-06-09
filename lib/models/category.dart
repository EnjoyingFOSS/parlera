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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:parlera/models/category_type.dart';
import 'package:parlera/models/game_time_type.dart';
import 'package:parlera/models/language.dart';
import 'package:parlera/models/phrase_card.dart';

class Category {
  static const jsonName = "name";
  static const jsonCards = "questions";
  static const jsonEmoji = "emoji";
  static const jsonBgColor = "bgColor";
  static const jsonLocaleCode = "langCode";
  static const jsonStandardGameTime = "gameTime";

  static const maxGameTime = 9999;
  static const defaultGameTime = 60;

  final CategoryType type;
  final int sembastPos;
  final String name;
  final String emoji;
  final Color bgColor;
  final ParleraLanguage lang;
  final List<PhraseCard> cards;
  final int? standardGameTime;

  ColorScheme? _darkColorScheme;

  Category(
      {required this.type, //type and sembast ID together are the key
      required this.sembastPos,
      required this.name,
      required this.lang,
      required this.emoji,
      required this.bgColor,
      required this.cards,
      this.standardGameTime});

  Category.random(this.lang)
      : sembastPos = 0,
        type = CategoryType.random,
        emoji = "🎲",
        bgColor = const Color(0xFF282828),
        name = lang.randomName,
        cards = [],
        standardGameTime = null;

  Category.fromJson(
      this.lang, this.sembastPos, this.type, Map<String, dynamic> json)
      : name = json[jsonName] as String? ?? "",
        emoji = json[jsonEmoji] as String? ?? "❔",
        bgColor = Color(json[jsonBgColor] as int? ?? 0xFFFFFFFF),
        cards = (json[jsonCards] as List<dynamic>)
            .map((dynamic card) => PhraseCard(card as String))
            .toList(),
        standardGameTime = json[jsonStandardGameTime] as int?;

  Map<String, dynamic> toJson() => <String, dynamic>{
        jsonName: name,
        jsonEmoji: emoji,
        jsonBgColor: bgColor.value,
        jsonLocaleCode: lang.getLocaleCode(),
        jsonCards: cards.map((card) => card.phrase).toList(),
        jsonStandardGameTime: standardGameTime
      };

  int getGameTime(GameTimeType type, double gameTimeMultiplier,
      int settingsCustomGameTime) {
    final mediumGameTime =
        ((standardGameTime ?? defaultGameTime) * gameTimeMultiplier).ceil();
    final mediumGameTimeDiv2 = max(mediumGameTime ~/ 2, 1);
    switch (type) {
      case GameTimeType.short:
        return mediumGameTimeDiv2;
      case GameTimeType.medium:
        return mediumGameTime;
      case GameTimeType.long:
        return mediumGameTime + mediumGameTimeDiv2;
      case GameTimeType.custom:
        return settingsCustomGameTime;
    }
  }

  String getUniqueId() => getUniqueIdFromInputs(lang, type, sembastPos);

  ColorScheme getDarkColorScheme() {
    _darkColorScheme ??=
        ColorScheme.fromSeed(seedColor: bgColor, brightness: Brightness.dark);
    return _darkColorScheme!;
  }

  static String getUniqueIdFromInputs(
          ParleraLanguage lang, CategoryType type, int sembastPos) =>
      "${lang.getLocaleCode()}___${type.toString()}___$sembastPos";
}
