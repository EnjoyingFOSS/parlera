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

import 'dart:ui';

import 'package:parlera/helpers/language.dart';

import 'category.dart';

class EditableCategory {
  static const _defaultEmoji = "❔";
  static const _defaultBgColor = Color(0xFF393939);

  int? sembastPos;
  String? name;
  List<String>? questions;
  Color bgColor;
  String emoji;
  late String langCode;

  EditableCategory(
      {this.name,
      this.emoji = _defaultEmoji,
      this.bgColor = _defaultBgColor,
      this.questions,
      langCode,
      this.sembastPos}) {
    this.langCode = langCode ??
        LanguageHelper.defaultLocale
            .languageCode; //this is meant as just temporary, the langCode should be updated after
  }

  EditableCategory.fromCategory(Category category)
      : sembastPos = category.sembastPos,
        name = category.name,
        questions = category.questions.map((q) => q.name).toList(),
        bgColor = category.bgColor,
        langCode = category.langCode,
        emoji = category.emoji;

  EditableCategory.fromJson(Map<String, dynamic> json, this.langCode)
      : name = json[Category.jsonName],
        questions = (json[Category.jsonQs] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        bgColor = Color(json[Category.jsonBgColor]),
        emoji = json[Category.jsonEmoji];

  Map<String, dynamic> toJson() {
    return {
      Category.jsonName: name,
      Category.jsonQs: questions,
      Category.jsonEmoji: emoji,
      Category.jsonBgColor: bgColor.value
    };
  }
}
