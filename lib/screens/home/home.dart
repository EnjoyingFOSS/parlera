// Copyright Miroslav Mazel
//
// This file is part of Parlera.
//
// Parlera is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// As an additional permission under section 7, you are allowed to distribute
// the software through an app store, even if that store has restrictive terms
// and conditions that are incompatible with the AGPL, provided that the source
// is also available under the AGPL with or without this permission through a
// channel without those restrictive terms and conditions.
//
// As a limitation under section 7, all unofficial builds and forks of the app
// must be clearly labeled as unofficial in the app's name (e.g. "Parlera
// UNOFFICIAL", never just "Parlera") or use a different name altogether.
// If any code changes are made, the fork should use a completely different name
// and app icon. All unofficial builds and forks MUST use a different
// application ID, in order to not conflict with a potential official release.
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';
import 'package:parlera/screens/home/widgets/category_list.dart';
import 'package:parlera/screens/settings/settings.dart';
import 'package:parlera/store/category.dart';
import 'package:parlera/store/tutorial.dart';
import 'package:parlera/widgets/screen_loader.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

enum _NavItem {
  all(Icons.home_rounded),
  favorites(Icons.favorite_rounded),
  menu(Icons.menu_rounded);

  final IconData icon;

  const _NavItem(this.icon);

  String getLabel(BuildContext context) => switch (this) {
        _NavItem.all => "Parlera",
        _NavItem.favorites => AppLocalizations.of(context).favorites,
        _NavItem.menu => AppLocalizations.of(context).settings,
      };
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  CategoryFilter _currentCategory = CategoryFilter.all;

  @override
  void initState() {
    super.initState();
    if (!isTutorialWatched()) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) async => Navigator.pushNamed(
                context,
                '/tutorial',
              ));
    }
  }

  bool isTutorialWatched() {
    return TutorialModel.of(context).isWatched;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CategoryModel>(
      builder: (context, child, model) {
        final theme = Theme.of(context);
        if (model.isLoading) {
          return const ScreenLoader();
        }

        int currentIndex;
        switch (_currentCategory) {
          case CategoryFilter.all:
            currentIndex = _NavItem.all.index;
          case CategoryFilter.favorites:
            currentIndex = _NavItem.favorites.index;
        }

        return Scaffold(
            bottomNavigationBar: MoltenBottomNavigationBar(
              curve: Curves.easeOutExpo,
              domeWidth: 80,
              domeHeight: 12,
              borderRaduis: BorderRadius.zero,
              duration: const Duration(milliseconds: 500),
              barColor: theme.colorScheme.secondary,
              tabs: _NavItem.values
                  .map(
                    (navItem) => MoltenTab(
                      unselectedColor: theme.colorScheme.onSecondary,
                      icon: Semantics(
                        label: navItem.getLabel(context),
                        child: Icon(navItem.icon),
                      ),
                    ),
                  )
                  .toList(),
              selectedIndex: currentIndex,
              onTabChange: (i) async {
                switch (_NavItem.values[i]) {
                  case _NavItem.all:
                    setState(() {
                      _currentCategory = CategoryFilter.all;
                    });
                  case _NavItem.favorites:
                    setState(() {
                      _currentCategory = CategoryFilter.favorites;
                    });
                  case _NavItem.menu:
                    await SettingsScreen.showBottomSheet(context);
                }
              },
            ),
            body: CategoryList(
              type: _currentCategory,
            ));
      },
    );
  }
}
