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
//   Copyright 2021 Kamil Rykowski, Kamil Lewandowski, and "ewaosie"
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

class CategoryModel extends StoreModel {
  CategoryRepository repository;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Map<String?, Category?> _categories = {};
  List<Category?> get categories => _categories.values.toList();

  List<String?> _favourites = [];
  List<Category?> get favourites =>
      _favourites.map((id) => _categories[id]).where((c) => c != null).toList();

  Category? _currentCategory;
  Category? get currentCategory => _currentCategory;

  Map<String?, int> _playedCount = {};
  Map<String?, int> get playedCount => _playedCount;

  CategoryModel(this.repository);

  load(String languageCode) async {
    _isLoading = true;
    notifyListeners();

    _categories = Map.fromIterable(
      await repository.getAll(languageCode),
      key: (c) => c.id,
      value: (c) => c,
    );
    _favourites = repository.getFavorites();
    _isLoading = false;
    notifyListeners();
  }

  setCurrent(Category? category) {
    _currentCategory = category;
    notifyListeners();
  }

  isFavorite(Category category) {
    return _favourites.contains(category.id);
  }

  toggleFavorite(Category category) {
    _favourites = repository.toggleFavorite(_favourites, category);
    notifyListeners();
  }

  getPlayedCount(Category category) {
    if (!_playedCount.containsKey(category.id)) {
      _playedCount[category.id] = repository.getPlayedCount(category);
    }

    return _playedCount[category.id];
  }

  increasePlayedCount(Category category) async {
    _playedCount[category.id] = repository.increasePlayedCount(category);
    notifyListeners();
  }

  static CategoryModel of(BuildContext context) =>
      ScopedModel.of<CategoryModel>(context);
}
