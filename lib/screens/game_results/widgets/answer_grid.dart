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
import 'package:parlera/models/question.dart';

import 'answer_item.dart';

class AnswerGrid extends StatelessWidget {
  final int answersPerRow;
  final List<Question> questionsAnswered;

  const AnswerGrid(
      {Key? key, required this.questionsAnswered, required this.answersPerRow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (answersPerRow < 1) return const SizedBox();

    final rowCount = (questionsAnswered.length / answersPerRow).ceil();
    var lastCellCount = questionsAnswered.length % answersPerRow;
    if (lastCellCount == 0) lastCellCount = answersPerRow;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Table(
            defaultColumnWidth: const FlexColumnWidth(1.0),
            children: List.generate(
              rowCount,
              (rowI) {
                if (rowI < rowCount - 1) {
                  return TableRow(
                    children: List.generate(
                        answersPerRow,
                        (columnI) => AnswerItem(
                            question: questionsAnswered[
                                rowI * answersPerRow + columnI])),
                  );
                } else {
                  return TableRow(
                      children: List.generate(
                          answersPerRow,
                          (columnI) => (columnI < lastCellCount)
                              ? AnswerItem(
                                  question: questionsAnswered[
                                      rowI * answersPerRow + columnI])
                              : const SizedBox()));
                }
              },
            )));
  }
}
