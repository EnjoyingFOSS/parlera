import 'package:flutter/material.dart';
import 'package:parlera/helpers/theme.dart';
import 'package:parlera/models/question.dart';

class QuestionItem extends StatelessWidget {
  final Question question;

  const QuestionItem({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final success = question.isPassed!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(80),
                color:
                    success ? ThemeHelper.successColor : ThemeHelper.failColor),
            child: Icon(
              success ? Icons.check : Icons.close,
              size: 20.0,
              color: Theme.of(context).colorScheme.onSurface,
            )),
        const SizedBox(
          width: 8,
        ),
        Text(
          question.name,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}
