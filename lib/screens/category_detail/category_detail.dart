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

import 'package:flutter/material.dart';
import 'package:parlera/helpers/orientation.dart';
import 'package:parlera/models/category_type.dart';
import 'package:parlera/screens/category_detail/widgets/empty_category.dart';
import 'package:parlera/screens/category_detail/widgets/game_settings.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:parlera/store/category.dart';

import 'widgets/category_header.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({Key? key}) : super(key: key);

  Widget buildRoundTimeSelectItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CategoryModel>(
      builder: (context, _, model) {
        final category = model.currentCategory!;

        final scheme = category.getDarkColorScheme();

        if (category.questions.isEmpty &&
            category.type != CategoryType.random) {
          return const EmptyCategory();
        }

        final stronglyLandscape =
            OrientationHelper.isStronglyLandscape(context);
        return Scaffold(
            backgroundColor: scheme.surface,
            body: stronglyLandscape
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: CategoryHeader(
                        model: model,
                        category: category,
                        onFavorite: () => model.toggleFavorite(category),
                        isFavorite: model.isFavorite(category),
                        isLandscape: stronglyLandscape,
                      )),
                      const SizedBox(
                        width: 32,
                      ),
                      Expanded(child: GameSetings(scheme: scheme)),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        CategoryHeader(
                          model: model,
                          category: category,
                          onFavorite: () => model.toggleFavorite(category),
                          isFavorite: model.isFavorite(category),
                          isLandscape: stronglyLandscape,
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        GameSetings(scheme: scheme),
                      ],
                    ),
                  ));
      },
    );
  }
}
