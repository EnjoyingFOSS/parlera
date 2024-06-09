// Copyright Miroslav Mazel
//
// This file is part of Parlera.
//
// Parlera is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// As an additional permission under section 7, you are allowed to distribute
// the software through an app store, even if that store has restrictive terms
// and conditions that are incompatible with the AGPL, provided that the source
// is also available under the AGPL with or without this permission through a
// channel without those restrictive terms and conditions.
//
// As a limitation under section 7, all unofficial builds and forks of the app
// must be clearly labeled as unofficial in the app's name (e.g. "Parlera
// UNOFFICIAL", never just "Parlera") or use a different name altogether.
// If any code changes are made, the fork should use a completely different name
// and app icon. All unofficial builds and forks MUST use a different
// application ID, in order to not conflict with a potential official release.
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
import 'package:parlera/screens/tutorial/widgets/pagination_bar.dart';
import 'package:parlera/screens/tutorial/widgets/tutorial_page.dart';
import 'package:parlera/store/tutorial.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
      if (_isMobile())
        TutorialPage(
            imagePath: 'assets/images/tutorial/2-phone.webp',
            title:
                AppLocalizations.of(context).tutorialSecondSectionHeaderPhone,
            description: AppLocalizations.of(context)
                .tutorialSecondSectionDescriptionPhone,
            bgColor: Theme.of(context).colorScheme.surface)
      else
        TutorialPage(
            imagePath: 'assets/images/tutorial/2.webp',
            title:
                AppLocalizations.of(context).tutorialSecondSectionHeaderDesktop,
            description: AppLocalizations.of(context)
                .tutorialSecondSectionDescriptionDesktop,
            bgColor: Theme.of(context).colorScheme.surface),
      if (_isMobile())
        TutorialPage(
            imagePath: 'assets/images/tutorial/3-phone.webp',
            title: AppLocalizations.of(context).tutorialThirdSectionHeaderPhone,
            description: AppLocalizations.of(context)
                .tutorialThirdSectionDescriptionPhone,
            bgColor: Theme.of(context).colorScheme.surface)
      else
        TutorialPage(
            imagePath: 'assets/images/tutorial/3.webp',
            title:
                AppLocalizations.of(context).tutorialThirdSectionHeaderDesktop,
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
                  _KeyboardPreviousIntent: CallbackAction(
                      onInvoke: (_) async => await _navigatePrevious()),
                  _KeyboardNextIntent: CallbackAction(
                      onInvoke: (_) async => await _navigateNext()),
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
                          onFinish: () async {
                            await TutorialModel.of(context).setAsWatched();
                            if (context.mounted) {
                              Navigator.of(context).popUntil(
                                  ModalRoute.withName('/'));
                            }
                          },
                          pageCount: pages.length,
                          currentPage: _currentPage,
                          onNavigateNext: _navigateNext,
                          onNavigatePrevious: _navigatePrevious,
                          pageIndicator: SmoothPageIndicator(
                            controller: _controller,
                            effect: WormEffect(
                                dotWidth: 10,
                                dotHeight: 10,
                                dotColor: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withAlpha(128),
                                activeDotColor:
                                    Theme.of(context).colorScheme.primary),
                            count: pages.length,
                          )))
                ])))));
  }

  Future<void> _navigatePrevious() async => await _controller.previousPage(
      duration: _switchAnimationDuration, curve: _switchAnimationCurve);

  Future<void> _navigateNext() async => await _controller.nextPage(
      duration: _switchAnimationDuration, curve: _switchAnimationCurve);
}
