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
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:parlera/helpers/layout.dart';
import 'package:parlera/screens/game_results/widgets/answer_grid.dart';
import 'package:parlera/screens/game_results/widgets/results_header.dart';
import 'package:parlera/store/card.dart';
import 'package:parlera/store/category.dart';
import 'package:parlera/store/settings.dart';
import 'package:parlera/widgets/max_width_container.dart';
import 'package:scoped_model/scoped_model.dart';

class GameResultsScreen extends StatelessWidget {
  static const _maxAnswerWidth = 400;

  const GameResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SettingsModel>(
        builder: (context, _, settingsModel) {
      return ScopedModelDescendant<CategoryModel>(
          builder: (context, _, categoryModel) {
        return ScopedModelDescendant<CardModel>(
          builder: (context, _, cardModel) {
            final isUnlimitedCardMode = settingsModel.cardsPerGame == null;
            final cardTotal = isUnlimitedCardMode
                ? cardModel.cardsAnswered.length
                : cardModel.currentCards.length;

            final category = categoryModel.currentCategory!;
            final scheme = category.getDarkColorScheme();

            return Scaffold(
                backgroundColor: scheme.surface,
                body: AnimationLimiter(
                    child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                        child: ResultsHeader(
                      category: category,
                      scoreRatio:
                          cardModel.correctCards.length.toDouble() / cardTotal,
                    )),
                    SliverPadding(
                        padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                        sliver: SliverToBoxAdapter(
                            child: Text(
                          isUnlimitedCardMode
                              ? AppLocalizations.of(context).txtYourScoreSimple(
                                  cardModel.correctCards.length)
                              : AppLocalizations.of(context).txtYourScore(
                                  cardModel.correctCards.length, cardTotal),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ))),
                    SliverPadding(
                        padding: const EdgeInsets.fromLTRB(8, 16, 8, 32),
                        sliver: AnswerGrid(
                          cardsAnswered: cardModel.cardsAnswered,
                          answersPerRow:
                              MediaQuery.of(context).size.width.toInt() ~/
                                      _maxAnswerWidth +
                                  1,
                        )),
                    SliverPadding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 8),
                        sliver: SliverToBoxAdapter(
                            child: Container(
                          color: scheme.onSurface.withAlpha(47),
                          height: 1,
                          width: double.infinity,
                        ))),
                    SliverPadding(
                        padding: const EdgeInsets.fromLTRB(8, 32, 8, 16),
                        sliver: SliverToBoxAdapter(
                          child: (MediaQuery.of(context).size.width >
                                  LayoutHelper.breakpointXL)
                              ? MaxWidthContainer(
                                  child: Row(children: [
                                  Expanded(
                                      child: _ResultsButton(
                                          scheme: scheme,
                                          iconData: Icons.refresh,
                                          onTap: () async =>
                                              await _playAgain(context),
                                          labelText:
                                              AppLocalizations.of(context)
                                                  .btnPlayAgain)),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                      child: _ResultsButton(
                                          scheme: scheme,
                                          iconData: Icons.arrow_back,
                                          onTap: () =>
                                              _backToAllCategories(context),
                                          labelText:
                                              AppLocalizations.of(context)
                                                  .btnBackToAllCategories))
                                ]))
                              : Column(children: [
                                  SizedBox(
                                      width: double.infinity,
                                      child: _ResultsButton(
                                          scheme: scheme,
                                          iconData: Icons.refresh,
                                          onTap: () async =>
                                              await _playAgain(context),
                                          labelText:
                                              AppLocalizations.of(context)
                                                  .btnPlayAgain)),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                      width: double.infinity,
                                      child: _ResultsButton(
                                          scheme: scheme,
                                          iconData: Icons.arrow_back,
                                          onTap: () =>
                                              _backToAllCategories(context),
                                          labelText:
                                              AppLocalizations.of(context)
                                                  .btnBackToAllCategories))
                                ]),
                        )),
                  ],
                )));
          },
        );
      });
    });
  }

  void _backToAllCategories(BuildContext context) =>
      Navigator.of(context).popUntil(ModalRoute.withName('/'));

  Future<void> _playAgain(BuildContext context) async =>
      await Navigator.pushReplacementNamed(
        context,
        '/category',
      );
}

class _ResultsButton extends StatelessWidget {
  final ColorScheme scheme;
  final String labelText;
  final IconData iconData;
  final Function() onTap;

  const _ResultsButton(
      {required this.scheme,
      required this.labelText,
      required this.iconData,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        icon: Icon(iconData, color: scheme.onSurface),
        onPressed: onTap,
        style: TextButton.styleFrom(foregroundColor: scheme.primary),
        label: Text(
          labelText,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: scheme.onSurface),
        ));
  }
}
