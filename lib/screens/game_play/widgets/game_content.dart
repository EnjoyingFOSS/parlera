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
import 'package:parlera/helpers/theme.dart';
import 'package:parlera/models/question.dart';
import 'game_button.dart';

class _KeyboardHandleValidIntent extends Intent {
  const _KeyboardHandleValidIntent();
}

class _KeyboardHandleInvalidIntent extends Intent {
  const _KeyboardHandleInvalidIntent();
}

class GameContent extends StatelessWidget {
  final void Function() handleValid;
  final void Function() handleInvalid;
  final Question currentQuestion;
  final String categoryName;
  final String secondsLeft;

  const GameContent(
      {Key? key,
      required this.handleValid,
      required this.handleInvalid,
      required this.currentQuestion,
      required this.secondsLeft,
      required this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
        //todo use CallbackShortcuts instead
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.arrowUp):
              const _KeyboardHandleInvalidIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowDown):
              const _KeyboardHandleValidIntent(),
        },
        child: Actions(
            actions: {
              _KeyboardHandleValidIntent:
                  CallbackAction(onInvoke: (_) => handleValid()),
              _KeyboardHandleInvalidIntent:
                  CallbackAction(onInvoke: (_) => handleInvalid()),
            },
            child: Focus(
                autofocus: true,
                child: Stack(
                  children: [
                    Row(
                      children: [
                        GameButton(
                          color: ThemeHelper.failColorDarker,
                          onTap: handleInvalid,
                          emojiIcon: Icons.sentiment_dissatisfied_rounded,
                          arrowIcon: Icons.arrow_upward,
                        ),
                        GameButton(
                          color: ThemeHelper.successColorDarker,
                          onTap: handleValid,
                          emojiIcon: Icons.sentiment_satisfied_alt_rounded,
                          arrowIcon: Icons.arrow_downward,
                        ),
                      ],
                    ),
                    IgnorePointer(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: SafeArea(
                              child: Text(
                                categoryName,
                                style: const TextStyle(
                                  fontSize: 24.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                currentQuestion.name,
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
                        top: MediaQuery.of(context).padding.top + 8,
                        start: 8,
                        child: const BackButton()),
                  ],
                ))));
  }
}
