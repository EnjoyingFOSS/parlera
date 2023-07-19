import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashContent extends StatelessWidget {
  final bool isNextToLast;
  final bool isOutOfTime;
  final Color background;
  final IconData iconData;

  const SplashContent(
      {required this.background,
      required this.isNextToLast,
      required this.isOutOfTime,
      required this.iconData,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: background),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          child: Center(
            child: Icon(
              iconData,
              size: 256,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        if (isOutOfTime || isNextToLast)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              isOutOfTime
                  ? AppLocalizations.of(context).txtTimesUp
                  : AppLocalizations.of(context).lastQuestion,
              style: const TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
      ]),
    );
  }
}
