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
import 'package:parlera/screens/category_creator/category_creator.dart';
import 'package:parlera/widgets/empty_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:parlera/store/category.dart';

import 'category_list_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum CategoryFilter { all, favorites }

class CategoryList extends StatelessWidget {
  final CategoryFilter type;

  const CategoryList({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = MediaQuery.of(context).size.width ~/ 480 + 1;

    return ScopedModelDescendant<CategoryModel>(
        builder: (context, child, model) {
      final categories = (type == CategoryFilter.favorites)
          ? model.favorites
          : model.categories;
      if (categories.isEmpty) {
        switch (type) {
          case CategoryFilter.favorites:
            return EmptyScreen(
                title: AppLocalizations.of(context).emptyFavorites,
                icon: const Icon(Icons.favorite_border_rounded, size: 96));
          case CategoryFilter.all:
            return EmptyScreen(
                title: AppLocalizations.of(context).emptyCategories,
                icon: const Icon(Icons.apps_rounded, size: 96));
        }
      } else {
        final title = (type == CategoryFilter.favorites)
            ? AppLocalizations.of(context).favorites
            : "Parlera";
        return SafeArea(
            child: CustomScrollView(
          primary: false,
          slivers: [
            SliverPadding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 12),
                sliver: SliverAppBar(
                  title: Text(title, style: const TextStyle(fontSize: 52)),
                  actions: [
                    IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      //todo figure out how to not clip on tap
                      onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CategoryCreatorScreen()))
                      },
                      icon: const Icon(Icons.add),
                      tooltip: AppLocalizations.of(context).btnCreateCategory,
                    )
                  ],
                )),
            SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverGrid.count(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio:
                        _getCardAspectRatio(context, crossAxisCount),
                    //
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: List.generate(
                        categories.length,
                        (index) => CategoryListItem(
                              category: categories[index],
                              onTap: () {
                                model.setCurrent(categories[index]);
                                Navigator.pushNamed(
                                  context,
                                  '/category',
                                );
                              },
                            ),
                        growable: false)))
          ],
        ));
      }
    });
  }

  double _getCardAspectRatio(BuildContext context, int crossAxisCount) {
    final itemWidth =
        (MediaQuery.of(context).size.width - 32 - 8 * (crossAxisCount - 1)) /
            crossAxisCount;
    const itemHeight = 80.0;

    return itemWidth / itemHeight;
  }
}
