import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashContent extends StatelessWidget {
  final bool isNextToLast;
  final Color background;
  final Widget child;

  const SplashContent(
      {Key? key,
      required this.background,
      required this.child,
      required this.isNextToLast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: background),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          child: Center(
            child: child,
          ),
        ),
        if (isNextToLast)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              AppLocalizations.of(context).lastQuestion,
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
