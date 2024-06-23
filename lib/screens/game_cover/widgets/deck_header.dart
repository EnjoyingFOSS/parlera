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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:parlera/clippers/bottom_wave_clipper.dart';
import 'package:parlera/clippers/right_wave_clipper.dart';
import 'package:parlera/helpers/import_export.dart';
import 'package:parlera/models/full_deck_companion.dart';
import 'package:parlera/models/game_setup.dart';
import 'package:parlera/providers/game_setup_provider.dart';
import 'package:parlera/screens/deck_creator/deck_creator.dart';

class DeckHeader extends ConsumerWidget {
  static const String _menuDelete = "delete";
  static const String _menuEdit = "edit";
  static const String _menuDuplicate = "duplicate";
  static const String _menuExport = "export";

  final GameSetup gameSetup;
  final bool isLandscape;

  const DeckHeader(
      {required this.gameSetup, required this.isLandscape, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    final deck = gameSetup.deck!;

    return ClipPath(
        clipper: isLandscape ? RightWaveClipper() : BottomWaveClipper(),
        child: Container(
            color: deck.color,
            padding: isLandscape
                ? const EdgeInsets.fromLTRB(8, 0, 8, 32)
                : const EdgeInsets.only(bottom: 32),
            width: double.infinity,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              AppBar(
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(
                    tooltip: l10n.btnFavorite,
                    onPressed: () async => await ref
                        .read(gameSetupProvider.notifier)
                        .toggleFavorited(),
                    icon: Icon(
                      deck.isFavorited
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return deck.isBundled
                          ? [
                              PopupMenuItem<String>(
                                  value: _menuDuplicate,
                                  child: Text(l10n.btnDuplicate)),
                              PopupMenuItem<String>(
                                  value: _menuExport,
                                  child: Text(l10n.btnExport)),
                            ]
                          : [
                              PopupMenuItem<String>(
                                  value: _menuEdit, child: Text(l10n.btnEdit)),
                              PopupMenuItem<String>(
                                  value: _menuDuplicate,
                                  child: Text(l10n.btnDuplicate)),
                              PopupMenuItem<String>(
                                  value: _menuExport,
                                  child: Text(l10n.btnExport)),
                              PopupMenuItem<String>(
                                  value: _menuDelete,
                                  child: Text(l10n.btnDelete)),
                            ];
                    },
                    onSelected: (String value) async {
                      switch (value) {
                        case _menuDelete:
                          Navigator.pop(context);
                          await ref.read(gameSetupProvider.notifier).delete();
                        case _menuEdit:
                          await Navigator.of(context)
                              .push(MaterialPageRoute<void>(
                                  builder: (context) => DeckCreatorScreen(
                                        startingFullDeckCompanion:
                                            FullDeckCompanion.fromExisting(
                                                deck, gameSetup.deckContents!),
                                      )));
                        case _menuDuplicate:
                          final ec = FullDeckCompanion.duplicateExisting(
                              deck, gameSetup.deckContents!);
                          await Navigator.of(context)
                              .push(MaterialPageRoute<void>(
                                  builder: (context) => DeckCreatorScreen(
                                        startingFullDeckCompanion: ec,
                                      )));
                        case _menuExport:
                          try {
                            await ImportExportHelper.exportAndShareJson(
                                FullDeckCompanion.fromExisting(
                                        deck, gameSetup.deckContents!)
                                    .toJson(),
                                "${deck.name}.parlera",
                                "[Parlera export] ${deck.name}");
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(l10n.errorCouldNotExport),
                              ));
                            }
                          }
                      }
                    },
                  ),
                  if (isLandscape)
                    const SizedBox(
                      width: 8,
                    )
                ],
              ),
              if (isLandscape) const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Hero(
                  tag: gameSetup.heroTag,
                  child: Image(
                    image: Svg(gameSetup.emojiPath),
                    height: 160,
                    width: 160,
                  ),
                ),
              ),
              Text(
                gameSetup.getName(context),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (isLandscape) const Spacer(),
            ])));
  }
}
