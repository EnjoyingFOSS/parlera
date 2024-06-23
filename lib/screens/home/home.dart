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

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';
import 'package:parlera/providers/deck_list_provider.dart';
import 'package:parlera/screens/home/widgets/combo_subscreen.dart';
import 'package:parlera/screens/home/widgets/deck_list_subscreen.dart';
import 'package:parlera/screens/settings/settings.dart';

enum _NavItem {
  all(Icons.home_rounded),
  favorites(Icons.favorite_rounded),
  combo(Icons.category_rounded),
  menu(Icons.menu_rounded);

  final IconData icon;

  const _NavItem(this.icon);

  String getLabel(BuildContext context) => switch (this) {
        _NavItem.all => "Parlera",
        _NavItem.favorites => AppLocalizations.of(context).favorites,
        _NavItem.combo => AppLocalizations.of(context).combo,
        _NavItem.menu => AppLocalizations.of(context).settings,
      };
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  _NavItem _curNavItem = _NavItem.all;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const bottomBarHeight = kBottomNavigationBarHeight;
    const subscreenBottomMargin = bottomBarHeight + 16.0;

    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: ref
                .read(deckListProvider.notifier)
                // ignore: discarded_futures
                .setLocale(Localizations.localeOf(context)),
            builder: (context, _) {
              return PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: _NavItem.values
                    .map((navItem) => switch (navItem) {
                          _NavItem.all => const DeckListSubscreen(
                              type: DeckFilter.all,
                              bottomMargin: subscreenBottomMargin),
                          _NavItem.favorites => const DeckListSubscreen(
                              type: DeckFilter.favorites,
                              bottomMargin: subscreenBottomMargin),
                          _NavItem.combo =>
                            const ComboSubscreen(bottomMargin: subscreenBottomMargin),
                          _ => const SizedBox.shrink()
                        })
                    .toList(growable: false),
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MoltenBottomNavigationBar(
              barHeight: bottomBarHeight,
              domeWidth: 80,
              domeHeight: 12,
              borderRaduis: BorderRadius.zero,
              curve: Curves.easeOutExpo,
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
                  .toList(growable: false),
              selectedIndex: _curNavItem.index,
              onTabChange: (i) async {
                final navItem = _NavItem.values[i];
                switch (navItem) {
                  case _NavItem.menu:
                    await SettingsScreen.showBottomSheet(context);
                  case _NavItem.all:
                  case _NavItem.favorites:
                  case _NavItem.combo:
                    setState(() {
                      _curNavItem = _NavItem.values[i];
                      _pageController.animateToPage(_curNavItem.index,
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutExpo);
                    });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
