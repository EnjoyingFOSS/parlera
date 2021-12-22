import 'package:flutter/material.dart';

class PrepScreen extends StatelessWidget {
  final String countdownText;
  final String? descriptionText;

  const PrepScreen(
      {Key? key, required this.countdownText, this.descriptionText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (descriptionText != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              descriptionText!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            countdownText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 64.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    ));
  }
}
