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
import 'package:parlera/clippers/bottom_wave_clipper.dart';
import 'package:parlera/store/category.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parlera/store/question.dart';

import '../../helpers/emoji.dart';
import '../../helpers/hero.dart';
import 'widgets/answer_grid.dart';

class GameResultsScreen extends StatelessWidget {
  static const _maxAnswerWidth = 400;
  static const _standardTopAreaHeight = 60;

  const GameResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final topAreaHeight =
        MediaQuery.of(context).size.height < 400 ? 8 : _standardTopAreaHeight;

    return ScopedModelDescendant<CategoryModel>(
        builder: (context, _, categoryModel) {
      return ScopedModelDescendant<QuestionModel>(
        builder: (context, _, model) {
          final category = categoryModel.currentCategory!;
          final scheme = category.getDarkColorScheme();
          return Scaffold(
              backgroundColor: scheme.surface,
              body: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(children: [
                    ClipPath(
                        clipper: BottomWaveClipper(),
                        child: Container(
                          height: topAreaHeight + 90 + safeAreaTop,
                          color: category.bgColor,
                        )),
                    Positioned.directional(
                      start: 8,
                      top: 8 + safeAreaTop,
                      textDirection: Directionality.of(context),
                      child: (const BackButton(
                        color: Colors.white,
                      )),
                    ),
                    Container(
                        margin:
                            EdgeInsets.only(top: topAreaHeight + safeAreaTop),
                        alignment: Alignment.center,
                        child: Hero(
                            tag: HeroHelper.categoryImage(category),
                            child: Image(
                              image:
                                  Svg(EmojiHelper.getImagePath(category.emoji)),
                              width: 120,
                              height: 120,
                            )))
                  ]),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                      child: Text(
                        AppLocalizations.of(context).txtYourScore(
                            model.questionsPassed.length,
                            model.currentQuestions.length),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      )),
                  AnswerGrid(
                    questionsAnswered: model.questionsAnswered,
                    answersPerRow: MediaQuery.of(context).size.width.toInt() ~/
                            _maxAnswerWidth +
                        1,
                  ),
                ],
              )));
        },
      );
    });
  }
}
