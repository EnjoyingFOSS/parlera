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

import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parlera/flavors.dart';
import 'package:parlera/helpers/import_export.dart';
import 'package:parlera/helpers/layout.dart';
import 'package:parlera/helpers/url_launcher.dart';
import 'package:parlera/models/language.dart';
import 'package:parlera/screens/category_creator/category_creator.dart';
import 'package:parlera/screens/home/widgets/category_list_item.dart';
import 'package:parlera/store/category.dart';
import 'package:parlera/store/language.dart';
import 'package:parlera/widgets/empty_screen.dart';
import 'package:parlera/widgets/max_width_container.dart';
import 'package:parlera/widgets/parlera_card.dart';
import 'package:scoped_model/scoped_model.dart';

enum CategoryFilter { all, favorites }

class CategoryList extends StatelessWidget {
  static const String _menuCreate = "create";
  static const String _menuImport = "import";
  static const String _menuGetOnline = "getOnline";

  final CategoryFilter type;

  const CategoryList({
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final containerWidth =
        min(MediaQuery.of(context).size.width, LayoutXL.cols12.width);
    final crossAxisCount = containerWidth ~/ 480 + 1;

    return MaxWidthContainer(child:
        ScopedModelDescendant<LanguageModel>(builder: (context, _, langModel) {
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
                  icon: Icon(
                    Icons.favorite_border_rounded,
                    size: 96,
                    color: Theme.of(context).colorScheme.onBackground,
                  ));
            case CategoryFilter.all:
              return EmptyScreen(
                  title: AppLocalizations.of(context).emptyCategories,
                  icon: Icon(
                    Icons.apps_rounded,
                    size: 96,
                    color: Theme.of(context).colorScheme.onBackground,
                  ));
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
                      PopupMenuButton(
                        icon: const Icon(Icons.add_rounded),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        tooltip: AppLocalizations.of(context).menuAddCategory,
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                              value: _menuCreate,
                              child: Text(AppLocalizations.of(context)
                                  .btnCreateCategory)),
                          PopupMenuItem<String>(
                              value: _menuImport,
                              child: Text(AppLocalizations.of(context)
                                  .btnImportCategory)),
                          PopupMenuItem<String>(
                              value: _menuGetOnline,
                              child: Text(AppLocalizations.of(context)
                                  .btnGetCategoriesOnline))
                        ],
                        onSelected: (String value) async {
                          switch (value) {
                            case _menuCreate:
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const CategoryCreatorScreen()));
                              break;
                            case _menuGetOnline:
                              UrlLauncher.launchURL(context,
                                  'https://gitlab.com/enjoyingfoss/parlera-categories');
                              break;
                            case _menuImport:
                              final scaffoldMessengerState =
                                  ScaffoldMessenger.of(context);
                              final categoryImported =
                                  AppLocalizations.of(context)
                                      .txtCategoryImported;
                              try {
                                final fpr = await FilePicker.platform
                                    .pickFiles(withData: Platform.isLinux);

                                if (fpr != null) {
                                  final inputFile = fpr.files.first;

                                  await ImportExportHelper.importFile(
                                      inputFile,
                                      model,
                                      langModel.lang ??
                                          ParleraLanguage.defaultLang);

                                  scaffoldMessengerState.showSnackBar(SnackBar(
                                      content: Text(categoryImported)));
                                }
                                break;
                              } catch (_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)
                                                .errorCouldNotImport)));
                                return;
                              }
                          }
                        },
                      ),
                    ],
                  )),
              SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverGrid.count(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: _getCardAspectRatio(
                          context, containerWidth, crossAxisCount),
                      //
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      children: List.generate(
                          categories.length,
                          (index) => CategoryListItem(
                                category: categories[index],
                                onTap: () async {
                                  model.setCurrent(categories[index]);
                                  await Navigator.pushNamed(
                                    context,
                                    '/category',
                                  );
                                },
                              ),
                          growable: false))),
              if (F.appFlavor == Flavor.free)
                SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Divider(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withAlpha(63),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ParleraCard(
                              onTap: () {
                                UrlLauncher.launchURL(context,
                                    "https://play.google.com/store/apps/details?id=com.enjoyingfoss.parlera.full");
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          "${AppLocalizations.of(context).paidTitle} ",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold)),
                                      Text(
                                          //TODO more bundled categories in the paid version
                                          AppLocalizations.of(context)
                                              .paidDescription,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ))
            ],
          ));
        }
      });
    }));
  }

  double _getCardAspectRatio(
      BuildContext context, double containerWidth, int crossAxisCount) {
    final itemWidth =
        (containerWidth - 32 - 8 * (crossAxisCount - 1)) / crossAxisCount;
    const itemHeight = 80.0;

    return itemWidth / itemHeight;
  }
}
