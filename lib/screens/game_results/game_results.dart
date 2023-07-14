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
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:parlera/screens/game_results/widgets/results_header.dart';
import 'package:parlera/store/category.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parlera/store/question.dart';
import 'widgets/answer_grid.dart';

class GameResultsScreen extends StatelessWidget {
  static const _maxAnswerWidth = 400;

  const GameResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CategoryModel>(
        builder: (context, _, categoryModel) {
      return ScopedModelDescendant<QuestionModel>(
        builder: (context, _, model) {
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
                    scoreRatio: model.correctCards.length.toDouble() /
                        model.currentCards.length,
                  )),
                  SliverPadding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                      sliver: SliverToBoxAdapter(
                          child: Text(
                        AppLocalizations.of(context).txtYourScore(
                            model.correctCards.length,
                            model.currentCards.length),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ))),
                  SliverPadding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 32),
                      sliver: AnswerGrid(
                        cardsAnswered: model.cardsAnswered,
                        answersPerRow:
                            MediaQuery.of(context).size.width.toInt() ~/
                                    _maxAnswerWidth +
                                1,
                      )),
                  SliverPadding(
                      padding:
                          const EdgeInsetsDirectional.symmetric(horizontal: 8),
                      sliver: SliverToBoxAdapter(
                          child: Container(
                        color: scheme.onBackground.withAlpha(47),
                        height: 1,
                        width: double.infinity,
                      ))),
                  SliverPadding(
                      padding: const EdgeInsets.fromLTRB(8, 32, 8, 16),
                      sliver: SliverToBoxAdapter(
                        child: (false) //TODO custom breakpoints!!!
                            ? Row(mainAxisSize: MainAxisSize.min, children: [
                                Expanded(
                                    child: _ResultsButton(
                                        scheme: scheme,
                                        iconData: Icons.refresh,
                                        onTap: () => _playAgain(context),
                                        labelText: AppLocalizations.of(context)
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
                                        labelText: AppLocalizations.of(context)
                                            .btnBackToAllCategories))
                              ])
                            : Column(children: [
                                SizedBox(
                                    width: double.infinity,
                                    child: _ResultsButton(
                                        scheme: scheme,
                                        iconData: Icons.refresh,
                                        onTap: () => _playAgain(context),
                                        labelText: AppLocalizations.of(context)
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
                                        labelText: AppLocalizations.of(context)
                                            .btnBackToAllCategories))
                              ]),
                      )),
                ],
              )));
        },
      );
    });
  }

  void _backToAllCategories(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _playAgain(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      '/category',
    );
  }
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
        icon: Icon(iconData, color: scheme.onBackground),
        onPressed: onTap,
        style: TextButton.styleFrom(foregroundColor: scheme.primary),
        label: Text(
          labelText,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: scheme.onBackground),
        ));
  }
}
