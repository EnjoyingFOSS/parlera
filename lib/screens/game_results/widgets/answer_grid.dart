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
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:parlera/screens/game_results/widgets/answer_item.dart';
import 'package:parlera/widgets/max_width_container.dart';

class AnswerGrid extends StatelessWidget {
  final int cardsAnsweredTotal;
  final List<String> cards;
  final List<bool?> answers;
  final int answersPerRow;

  const AnswerGrid(
      {required this.cardsAnsweredTotal,
      required this.cards,
      required this.answers,
      required this.answersPerRow,
      super.key});

  @override
  Widget build(BuildContext context) {
    if (answersPerRow < 1) return const SizedBox();

    final rowCount = (cardsAnsweredTotal / answersPerRow).ceil();
    var lastCellCount = cardsAnsweredTotal % answersPerRow;
    if (lastCellCount == 0) lastCellCount = answersPerRow;

    return SliverList.list(
        children: List.generate(
      rowCount,
      (rowI) {
        return MaxWidthContainer(
            child: Row(
                children: List.generate(answersPerRow, (columnI) {
          final index = rowI * answersPerRow + columnI;

          return Flexible(
              child: AnimationConfiguration.staggeredList(
                  position: index,
                  delay: const Duration(milliseconds: 400),
                  duration: const Duration(seconds: 2),
                  child: FadeInAnimation(
                      child: (rowI < rowCount - 1 || columnI < lastCellCount)
                          ? AnswerItem(
                              card: cards[index],
                              answeredCorrectly: answers[index]!,
                            )
                          : const SizedBox())));
        })));
      },
    ));
  }
}
