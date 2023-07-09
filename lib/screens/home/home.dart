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
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';
import 'package:parlera/screens/home/widgets/category_list.dart';
import 'package:parlera/screens/settings/settings.dart';
import 'package:parlera/widgets/screen_loader.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parlera/store/category.dart';
import 'package:parlera/store/tutorial.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

enum _NavItem { all, favorites, menu }

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  CategoryFilter _currentCategory = CategoryFilter.all;

  @override
  void initState() {
    super.initState();
    if (!isTutorialWatched()) {
      WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushNamed(
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
        if (model.isLoading) {
          return const ScreenLoader();
        }

        int currentIndex;
        switch (_currentCategory) {
          case CategoryFilter.all:
            currentIndex = _NavItem.all.index;
            break;
          case CategoryFilter.favorites:
            currentIndex = _NavItem.favorites.index;
            break;
        }

        return Scaffold(
            bottomNavigationBar: MoltenBottomNavigationBar(
              curve: Curves.easeOutExpo,
              domeWidth: 80,
              domeHeight: 12,
              borderRaduis: BorderRadius.zero,
              duration: const Duration(milliseconds: 500),
              barColor: Theme.of(context).colorScheme.secondary,
              tabs: _NavItem.values.map((navItem) {
                switch (navItem) {
                  case _NavItem.all:
                    return MoltenTab(
                      unselectedColor:
                          Theme.of(context).colorScheme.onSecondary,
                      icon: Semantics(
                          label: "Parlera",
                          child: const Icon(Icons.home_rounded)),
                    );
                  case _NavItem.favorites:
                    return MoltenTab(
                      unselectedColor:
                          Theme.of(context).colorScheme.onSecondary,
                      icon: Semantics(
                          label: AppLocalizations.of(context).favorites,
                          child: const Icon(Icons.favorite_rounded)),
                    );
                  case _NavItem.menu:
                    return MoltenTab(
                      unselectedColor:
                          Theme.of(context).colorScheme.onSecondary,
                      icon: Semantics(
                          label: AppLocalizations.of(context).settings,
                          child: const Icon(Icons.menu_rounded)),
                    );
                }
              }).toList(),
              selectedIndex: currentIndex,
              onTabChange: (i) {
                switch (_NavItem.values[i]) {
                  case _NavItem.all:
                    setState(() {
                      _currentCategory = CategoryFilter.all;
                    });
                    break;
                  case _NavItem.favorites:
                    setState(() {
                      _currentCategory = CategoryFilter.favorites;
                    });
                    break;
                  case _NavItem.menu:
                    SettingsScreen.showBottomSheet(context);
                    break;
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
