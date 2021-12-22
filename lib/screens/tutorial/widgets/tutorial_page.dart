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

class TutorialPageContent {
  final String title;
  final String body;
  final String asset;

  const TutorialPageContent(
      {required this.asset, required this.title, required this.body});
}

class TutorialPage extends StatelessWidget {
  final TutorialPageContent content;
  final Function() onFinish;

  const TutorialPage({Key? key, required this.content, required this.onFinish})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Align(
            alignment: AlignmentDirectional.topEnd,
            child: TextButton(
                child: Text(
                  "Skip",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
                onPressed: onFinish)),
        const Spacer(
          flex: 1,
        ),
        Image.asset(
          content.asset,
          width: 192,
        ),
        Text(
          content.title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline3
              ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
        ),
        Text(
          content.body,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        const Spacer(
          flex: 1,
        ),
      ]),
    );
  }
}
