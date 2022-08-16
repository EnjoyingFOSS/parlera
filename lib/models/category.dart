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

import 'dart:ui';

import 'package:parlera/models/category_type.dart';
import 'package:parlera/models/question.dart';

import 'language.dart';

class Category {
  static const jsonName = "name";
  static const jsonQs = "questions";
  static const jsonEmoji = "emoji";
  static const jsonBgColor = "bgColor";
  static const jsonLangCode = "langCode";

  final CategoryType type;
  final int sembastPos;
  final String name;
  final String emoji;
  final Color bgColor;
  final ParleraLanguage lang;
  final List<Question> questions;

  const Category({
    required this.type, //type and sembast ID together are the key
    required this.sembastPos,
    required this.name,
    required this.lang,
    required this.emoji,
    required this.bgColor,
    required this.questions,
  });

  Category.random(this.lang)
      : sembastPos = 0,
        type = CategoryType.random,
        emoji = "🎲",
        bgColor = const Color(0xFF282828),
        name = lang.randomName(),
        questions = [];

  Category.fromJson(
      this.lang, this.sembastPos, this.type, Map<String, dynamic> json)
      : name = json[jsonName],
        emoji = json[jsonEmoji] ?? "❔",
        bgColor = Color(json[jsonBgColor] ?? 0xFFFFFFFF),
        questions = (json[jsonQs] as List).map((q) => Question(q)).toList();

  Map<String, dynamic> toJson() => {
        jsonName: name,
        jsonEmoji: emoji,
        jsonBgColor: bgColor.value,
        jsonLangCode: lang,
        jsonQs: questions.map((q) => q.name).toList(),
      };

  String getUniqueId() => getUniqueIdFromInputs(lang, type, sembastPos);

  static String getUniqueIdFromInputs(
          ParleraLanguage lang, CategoryType type, int sembastPos) =>
      "${lang.langCode}___${type.toString()}___$sembastPos";
}
