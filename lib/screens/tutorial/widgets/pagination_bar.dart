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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaginationBar extends StatelessWidget {
  final Widget pageIndicator;
  final Function() onNavigatePrevious;
  final Function() onNavigateNext;
  final Function() onFinish;
  final int pageCount;
  final int currentPage;

  const PaginationBar(
      {required this.pageIndicator,
      required this.onFinish,
      required this.pageCount,
      required this.currentPage,
      required this.onNavigatePrevious,
      required this.onNavigateNext,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle =
        TextStyle(color: Theme.of(context).colorScheme.onBackground);
    return SizedBox(
        height: Theme.of(context).appBarTheme.toolbarHeight,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: (currentPage == 0)
                        ? TextButton(
                            onPressed: onFinish,
                            child: Text(
                              AppLocalizations.of(context).btnSkip,
                              style: buttonTextStyle,
                            ))
                        : TextButton(
                            onPressed: onNavigatePrevious,
                            child: Text(
                              AppLocalizations.of(context).btnBack,
                              style: buttonTextStyle,
                            ))),
                Positioned.fill(child: Center(child: pageIndicator)),
                Align(
                    alignment: Alignment.centerRight,
                    child: (currentPage == pageCount - 1)
                        ? TextButton(
                            onPressed: onFinish,
                            child: Text(
                                AppLocalizations.of(context).btnFinishTutorial,
                                style: buttonTextStyle))
                        : TextButton(
                            onPressed: onNavigateNext,
                            child: Text(AppLocalizations.of(context).btnNext,
                                style: buttonTextStyle)))
              ],
            )));
  }
}
