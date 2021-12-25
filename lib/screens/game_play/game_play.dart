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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parlera/helpers/audio.dart';
import 'package:parlera/helpers/pictures.dart';
import 'package:parlera/helpers/theme.dart';
import 'package:parlera/helpers/vibration.dart';
import 'package:parlera/screens/game_play/widgets/prep_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:pedantic/pedantic.dart';

import 'package:parlera/store/category.dart';
import 'package:parlera/models/category.dart';
import 'package:parlera/store/question.dart';
import 'package:parlera/store/settings.dart';
import 'package:parlera/store/gallery.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'widgets/camera_preview.dart';
import 'tilt_service.dart';
import 'widgets/game_button.dart';
import 'widgets/result_icon.dart';

class GamePlayScreen extends StatefulWidget {
  const GamePlayScreen({Key? key}) : super(key: key);

  @override
  GamePlayScreenState createState() => GamePlayScreenState();
}

class GamePlayScreenState extends State<GamePlayScreen>
    with TickerProviderStateMixin {
  static const _secondsPrep = 5;

  Timer? _gameTimer;
  int _secondsMax = -1;
  late int _secondsLeft;
  bool _isStarted = false;
  bool _isPaused = false;
  bool? _isCameraEnabled = false;
  StreamSubscription<dynamic>? _rotateSubscription;
  Category? _category;
  late final TiltService? _tiltService;

  AnimationController? invalidAC;
  late Animation<double> invalidAnimation;
  AnimationController? validAC;
  late Animation<double> validAnimation;

  @override
  void initState() {
    super.initState();
    startTimer();
    _category = CategoryModel.of(context).currentCategory;
    QuestionModel.of(context).generateCurrentQuestions(_category!.id);

    SettingsModel settings = SettingsModel.of(context);
    _secondsMax = settings.roundTime ?? -1;
    _isCameraEnabled = settings.isCameraEnabled;
    if (settings.isRotationControlEnabled!) {
      _tiltService = TiltService(
          handleInvalid: handleInvalid,
          handleValid: handleValid,
          isPlaying: () => !_isStarted || _isPaused);
      _secondsLeft = _secondsPrep;
    } else {
      _tiltService = null;
      _secondsLeft = 0;
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);

    initAnimations();
  }

  AnimationController createAnswerAnimationController() {
    const duration = Duration(milliseconds: 1500);
    var controller = AnimationController(vsync: this, duration: duration);
    controller.addStatusListener((listener) {
      if (listener == AnimationStatus.completed) {
        controller.reset();
        nextQuestion();
      }
    });

    return controller;
  }

  initAnimations() {
    invalidAC = createAnswerAnimationController();
    invalidAnimation =
        CurvedAnimation(parent: invalidAC!, curve: Curves.elasticOut);

    validAC = createAnswerAnimationController();
    validAnimation =
        CurvedAnimation(parent: validAC!, curve: Curves.elasticOut);
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    if (_rotateSubscription != null) {
      _rotateSubscription!.cancel();
    }

    validAC?.dispose();
    invalidAC?.dispose();
    _tiltService?.dispose();

    super.dispose();
    stopTimer();
  }

  startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), gameLoop);
  }

  stopTimer() {
    _gameTimer?.cancel();
  }

  void gameLoop(Timer timer) {
    if (_isPaused) {
      return;
    }

    if (_secondsLeft <= 0 && !_isPaused) {
      return handleTimeout();
    }

    setState(() {
      _secondsLeft -= 1;
    });
  }

  savePictures() async {
    GalleryModel.of(context).update(await PicturesHelper.getFiles(context));
  }

  showScore() {
    SettingsModel.of(context).increaseGamesFinished();
    CategoryModel.of(context).increasePlayedCount(_category!);

    //   'valid': QuestionModel.of(context).questionsPassed.length,
    //   'invalid': QuestionModel.of(context).questionsFailed.length,
    // });
    Navigator.pushReplacementNamed(context, '/game-summary');
  }

  Future<bool> confirmBack() async {
    Completer completer = Completer<bool>();

    unawaited(
      Alert(
        context: context,
        // type: AlertType.warning,
        style: AlertStyle(
          isCloseButton: false,
          isOverlayTapDismiss: false,
          alertBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          descStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          buttonAreaPadding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
        ),
        desc: AppLocalizations.of(context).gameCancelConfirmation,
        buttons: [
          DialogButton(
            child: Text(AppLocalizations.of(context).gameCancelDeny),
            onPressed: () {
              Navigator.pop(context);
              completer.complete(false);
            },
            color: Colors.transparent,
          ),
          DialogButton(
            child: Text(AppLocalizations.of(context).gameCancelApprove,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
            onPressed: () {
              Navigator.pop(context);
              completer.complete(true);
            },
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ).show(),
    );

    return completer.future as FutureOr<bool>;
  }

  void gameOver() {
    savePictures();
    showScore();
  }

  nextQuestion() {
    stopTimer();
    if (_secondsLeft == 0) {
      return gameOver();
    }

    QuestionModel.of(context).setNextQuestion();
    if (QuestionModel.of(context).currentQuestion == null) {
      return gameOver();
    }

    setState(() {
      _isPaused = false;
    });

    startTimer();
  }

  postAnswer({required bool isValid}) {
    if (Platform.isAndroid || Platform.isIOS) {
      VibrationHelper.vibrate();
    }
    QuestionModel.of(context).answerQuestion(isValid);

    setState(() {
      _isPaused = true;
    });

    //   'valid': isValid,
    //   'question': QuestionModel.of(context).currentQuestion.name,
    //   'category': category.name,
    // });
  }

  handleValid() {
    if (_isPaused) {
      return;
    }

    AudioHelper.playValid(context);
    validAC!.forward();
    postAnswer(isValid: true);
  }

  handleInvalid() {
    if (_isPaused) {
      return;
    }

    AudioHelper.playInvalid(context);
    invalidAC!.forward();
    postAnswer(isValid: false);
  }

  void handleTimeout() {
    if (_isStarted) {
      handleInvalid();
    } else {
      setState(() {
        _isStarted = true;
        _secondsLeft = _secondsMax;
      });
    }
  }

  Widget buildHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 64.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildSplashContent(Widget child, Color background, [IconData? icon]) {
    return Container(
      decoration: BoxDecoration(color: background),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          child: Center(
            child: child,
          ),
        ),
        if (QuestionModel.of(context).isPreLastQuestion())
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              AppLocalizations.of(context).lastQuestion,
              style: const TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
      ]),
    );
  }

  Widget buildGameContent() {
    return ScopedModelDescendant<QuestionModel>(
      builder: (context, child, model) {
        var currentQuestion = model.currentQuestion;

        return Stack(
          children: [
            Row(
              children: [
                GameButton(
                  child: const ResultIcon(success: true), //todo add down icon
                  alignment: Alignment.bottomCenter,
                  color: ThemeHelper.successColor,
                  onTap: handleValid,
                ),
                GameButton(
                  child: const ResultIcon(success: false), //todo add up icon
                  alignment: Alignment.bottomCenter,
                  color: ThemeHelper.failColor,
                  onTap: handleInvalid,
                ),
              ],
            ),
            IgnorePointer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentQuestion != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SafeArea(
                        child: Text(
                          currentQuestion.categoryName!,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  if (currentQuestion != null)
                    Expanded(
                      child: Center(
                        child: buildHeader(currentQuestion.name),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      _secondsLeft.toString(),
                      style: const TextStyle(
                        fontSize: 18.0,
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
                top: 8,
                start: 8,
                child: const BackButton()),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool showCamera = _isCameraEnabled! && _isStarted;

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return await confirmBack();
        },
        child: Stack(children: [
          if (showCamera) const CameraPreviewScreen(), // todo test this out
          if (_isPaused || _isStarted)
            Stack(
              children: [
                buildGameContent(),
                ScaleTransition(
                  scale: invalidAnimation,
                  child: buildSplashContent(
                    const ResultIcon(success: false),
                    ThemeHelper.failColor,
                  ),
                ),
                ScaleTransition(
                  scale: validAnimation,
                  child: buildSplashContent(
                    const ResultIcon(success: true),
                    ThemeHelper.successColor,
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
                    .preparationOrientationDescription), //todo remind users of directions each time
        ]),
      ),
    );
  }
}
