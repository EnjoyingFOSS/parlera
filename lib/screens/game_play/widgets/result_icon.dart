import 'package:flutter/material.dart';

class ResultIcon extends StatelessWidget {
  final bool success;

  const ResultIcon({Key? key, required this.success}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Icon(
        success
            ? Icons.sentiment_satisfied_alt
            : Icons.sentiment_very_dissatisfied,
        size: 96,
        color: Theme.of(context).textTheme.bodyText1!.color,
      ),
    );
    ;
  }
}
