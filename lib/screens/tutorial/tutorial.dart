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

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parlera/store/tutorial.dart';

import 'widgets/tutorial_page.dart';
import 'widgets/pagination_bar.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _KeyboardPreviousIntent extends Intent {
  const _KeyboardPreviousIntent();
}

class _KeyboardNextIntent extends Intent {
  const _KeyboardNextIntent();
}

class _TutorialScreenState extends State<TutorialScreen> {
  static const _switchAnimationDuration = Duration(milliseconds: 500);
  static const _switchAnimationCurve = Curves.ease;

  final _controller = PageController();
  int _currentPage = 0;

  bool _isMobile() => (!kIsWeb && (Platform.isAndroid || Platform.isIOS));

  @override
  Widget build(BuildContext context) {
    final pages = [
      TutorialPage(
          imagePath: 'assets/images/tutorial/1.webp',
          title: AppLocalizations.of(context).tutorialFirstSectionHeader,
          description: _isMobile()
              ? AppLocalizations.of(context)
                  .tutorialFirstSectionDescriptionPhone
              : AppLocalizations.of(context)
                  .tutorialFirstSectionDescriptionDesktop,
          bgColor: Theme.of(context).colorScheme.surface),
      _isMobile()
          ? TutorialPage(
              imagePath: 'assets/images/tutorial/2-phone.webp',
              title:
                  AppLocalizations.of(context).tutorialSecondSectionHeaderPhone,
              description: AppLocalizations.of(context)
                  .tutorialSecondSectionDescriptionPhone,
              bgColor: Theme.of(context).colorScheme.surface)
          : TutorialPage(
              imagePath: 'assets/images/tutorial/2.webp',
              title: AppLocalizations.of(context)
                  .tutorialSecondSectionHeaderDesktop,
              description: AppLocalizations.of(context)
                  .tutorialSecondSectionDescriptionDesktop,
              bgColor: Theme.of(context).colorScheme.surface),
      _isMobile()
          ? TutorialPage(
              imagePath: 'assets/images/tutorial/3-phone.webp',
              title:
                  AppLocalizations.of(context).tutorialThirdSectionHeaderPhone,
              description: AppLocalizations.of(context)
                  .tutorialThirdSectionDescriptionPhone,
              bgColor: Theme.of(context).colorScheme.surface)
          : TutorialPage(
              imagePath: 'assets/images/tutorial/3.webp',
              title: AppLocalizations.of(context)
                  .tutorialThirdSectionHeaderDesktop,
              description: AppLocalizations.of(context)
                  .tutorialThirdSectionDescriptionDesktop,
              bgColor: Theme.of(context).colorScheme.surface),
      TutorialPage(
          imagePath: 'assets/images/tutorial/4.webp',
          title: AppLocalizations.of(context).tutorialFourthSectionHeader,
          description: _isMobile()
              ? AppLocalizations.of(context)
                  .tutorialFourthSectionDescriptionPhone
              : AppLocalizations.of(context)
                  .tutorialFourthSectionDescriptionDesktop,
          bgColor: Theme.of(context).colorScheme.surface),
    ];
    return Scaffold(
        //TODO use CallbackShortcuts instead
        body: Shortcuts(
            shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.arrowLeft):
              const _KeyboardPreviousIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowRight):
              const _KeyboardNextIntent(),
        },
            child: Actions(
                actions: {
                  _KeyboardPreviousIntent:
                      CallbackAction(onInvoke: (_) => _navigatePrevious()),
                  _KeyboardNextIntent:
                      CallbackAction(onInvoke: (_) => _navigateNext()),
                },
                child: SafeArea(
                    child: Stack(children: [
                  PageView(
                    // physics: const PageScrollPhysics(),
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    controller: _controller,
                    children: pages,
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: PaginationBar(
                        controller: _controller,
                        onFinish: () {
                          TutorialModel.of(context).watch();
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        },
                        pageCount: pages.length,
                        currentPage: _currentPage,
                        onNavigateNext: _navigateNext,
                        onNavigatePrevious: _navigatePrevious,
                      ))
                ])))));
  }

  void _navigatePrevious() => _controller.previousPage(
      duration: _switchAnimationDuration, curve: _switchAnimationCurve);

  void _navigateNext() => _controller.nextPage(
      duration: _switchAnimationDuration, curve: _switchAnimationCurve);
}
