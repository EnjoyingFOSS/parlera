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

import 'dart:core';

import 'package:parlera/helpers/db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parlera/models/category.dart';

import '../models/editable_category.dart';
import '../models/language.dart';

class CategoryRepository {
  final SharedPreferences storage;

  String _getFavoritesKey(ParleraLanguage lang) =>
      'category_favorite_list_${lang.langCode}';
  String _getPlayedCountKey(Category category) =>
      'category_played_count_${category.getUniqueId()}';

  CategoryRepository({required this.storage});

  Future<List<Category>> getAllCategories(ParleraLanguage lang) async =>
      await DBHelper.db.getAllCategories(lang);

  List<String> getFavoriteCategories(
      Map<String, Category> categories, ParleraLanguage lang) {
    final favoriteIds = storage.getStringList(_getFavoritesKey(lang));
    return favoriteIds?.where((id) => categories.containsKey(id)).toList() ??
        [];
  }

  Future<List<String>> toggleFavoriteCategory(
      List<String> favorites, Category selected) async {
    if (favorites.contains(selected.getUniqueId())) {
      favorites.remove(selected.getUniqueId());
    } else {
      favorites.add(selected.getUniqueId());
    }

    await storage.setStringList(_getFavoritesKey(selected.lang), favorites);

    return favorites;
  }

  int getPlayedCount(Category category) {
    return storage.getInt(_getPlayedCountKey(category)) ?? 0;
  }

  Future<int> increasePlayedCount(Category category) async {
    final gamesPlayed = getPlayedCount(category) + 1;
    await storage.setInt(_getPlayedCountKey(category), gamesPlayed);

    return gamesPlayed;
  }

  Future createOrUpdateCategory(EditableCategory ec) async {
    return await DBHelper.db.addOrUpdateCustomCategory(ec);
  }

  Future<int?> deleteCustomCategory(ParleraLanguage lang, int id) async {
    return await DBHelper.db.deleteCustomCategory(lang, id);
  }
}
