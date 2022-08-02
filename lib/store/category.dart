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

import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:parlera/models/category.dart';
import 'package:parlera/repository/category.dart';
import 'package:parlera/store/store.dart';

import '../models/editable_category.dart';

class CategoryModel extends StoreModel {
  CategoryRepository repository;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Map<String, Category> _categories = {};
  List<Category> get categories => _categories.values.toList();

  List<String> _favorites = [];
  List<Category> get favorites =>
      _favorites.map((id) => _categories[id]!).toList();

  Category? _currentCategory;
  Category? get currentCategory => _currentCategory;

  final Map<String, int> _playedCount = {};
  Map<String, int> get playedCount => _playedCount;

  CategoryModel(this.repository);

  Future<void> load(String langCode) async {
    _isLoading = true;
    notifyListeners();

    _categories = await _loadCategories(langCode);
    _favorites = repository.getFavoriteCategories(_categories, langCode);
    _isLoading = false;
    notifyListeners();
  }

  Future<Map<String, Category>> _loadCategories(String langCode) async => {
        for (var c in await repository.getAllCategories(langCode))
          c.getUniqueId(): c
      };

  void setCurrent(Category category) {
    _currentCategory = category;
    notifyListeners();
  }

  bool isFavorite(Category category) {
    return _favorites.contains(category.getUniqueId());
  }

  Future<void> toggleFavorite(Category category) async {
    _favorites = await repository.toggleFavoriteCategory(
      _favorites,
      category,
    );
    notifyListeners();
  }

  int? getPlayedCount(Category category) {
    if (!_playedCount.containsKey(category.getUniqueId())) {
      _playedCount[category.getUniqueId()] =
          repository.getPlayedCount(category);
    }

    return _playedCount[category.getUniqueId()];
  }

  Future<void> increasePlayedCount(Category category) async {
    _playedCount[category.getUniqueId()] =
        await repository.increasePlayedCount(category);
    notifyListeners();
  }

  Future<void> createCategory(EditableCategory ec) async {
    await repository.createCategory(ec);
    _categories = await _loadCategories(ec.langCode);
    notifyListeners();
  }

  static CategoryModel of(BuildContext context) =>
      ScopedModel.of<CategoryModel>(context);
}
