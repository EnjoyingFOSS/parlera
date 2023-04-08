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
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:parlera/helpers/emoji.dart';
import 'package:parlera/helpers/hero.dart';
import 'package:parlera/helpers/import_export.dart';
import 'package:parlera/models/category.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parlera/models/category_type.dart';
import 'package:parlera/models/editable_category.dart';
import 'package:parlera/screens/category_creator/category_creator.dart';

import '../../../store/category.dart';

class CategoryHeader extends StatelessWidget {
  static const String _menuDelete = "delete";
  static const String _menuEdit = "edit";
  static const String _menuDuplicate = "duplicate";
  static const String _menuExport = "export";

  final CategoryModel model;
  final Category category;
  final bool isLandscape;
  final Function() onFavorite;
  final bool isFavorite;

  const CategoryHeader(
      {Key? key,
      required this.model,
      required this.category,
      required this.onFavorite,
      required this.isFavorite,
      required this.isLandscape})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageProvider = Svg(EmojiHelper.getImagePath(category.emoji));
    return Container(
        color: category.bgColor,
        padding: const EdgeInsets.only(bottom: 32),
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          AppBar(
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                tooltip: AppLocalizations.of(context).btnFavorite,
                onPressed: onFavorite,
                icon: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) {
                  return category.type == CategoryType.custom
                      ? [
                          PopupMenuItem<String>(
                              value: _menuEdit,
                              child:
                                  Text(AppLocalizations.of(context).btnEdit)),
                          PopupMenuItem<String>(
                              value: _menuDuplicate,
                              child: Text(
                                  AppLocalizations.of(context).btnDuplicate)),
                          PopupMenuItem<String>(
                              value: _menuExport,
                              child:
                                  Text(AppLocalizations.of(context).btnExport)),
                          PopupMenuItem<String>(
                              value: _menuDelete,
                              child:
                                  Text(AppLocalizations.of(context).btnDelete)),
                        ]
                      : [
                          PopupMenuItem<String>(
                              value: _menuDuplicate,
                              child: Text(
                                  AppLocalizations.of(context).btnDuplicate)),
                          PopupMenuItem<String>(
                              value: _menuExport,
                              child:
                                  Text(AppLocalizations.of(context).btnExport)),
                        ];
                },
                onSelected: (String value) async {
                  switch (value) {
                    case _menuDelete:
                      model.deleteCustomCategory(
                          category.sembastPos, category.lang);
                      Navigator.pop(context);
                      break;
                    case _menuEdit:
                      Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (context) => CategoryCreatorScreen(
                                ec: EditableCategory.fromCategory(category),
                              )));
                      break;
                    case _menuDuplicate:
                      final ec = EditableCategory.fromCategory(category);
                      ec.sembastPos = null;
                      Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (context) => CategoryCreatorScreen(
                                ec: ec,
                              )));
                      break;
                    case _menuExport:
                      try {
                        await ImportExportHelper.exportJson(
                            category.toJson(),
                            "${category.name}.parlera",
                            "[Parlera export] ${category.name}");
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              AppLocalizations.of(context).errorCouldNotExport),
                        ));
                      }
                      break;
                  }
                },
              )
            ],
          ),
          if (isLandscape) const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Hero(
              tag: HeroHelper.categoryImage(category),
              child: Image(
                image: imageProvider,
                height: 160,
                width: 160,
              ),
            ),
          ),
          Text(
            category.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          if (isLandscape) const Spacer(),
        ]));
  }
}
