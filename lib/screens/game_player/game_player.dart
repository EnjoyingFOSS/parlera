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

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' as flutter_foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parlera/helpers/audio.dart';
import 'package:parlera/helpers/theme.dart';
import 'package:parlera/helpers/vibration.dart';
import 'package:parlera/screens/game_player/widgets/game_content.dart';
import 'package:parlera/screens/game_player/widgets/prep_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:parlera/store/category.dart';
import 'package:parlera/models/category.dart';
import 'package:parlera/store/question.dart';
import 'package:parlera/store/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/category_type.dart';
import 'tilt_service.dart';
import 'widgets/splash_content.dart';

class GamePlayerScreen extends StatefulWidget {
  const GamePlayerScreen({Key? key}) : super(key: key);

  @override
  GamePlayerScreenState createState() => GamePlayerScreenState();
}

class GamePlayerScreenState extends State<GamePlayerScreen>
    with TickerProviderStateMixin {
  static const _secondsPrep = 5;

  late final Category _category;
  late final TiltService? _tiltService;
  Timer? _gameTimer;
  late final int _gameTime;
  late int _secondsLeft;
  bool _isStarted = false;
  bool _isPausedForShowingResult = false;
  StreamSubscription<dynamic>? _rotateSubscription;

  AnimationController? _incorrectAC;
  late Animation<double> _incorrectAnimation;
  AnimationController? _correctAC;
  late Animation<double> _correctAnimation;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _category = CategoryModel.of(context)
        .currentCategory!; //TODO can I assume non-nullability?

    SettingsModel settings = SettingsModel.of(context);

    if (_category.type == CategoryType.random) {
      QuestionModel.of(context).pickRandomCards(_category,
          CategoryModel.of(context).categories, settings.cardsPerGame);
    } else {
      QuestionModel.of(context)
          .pickCardsFromCategory(_category, settings.cardsPerGame);
    }

    _gameTime = _category.getGameTime(settings.gameTimeType,
        settings.gameTimeMultiplier, settings.customGameTime);

    if (settings.isRotationControlEnabled) {
      _tiltService = TiltService(
          handleIncorrect: _handleIncorrect,
          handleCorrect: _handleCorrect,
          isPlaying: () => !_isStarted || _isPausedForShowingResult);
      _secondsLeft = _secondsPrep;
    } else {
      _tiltService = null;
      _secondsLeft = 0;
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    _initAnimations();
  }

  AnimationController _createAnswerAnimationController() {
    const duration = Duration(milliseconds: 1500);
    final controller = AnimationController(vsync: this, duration: duration);
    controller.addStatusListener((listener) {
      if (listener == AnimationStatus.completed) {
        controller.reset();
        _nextQuestion();
      }
    });

    return controller;
  }

  void _initAnimations() {
    _incorrectAC = _createAnswerAnimationController();
    _incorrectAnimation =
        CurvedAnimation(parent: _incorrectAC!, curve: Curves.elasticOut);

    _correctAC = _createAnswerAnimationController();
    _correctAnimation =
        CurvedAnimation(parent: _correctAC!, curve: Curves.elasticOut);
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    if (_rotateSubscription != null) {
      _rotateSubscription!.cancel();
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);

    _correctAC?.dispose();
    _incorrectAC?.dispose();
    _tiltService?.dispose();

    super.dispose();
    _stopTimer();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), _gameLoop);
  }

  void _stopTimer() {
    _gameTimer?.cancel();
  }

  void _gameLoop(Timer timer) {
    if (_isPausedForShowingResult) {
      return;
    }

    if (_secondsLeft <= 0) {
      _handleTimerZero();
      return;
    }

    setState(() {
      _secondsLeft--;
    });
  }

  void _showScore() {
    Navigator.pushReplacementNamed(context, '/game-summary');
  }

  void _onClose() {
    showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(AppLocalizations.of(context).gameCancelConfirmation),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context).gameCancelDeny)),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context).gameCancelApprove))
              ],
            ));
  }

  void _gameOver() {
    _showScore();
  }

  void _nextQuestion() {
    _stopTimer();
    if (_secondsLeft == 0) {
      return _gameOver();
    }

    QuestionModel.of(context).setNextCard();
    if (QuestionModel.of(context).currentCard == null) {
      return _gameOver();
    }

    setState(() {
      _isPausedForShowingResult = false;
    });

    _startTimer();
  }

  void _postAnswer({required bool isCorrect, bool outOfTime = false}) {
    if (!flutter_foundation.kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      VibrationHelper.vibrate();
    }
    QuestionModel.of(context).answerCard(isCorrect);

    setState(() {
      _isPausedForShowingResult = true;
    });
  }

  void _handleTimerZero() {
    if (_isStarted) {
      _handleOutOfTimeIncorrect();
    } else {
      setState(() {
        _isStarted = true;
        _secondsLeft = _gameTime;
      });
    }
  }

  void _handleCorrect() {
    if (_isPausedForShowingResult) {
      return;
    }

    AudioHelper.playCorrect(context);
    _correctAC!.forward();
    _postAnswer(isCorrect: true);
  }

  void _handleIncorrect() {
    if (_isPausedForShowingResult) {
      return;
    }

    AudioHelper.playIncorrect(context);
    _incorrectAC!.forward();
    _postAnswer(isCorrect: false);
  }

  void _handleOutOfTimeIncorrect() {
    if (_isPausedForShowingResult) {
      return;
    }

    AudioHelper.playIncorrect(context);
    _incorrectAC!.forward();
    _postAnswer(isCorrect: false, outOfTime: true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isStarted) {
      if (_secondsLeft == 0) {
        if (_tiltService == null) {
          AudioHelper.playCountdownStart(context);
        } else {
          AudioHelper.playStart(context);
        }
      } else {
        AudioHelper.playCountdown(context);
      }
    }
    return Scaffold(
      backgroundColor: _category.getDarkColorScheme().surface,
      body: WillPopScope(
        onWillPop: () async {
          _onClose();
          return false;
        },
        child: Stack(children: [
          if (_isPausedForShowingResult || _isStarted)
            Stack(
              children: [
                ScopedModelDescendant<QuestionModel>(
                  builder: (context, child, model) {
                    final currentQuestion = model.currentCard;
                    if (currentQuestion != null) {
                      return GameContent(
                          handleCorrect: _handleCorrect,
                          handleIncorrect: _handleIncorrect,
                          currentQuestion: currentQuestion,
                          category: model.currentCategory!,
                          secondsLeft: _secondsLeft.toString());
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                ScaleTransition(
                  scale: _incorrectAnimation,
                  child: SplashContent(
                    isOutOfTime: _secondsLeft <= 0,
                    isNextToLast: QuestionModel.of(context).isPreLastCard(),
                    background: ThemeHelper.failColorLighter,
                    iconData: _secondsLeft <= 0
                        ? Icons.timer_rounded
                        : Icons.sentiment_dissatisfied_rounded,
                  ),
                ),
                ScaleTransition(
                  scale: _correctAnimation,
                  child: SplashContent(
                    isOutOfTime: false,
                    isNextToLast: QuestionModel.of(context).isPreLastCard(),
                    background: ThemeHelper.successColorLighter,
                    iconData: Icons.sentiment_satisfied_alt_rounded,
                  ),
                ),
              ],
            )
          else if (_secondsLeft == 0)
            PrepScreen(countdownText: AppLocalizations.of(context).labelGo)
          else
            PrepScreen(
                countdownText: _secondsLeft.toString(),
                descriptionText: AppLocalizations.of(context)
                    .preparationOrientationDescription), //TODO remind users of directions each time
        ]),
      ),
    );
  }
}
