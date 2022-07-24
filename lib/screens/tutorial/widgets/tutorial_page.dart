import 'dart:math';

import 'package:flutter/material.dart';
import 'package:parlera/helpers/orientation.dart';

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
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, Theme.of(context).appBarTheme.toolbarHeight ?? 48 + 16),
      child: OrientationHelper.isStronglyLandscape(context)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: min(
                                MediaQuery.of(context).size.height / 2,
                                _minImageHeight)),
                        child: Image.asset(imagePath))),
                const SizedBox(width: 16),
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      const SizedBox(height: 16),
                      Text(description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1)
                    ]))
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: min(MediaQuery.of(context).size.height / 2,
                            _minImageHeight)),
                    child: Image.asset(imagePath)),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 16),
                Text(description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1)
              ],
            ),
      color: bgColor,
    );
  }
}
