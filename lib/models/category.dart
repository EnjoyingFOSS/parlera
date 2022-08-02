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

import 'package:parlera/models/category_type.dart';

class Category {
  static const jsonImage = "image";
  static const jsonName = "name";
  static const jsonQs = "questions";
  static const jsonEmoji = "emoji";

  static const _randomImage = 'assets/images/categories/random.webp';

  final CategoryType type;
  final int _sembastId;
  final String name;
  final String? image;
  final String langCode;
  final List questions;

  const Category({
    required this.type, //type and sembast ID together are the key
    required int sembastId,
    required this.name,
    required this.langCode,
    this.image,
    // this.emoji,
    // this.bgColor,
    required this.questions,
  }) : _sembastId = sembastId;

  Category.random(this.langCode, String translatedName)
      : _sembastId = 0,
        type = CategoryType.random,
        image = _randomImage,
        name = translatedName,
        questions = [];

  Category.fromJson(
      this.langCode, int sembastId, this.type, Map<String, dynamic> json)
      : _sembastId = sembastId,
        name = json[jsonName],
        image = json[jsonImage],
        // emoji = json['emoji'],
        // bgColor = json['bgColor'],
        questions = json[
            jsonQs]; //TODO not List.from(json['questions'].map((name) => Question(name, json['name'])))?

  String getUniqueId() => getUniqueIdFromInputs(langCode, type, _sembastId);

  static String getUniqueIdFromInputs(
          String langCode, CategoryType type, int sembastId) =>
      "${langCode}___${type.toString()}___$sembastId";

  String getImagePath() => type == CategoryType.random
      ? _randomImage
      : (image != null
          ? 'assets/images/categories/$image'
          : 'assets/images/categories/missing.webp');
}
