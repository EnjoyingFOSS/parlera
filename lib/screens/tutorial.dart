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
import 'package:flutter_overboard/flutter_overboard.dart';
import 'package:parlera/store/tutorial.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: OverBoard(
      pages: [
        PageModel(
            imageAssetPath: 'assets/images/tutorial/1.png',
            title: AppLocalizations.of(context).tutorialFirstSectionHeader,
            body: AppLocalizations.of(context).tutorialFirstSectionDescription,
            color: Theme.of(context).colorScheme.primary),
        PageModel(
            imageAssetPath: 'assets/images/tutorial/2.png',
            title: AppLocalizations.of(context).tutorialSecondSectionHeader,
            body: AppLocalizations.of(context).tutorialSecondSectionDescription,
            color: Theme.of(context).colorScheme.surface),
        PageModel(
            imageAssetPath: 'assets/images/tutorial/3.png',
            title: AppLocalizations.of(context).tutorialThirdSectionHeader,
            body: AppLocalizations.of(context).tutorialThirdSectionDescription,
            color: Theme.of(context).colorScheme.primary),
        PageModel(
            imageAssetPath: 'assets/images/tutorial/4.png',
            title: AppLocalizations.of(context).tutorialFourthSectionHeader,
            body: AppLocalizations.of(context).tutorialFourthSectionDescription,
            color: Theme.of(context).colorScheme.surface),
      ],
      finishCallback: () {
        Navigator.popUntil(context, ModalRoute.withName('/'));
        TutorialModel.of(context).watch();
      },
    ));
  }
}
