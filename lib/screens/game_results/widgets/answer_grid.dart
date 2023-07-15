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
import 'package:parlera/models/question.dart';
import 'package:parlera/widgets/max_width_container.dart';

import 'answer_item.dart';

class AnswerGrid extends StatelessWidget {
  final List<Question> cardsAnswered;
  final int answersPerRow;

  const AnswerGrid(
      {super.key, required this.cardsAnswered, required this.answersPerRow});

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
              child: AnimationConfiguration.staggeredGrid(
                  //TODO if I fork it, can just edit _computeStaggeredGridDuration() in animation_configurator.dart
                  columnCount: answersPerRow,
                  position: pos,
                  child: FadeInAnimation(
                      child: (rowI < rowCount - 1 || columnI < lastCellCount)
                          ? AnswerItem(
                              question: cardsAnswered[pos],
                            )
                          : const SizedBox())));
        })));
      },
    ));
  }
}
