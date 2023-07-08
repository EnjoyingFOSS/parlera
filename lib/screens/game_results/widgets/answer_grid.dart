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
                //TODO turn into gridview, make whole page scrollable
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
