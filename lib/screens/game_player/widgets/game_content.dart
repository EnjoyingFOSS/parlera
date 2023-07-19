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
//
// This file is derived from work covered by the following license notice:
//
//   Copyright 2021 Kamil Rykowski, Kamil Lewandowski, and Ewa Osiecka
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:parlera/clippers/bottom_wave_clipper.dart';
import 'package:parlera/helpers/emoji.dart';
import 'package:parlera/helpers/hero.dart';
import 'package:parlera/helpers/theme.dart';
import 'package:parlera/models/category.dart';
import 'package:parlera/models/phrase_card.dart';
import 'package:parlera/screens/game_player/widgets/game_button.dart';

class _KeyboardHandleCorrectIntent extends Intent {
  const _KeyboardHandleCorrectIntent();
}

class _KeyboardHandleIncorrectIntent extends Intent {
  const _KeyboardHandleIncorrectIntent();
}

class GameContent extends StatelessWidget {
  final void Function() handleCorrect;
  final void Function() handleIncorrect;
  final PhraseCard currentCard;
  final Category category;
  final String secondsLeft;

  const GameContent(
      {required this.handleCorrect,
      required this.handleIncorrect,
      required this.currentCard,
      required this.secondsLeft,
      required this.category,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final safeAreaTop = MediaQuery.of(context).padding.top;
    return Shortcuts(
        //TODO use CallbackShortcuts instead
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.arrowUp):
              const _KeyboardHandleIncorrectIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowDown):
              const _KeyboardHandleCorrectIntent(),
        },
        child: Actions(
            actions: {
              _KeyboardHandleCorrectIntent:
                  CallbackAction(onInvoke: (_) => handleCorrect()),
              _KeyboardHandleIncorrectIntent:
                  CallbackAction(onInvoke: (_) => handleIncorrect()),
            },
            child: Focus(
                autofocus: true,
                child: Stack(
                  children: [
                    Row(
                      children: [
                        GameButton(
                          color: ThemeHelper.failColorDarkest,
                          hoverColor: ThemeHelper.failColorLighter,
                          onTap: handleIncorrect,
                          emojiIcon: Icons.sentiment_dissatisfied_rounded,
                          arrowIcon: Icons.arrow_upward_rounded,
                        ),
                        GameButton(
                          color: ThemeHelper.successColorDarkest,
                          hoverColor: ThemeHelper.successColorLighter,
                          onTap: handleCorrect,
                          emojiIcon: Icons.sentiment_satisfied_alt_rounded,
                          arrowIcon: Icons.arrow_downward_rounded,
                        ),
                      ],
                    ),
                    IgnorePointer(
                        child: Padding(
                            padding: const EdgeInsets.only(bottom: 56, top: 8),
                            child: ClipPath(
                                clipper: BottomWaveClipper(),
                                child: Container(
                                    color: category
                                        .getDarkColorScheme()
                                        .surface)))),
                    IgnorePointer(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(top: safeAreaTop + 24),
                              child:
                                  Stack(fit: StackFit.passthrough, children: [
                                Positioned(
                                    top: 6,
                                    bottom: 6,
                                    left: 12,
                                    right: 0,
                                    child: Container(
                                      decoration: ShapeDecoration(
                                        shape: const StadiumBorder(),
                                        color: category.bgColor,
                                      ),
                                    )),
                                Row(mainAxisSize: MainAxisSize.min, children: [
                                  Hero(
                                      tag: HeroHelper.categoryImage(category),
                                      child: Image(
                                        image: Svg(EmojiHelper.getImagePath(
                                            category.emoji)),
                                        width: 48,
                                        height: 48,
                                      )),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    category.name,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                ])
                              ])),
                          Expanded(
                            child: Center(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                currentCard.phrase,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 64.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              secondsLeft,
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned.directional(
                        textDirection: Directionality.of(context),
                        top: safeAreaTop + 24,
                        start: 8,
                        child: const BackButton(
                          color: Colors.white,
                        )),
                  ],
                ))));
  }
}
