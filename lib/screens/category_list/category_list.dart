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

import 'package:flutter/material.dart';
import 'package:parlera/widgets/empty_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:parlera/store/category.dart';

import 'widgets/category_list_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum CategoryType { all, favorites }

class CategoryListScreen extends StatelessWidget {
  final CategoryType type;

  const CategoryListScreen({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = MediaQuery.of(context).size.width ~/ 480 + 1;

    return ScopedModelDescendant<CategoryModel>(
        builder: (context, child, model) {
      final categories =
          (type == CategoryType.favorites) ? model.favorites : model.categories;
      if (categories.isEmpty) {
        switch (type) {
          case CategoryType.favorites:
            return EmptyScreen(
                title: AppLocalizations.of(context).emptyFavorites,
                icon: const Icon(Icons.favorite_border, size: 96));
          case CategoryType.all:
            return EmptyScreen(
                title: AppLocalizations.of(context).emptyCategories,
                icon: const Icon(Icons.apps, size: 96));
        }
      } else {
        return GridView.count(
          childAspectRatio: _getCardAspectRatio(context, crossAxisCount),
          shrinkWrap: true,
          primary: false,
          padding: const EdgeInsets.all(8),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          crossAxisCount: crossAxisCount,
          children: categories.map((category) {
            return CategoryListItem(
              category: category,
              onTap: () {
                model.setCurrent(category);
                //   'category_select',
                //   {'category': category.name},
                // );
                Navigator.pushNamed(
                  context,
                  '/category',
                );
              },
            );
          }).toList(),
        );
      }
    });
  }

  double _getCardAspectRatio(BuildContext context, int crossAxisCount) {
    final itemWidth =
        (MediaQuery.of(context).size.width - 32 - 8 * (crossAxisCount - 1)) /
            crossAxisCount;
    const itemHeight = 96.0;

    return itemWidth / itemHeight;
  }
}
