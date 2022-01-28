import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {
  final Color bgColor;
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
      child: Column(
        children: [Image.asset(imagePath), Text(title), Text(description)],
      ),
      color: bgColor,
    );
  }
}
