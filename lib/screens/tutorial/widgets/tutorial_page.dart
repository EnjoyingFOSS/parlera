import 'dart:math';

import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {
  static const _minImageHeight = 320.0;
  final Color bgColor; //todo remove bgColor?
  final String title;
  final String description;
  final String imagePath;

  const TutorialPage(
      {Key? key,
      required this.bgColor,
      required this.title,
      required this.description,
      required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: min(
                      MediaQuery.of(context).size.height / 2, _minImageHeight)),
              child: Image.asset(imagePath)),
          Container(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,
          ),
          Container(height: 16),
          Text(description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1)
        ],
      ),
      color: bgColor,
    );
  }
}
