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

import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlera/helpers/import_export.dart';
import 'package:parlera/helpers/layout.dart';
import 'package:parlera/helpers/url_util.dart';
import 'package:parlera/models/parlera_locale.dart';
import 'package:parlera/models/setting_state.dart';
import 'package:parlera/providers/deck_list_provider.dart';
import 'package:parlera/providers/game_setup_provider.dart';
import 'package:parlera/providers/setting_provider.dart';
import 'package:parlera/screens/deck_creator/deck_creator.dart';
import 'package:parlera/screens/home/widgets/deck_card.dart';
import 'package:parlera/widgets/centered_scrollable_container.dart';
import 'package:parlera/widgets/empty_content.dart';
import 'package:parlera/widgets/error_content.dart';
import 'package:parlera/widgets/max_width_container.dart';

enum DeckFilter { all, favorites }

class DeckListSubscreen extends ConsumerWidget {
  static const String _menuCreate = "create";
  static const String _menuImport = "import";
  static const String _menuGetOnline = "getOnline";

  final DeckFilter type;
  final double bottomMargin;

  const DeckListSubscreen({
    required this.bottomMargin,
    required this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final curLocale = ParleraLocale.fromLocale(Localizations.localeOf(context));

    final containerWidth =
        min(MediaQuery.sizeOf(context).width, LayoutXL.cols12.width);
    final crossAxisCount = containerWidth ~/ 480 + 1;

    final appBarActions = [
      PopupMenuButton(
        icon: const Icon(Icons.add_rounded),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        tooltip: l10n.menuAddCategory,
        itemBuilder: (context) => [
          PopupMenuItem<String>(
              value: _menuCreate, child: Text(l10n.btnCreateCategory)),
          PopupMenuItem<String>(
              value: _menuImport, child: Text(l10n.btnImportCategory)),
          PopupMenuItem<String>(
              value: _menuGetOnline, child: Text(l10n.btnGetCategoriesOnline))
        ],
        onSelected: (String value) async {
          switch (value) {
            case _menuCreate:
              await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (_) => const DeckCreatorScreen()));
            case _menuGetOnline:
              await URLUtil.launchURL(context,
                  'https://gitlab.com/enjoyingfoss/parlera-categories');
            case _menuImport:
              final scaffoldMessengerState = ScaffoldMessenger.of(context);

              try {
                final fpr = await FilePicker.platform
                    .pickFiles(withData: Platform.isLinux);

                if (fpr != null) {
                  final inputFile = fpr.files.first;

                  await ImportExportHelper.importFile(
                      inputFile, ref, curLocale);

                  scaffoldMessengerState.showSnackBar(
                      SnackBar(content: Text(l10n.txtCategoryImported)));
                }
                break;
              } catch (_) {
                scaffoldMessengerState.showSnackBar(
                    SnackBar(content: Text(l10n.errorCouldNotImport)));
                return;
              }
          }
        },
      ),
    ];

    return ref.watch(deckListProvider).when(
          error: (exception, stackTrace) => CenteredScrollableContainer(
            padding: EdgeInsets.only(bottom: bottomMargin),
            child: ErrorContent(exception: exception, stackTrace: stackTrace),
          ),
          loading: () => Padding(
            padding: EdgeInsets.only(bottom: bottomMargin),
            child: const Center(child: CircularProgressIndicator.adaptive()),
          ),
          data: (categoryState) {
            if (categoryState == null) {
              return Padding(
                padding: EdgeInsets.only(bottom: bottomMargin),
                child:
                    const Center(child: CircularProgressIndicator.adaptive()),
              );
            }
            final cardDecks = (type == DeckFilter.favorites)
                ? categoryState.favorites
                : categoryState.allDecks;
            if (cardDecks.isEmpty) {
              return CenteredScrollableContainer(
                padding: EdgeInsets.only(bottom: bottomMargin),
                child: switch (type) {
                  DeckFilter.favorites => EmptyContent(
                      title: l10n.noFavoritesTitle,
                      subtitle: l10n.emptyFavorites,
                      iconData: Icons.favorite_border_rounded,
                    ),
                  DeckFilter.all => EmptyContent(
                      title: l10n.emptyCategories,
                      subtitle: l10n.noCategoriesSubtitle,
                      iconData: Icons.apps_rounded,
                    )
                },
              );
            } else {
              final title =
                  (type == DeckFilter.favorites) ? l10n.favorites : "Parlera";
              return MaxWidthContainer(
                child: SafeArea(
                  child: CustomScrollView(
                    primary: false,
                    slivers: [
                      SliverPadding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 12),
                          sliver: SliverAppBar(
                            title: Text(title,
                                style: const TextStyle(fontSize: 52)),
                            actions: appBarActions,
                          )),
                      SliverPadding(
                        padding:
                            EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomMargin),
                        sliver: SliverGrid.count(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: _getCardAspectRatio(
                              context, containerWidth, crossAxisCount),
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          children: List.generate(cardDecks.length, (index) {
                            final deck = cardDecks[index];
                            return DeckCard(
                              deck: deck,
                              onTap: () async {
                                final settingState = ref
                                        .read(settingProvider)
                                        .valueOrNull ??
                                    const SettingState(rotationEnabled: false);
                                await ref
                                    .read(gameSetupProvider.notifier)
                                    .setDeck(
                                        deck,
                                        settingState.gameDurationType
                                            .getGameDuration(
                                                deck.mediumGameDurationS,
                                                settingState.cardsPerGame,
                                                settingState
                                                    .customGameDuration),
                                        settingState.cardsPerGame);
                                if (context.mounted) {
                                  await Navigator.pushNamed(
                                    context,
                                    '/game-cover',
                                  );
                                }
                              },
                            );
                          }, growable: false),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
  }

  double _getCardAspectRatio(
      BuildContext context, double containerWidth, int crossAxisCount) {
    final itemWidth =
        (containerWidth - 32 - 8 * (crossAxisCount - 1)) / crossAxisCount;
    const itemHeight = 80.0;

    return itemWidth / itemHeight;
  }
}
