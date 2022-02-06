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
        final stronglyLandscape =
            OrientationHelper.isStronglyLandscape(context);
        return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () => model.toggleFavorite(category),
                  icon: Icon(
                    model.isFavorite(category)
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                  ),
                )
              ],
            ),
            body: stronglyLandscape
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: CategoryHeader(category: category)),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: VerticalDivider(
                          indent: 8,
                          endIndent: 8,
                        ),
                      ),
                      const Expanded(child: GameSetings()),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        CategoryHeader(category: category),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            indent: 32,
                            endIndent: 32,
                          ),
                        ),
                        const GameSetings(),
                      ],
                    ),
                  ));
      },
    );
  }
}
