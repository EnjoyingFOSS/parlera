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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:parlera/helpers/orientation.dart';

class TutorialPage extends StatelessWidget {
  static const _minImageHeight = 320.0;
  final Color bgColor; //TODO remove bgColor?
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
      color: bgColor,
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
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium)
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
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text(description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium)
              ],
            ),
    );
  }
}
