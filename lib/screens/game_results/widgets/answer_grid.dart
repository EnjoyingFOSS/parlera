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

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:parlera/models/phrase_card.dart';
import 'package:parlera/screens/game_results/widgets/answer_item.dart';
import 'package:parlera/widgets/max_width_container.dart';

class AnswerGrid extends StatelessWidget {
  final List<PhraseCard> cardsAnswered;
  final int answersPerRow;

  const AnswerGrid(
      {required this.cardsAnswered, required this.answersPerRow, super.key});

  @override
  Widget build(BuildContext context) {
    if (answersPerRow < 1) return const SizedBox();

    final rowCount = (cardsAnswered.length / answersPerRow).ceil();
    var lastCellCount = cardsAnswered.length % answersPerRow;
    if (lastCellCount == 0) lastCellCount = answersPerRow;

    return SliverList.list(
        children: List.generate(
      rowCount,
      (rowI) {
        return MaxWidthContainer(
            child: Row(
                children: List.generate(answersPerRow, (columnI) {
          final pos = rowI * answersPerRow + columnI;

          return Flexible(
              child: AnimationConfiguration.staggeredList(
                  position: pos,
                  delay: const Duration(milliseconds: 400),
                  duration: const Duration(seconds: 2),
                  child: FadeInAnimation(
                      child: (rowI < rowCount - 1 || columnI < lastCellCount)
                          ? AnswerItem(
                              card: cardsAnswered[pos],
                            )
                          : const SizedBox())));
        })));
      },
    ));
  }
}
