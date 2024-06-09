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

import 'package:parlera/models/category.dart';
import 'package:parlera/models/language.dart';

class EditableCategory {
  static const _defaultEmoji = "❔";
  static const _defaultBgColor = Color(0xFF393939);

  int? sembastPos;
  String? name;
  List<String>? cards;
  Color bgColor;
  String emoji;
  ColorScheme? darkColorScheme;
  int? standardGameTime;
  late ParleraLanguage lang;

  EditableCategory(
      {this.name,
      this.emoji = _defaultEmoji,
      this.bgColor = _defaultBgColor,
      this.cards,
      ParleraLanguage? lang,
      this.sembastPos,
      this.standardGameTime}) {
    this.lang = lang ??
        ParleraLanguage
            .defaultLang; //this is meant as just temporary, the langCode should be updated after
  }

  EditableCategory.fromCategory(Category category)
      : sembastPos = category.sembastPos,
        name = category.name,
        cards = category.cards.map((q) => q.phrase).toList(),
        bgColor = category.bgColor,
        lang = category.lang,
        emoji = category.emoji,
        standardGameTime = category.standardGameTime;

  EditableCategory.fromJson(Map<String, dynamic> json, this.lang)
      : name = json[Category.jsonName] as String?,
        cards = (json[Category.jsonCards] as List<dynamic>)
            .map((dynamic e) => e.toString())
            .toList(),
        bgColor = Color(json[Category.jsonBgColor] as int),
        emoji = json[Category.jsonEmoji] as String,
        standardGameTime = json[Category.jsonStandardGameTime] as int?;

  ColorScheme generateDarkColorScheme() {
    darkColorScheme =
        ColorScheme.fromSeed(seedColor: bgColor, brightness: Brightness.dark);
    return darkColorScheme!;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      Category.jsonName: name,
      Category.jsonCards: cards,
      Category.jsonEmoji: emoji,
      Category.jsonBgColor: bgColor.value,
      Category.jsonStandardGameTime: standardGameTime
    };
  }
}
