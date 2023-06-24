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
// TODO CAMERA: Make it work and work well
// import 'package:parlera/helpers/pictures.dart';
// import 'package:parlera/store/gallery.dart';
// import 'widgets/camera_preview.dart';
import 'package:parlera/helpers/theme.dart';
import 'package:parlera/helpers/vibration.dart';
import 'package:parlera/screens/game_play/widgets/game_content.dart';
import 'package:parlera/screens/game_play/widgets/prep_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:parlera/store/category.dart';
import 'package:parlera/models/category.dart';
import 'package:parlera/store/question.dart';
import 'package:parlera/store/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/category_type.dart';
import 'tilt_service.dart';
import 'widgets/splash_content.dart';

class GamePlayScreen extends StatefulWidget {
  const GamePlayScreen({Key? key}) : super(key: key);

  @override
  GamePlayScreenState createState() => GamePlayScreenState();
}

class GamePlayScreenState extends State<GamePlayScreen>
    with TickerProviderStateMixin {
  static const _secondsPrep = 5;

  late final Category _category;
  late final TiltService? _tiltService;
  Timer? _gameTimer;
  int _secondsMax = -1;
  late int _secondsLeft;
  bool _isStarted = false;
  bool _isPausedForShowingResult = false;
  // bool _isCameraEnabled = false; // TODO CAMERA: Make it work and work well
  StreamSubscription<dynamic>? _rotateSubscription;

  AnimationController? _invalidAC;
  late Animation<double> _invalidAnimation;
  AnimationController? _validAC;
  late Animation<double> _validAnimation;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _category = CategoryModel.of(context)
        .currentCategory!; //TODO can I assume non-nullability?

    if (_category.type == CategoryType.random) {
      QuestionModel.of(context)
          .pickRandomQuestions(_category, CategoryModel.of(context).categories);
    } else {
      QuestionModel.of(context).pickQuestionsFromCategory(_category);
    }

    SettingsModel settings = SettingsModel.of(context);
    _secondsMax = settings.roundTime;
    // _isCameraEnabled = settings.isCameraEnabled; // TODO CAMERA: Make it work and work well
    if (settings.isRotationControlEnabled) {
      _tiltService = TiltService(
          handleInvalid: _handleInvalid,
          handleValid: _handleValid,
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
    _invalidAC = _createAnswerAnimationController();
    _invalidAnimation =
        CurvedAnimation(parent: _invalidAC!, curve: Curves.elasticOut);

    _validAC = _createAnswerAnimationController();
    _validAnimation =
        CurvedAnimation(parent: _validAC!, curve: Curves.elasticOut);
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

    _validAC?.dispose();
    _invalidAC?.dispose();
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
      _handleTimeout();
      return;
    }

    setState(() {
      _secondsLeft--;
    });
  }

  // TODO CAMERA: Make it work and work well
  // Future<void> savePictures() async {
  //   GalleryModel.of(context).update(await PicturesHelper.getFiles(context));
  // }

  void _showScore() {
    SettingsModel.of(context).increaseGamesFinished();
    CategoryModel.of(context).increasePlayedCount(_category);
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
    //   if (_isCameraEnabled) { // TODO CAMERA: Make it work and work well
    //     savePictures();
    //   }
    _showScore();
  }

  void _nextQuestion() {
    _stopTimer();
    if (_secondsLeft == 0) {
      return _gameOver();
    }

    QuestionModel.of(context).setNextQuestion();
    if (QuestionModel.of(context).currentQuestion == null) {
      return _gameOver();
    }

    setState(() {
      _isPausedForShowingResult = false;
    });

    _startTimer();
  }

  void _postAnswer({required bool isValid}) {
    if (!flutter_foundation.kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      VibrationHelper.vibrate();
    }
    QuestionModel.of(context).answerQuestion(isValid);

    setState(() {
      _isPausedForShowingResult = true;
    });

    //   'valid': isValid,
    //   'question': QuestionModel.of(context).currentQuestion.name,
    //   'category': category.name,
    // });
  }

  void _handleValid() {
    if (_isPausedForShowingResult) {
      return;
    }

    AudioHelper.playCorrect(context);
    _validAC!.forward();
    _postAnswer(isValid: true);
  }

  void _handleInvalid() {
    if (_isPausedForShowingResult) {
      return;
    }

    AudioHelper.playIncorrect(context);
    _invalidAC!.forward();
    _postAnswer(isValid: false);
  }

  void _handleTimeout() {
    if (_isStarted) {
      _handleInvalid();
    } else {
      setState(() {
        _isStarted = true;
        _secondsLeft = _secondsMax;
      });
    }
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: WillPopScope(
        onWillPop: () async {
          _onClose();
          return false;
        },
        child: Stack(children: [
          // if (_isCameraEnabled && _isStarted)
          //   const CameraPreviewScreen(), //TODO CAMERA: Make it work and work well; this is now hidden behind opaque answers — fix
          if (_isPausedForShowingResult || _isStarted)
            Stack(
              children: [
                ScopedModelDescendant<QuestionModel>(
                  builder: (context, child, model) {
                    final currentQuestion = model.currentQuestion;
                    if (currentQuestion != null) {
                      return GameContent(
                          handleValid: _handleValid,
                          handleInvalid: _handleInvalid,
                          currentQuestion: currentQuestion,
                          category: model.currentCategory!,
                          secondsLeft: _secondsLeft.toString());
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                ScaleTransition(
                  scale: _invalidAnimation,
                  child: SplashContent(
                    isNextToLast: QuestionModel.of(context).isPreLastQuestion(),
                    background: ThemeHelper.failColorLighter,
                    iconData: Icons.sentiment_dissatisfied_rounded,
                  ),
                ),
                ScaleTransition(
                  scale: _validAnimation,
                  child: SplashContent(
                    isNextToLast: QuestionModel.of(context).isPreLastQuestion(),
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
