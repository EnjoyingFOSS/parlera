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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlera/helpers/audio.dart';
import 'package:parlera/helpers/theme.dart';
import 'package:parlera/models/game_setup.dart';
import 'package:parlera/models/setting_state.dart';
import 'package:parlera/providers/audio_provider.dart';
import 'package:parlera/providers/game_setup_provider.dart';
import 'package:parlera/providers/game_state_provider.dart';
import 'package:parlera/providers/setting_provider.dart';
import 'package:parlera/providers/vibration_service_provider.dart';
import 'package:parlera/screens/game_player/tilt_service.dart';
import 'package:parlera/screens/game_player/widgets/game_content.dart';
import 'package:parlera/screens/game_player/widgets/prep_screen.dart';
import 'package:parlera/screens/game_player/widgets/splash_content.dart';
import 'package:parlera/widgets/centered_scrollable_container.dart';
import 'package:parlera/widgets/empty_content.dart';
import 'package:parlera/widgets/error_content.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class GamePlayerScreen extends ConsumerWidget {
  const GamePlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    
    final rotationEnabled = ref.watch(
            settingProvider.select((v) => v.valueOrNull?.rotationEnabled)) ??
        SettingState.defaultRotationEnabled;

    return ref.watch(gameSetupProvider).when(
          error: (exception, stackTrace) => Scaffold(
            body: CenteredScrollableContainer(
              child: ErrorContent(exception: exception, stackTrace: stackTrace),
            ),
          ),
          loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive())),
          data: (gameSetup) {
            if (gameSetup == null) {
              return Scaffold(
                body: CenteredScrollableContainer(
                  child: EmptyContent(
                    title: l10n.noDeckTitle,
                    subtitle: l10n.emptyCategoryQuestions,
                    iconData: Icons.apps_rounded,
                  ),
                ),
              );
            } else {
              return _GamePlayerContent(gameSetup, rotationEnabled);
            }
          },
        );
  }
}

class _GamePlayerContent extends ConsumerStatefulWidget {
  final GameSetup gameSetup;
  final bool rotationEnabled;

  const _GamePlayerContent(this.gameSetup, this.rotationEnabled);

  @override
  _GamePlayerContentState createState() => _GamePlayerContentState();
}

class _GamePlayerContentState extends ConsumerState<_GamePlayerContent>
    with TickerProviderStateMixin {
  static const _secondsPrep = 5;

  late final TiltService? _tiltService;
  Timer? _gameTimer;
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

    unawaited(SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]));
    unawaited(WakelockPlus.enable());

    _startTimer();

    if (widget.rotationEnabled) {
      _tiltService = TiltService(
          handleIncorrect: _handleIncorrect,
          handleCorrect: _handleCorrect,
          isPlaying: () => !_isStarted || _isPausedForShowingResult);
      _secondsLeft = _secondsPrep;
    } else {
      _tiltService = null;
      _secondsLeft = 0;
    }

    _initAnimations();
  }

  AnimationController _createAnswerAnimationController() {
    const duration = Duration(milliseconds: 1500);
    final controller = AnimationController(vsync: this, duration: duration);
    controller.addStatusListener((listener) async {
      if (listener == AnimationStatus.completed) {
        controller.reset();
        await _nextCard();
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
    unawaited(SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]));
    unawaited(WakelockPlus.disable());

    if (_rotateSubscription != null) {
      _rotateSubscription!.cancel();
    }

    _correctAC?.dispose();
    _incorrectAC?.dispose();
    _tiltService?.dispose();

    _stopTimer();
    super.dispose();
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

  Future<void> _showScore() async =>
      await Navigator.pushReplacementNamed(context, '/game-summary');

  Future<void> _onClose() async {
    final l10n = AppLocalizations.of(context);

    await showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(l10n.gameCancelConfirmation),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(l10n.gameCancelDeny)),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(l10n.gameCancelApprove))
              ],
            ));
  }

  Future<void> _nextCard() async {
    _stopTimer();
    if (_secondsLeft == 0) {
      return _showScore();
    }

    final movedToNext = ref
        .read(gameStateProvider.notifier)
        .moveToNextCard(widget.gameSetup.gameCards.length);

    if (!movedToNext) {
      return _showScore();
    }

    setState(() {
      _isPausedForShowingResult = false;
    });

    _startTimer();
  }

  void _postAnswer({required bool isCorrect, bool outOfTime = false}) {
    unawaited(ref
        .read(vibrationServiceProvider.future)
        .then((vibrationService) => vibrationService.vibrate()));
    ref.read(gameStateProvider.notifier).answerCurrentCard(isCorrect);

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
        _secondsLeft = widget.gameSetup.gameDurationS;
      });
    }
  }

  void _handleCorrect() {
    if (_isPausedForShowingResult) {
      return;
    }

    AudioHelper.playCorrect(ref.read(audioProvider));
    _correctAC!.forward();
    _postAnswer(isCorrect: true);
  }

  void _handleIncorrect() {
    if (_isPausedForShowingResult) {
      return;
    }

    AudioHelper.playIncorrect(ref.read(audioProvider));
    _incorrectAC!.forward();
    _postAnswer(isCorrect: false);
  }

  void _handleOutOfTimeIncorrect() {
    if (_isPausedForShowingResult) {
      return;
    }

    AudioHelper.playTimesUp(ref.read(audioProvider));
    _incorrectAC!.forward();
    _postAnswer(isCorrect: false, outOfTime: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (!_isStarted) {
      if (_secondsLeft == 0) {
        if (_tiltService == null) {
          AudioHelper.playCountdownStart(ref.read(audioProvider));
        } else {
          AudioHelper.playStart(ref.read(audioProvider));
        }
      } else {
        AudioHelper.playCountdown(ref.read(audioProvider));
      }
    }
    final gameState =
        ref.read(gameStateProvider).state;

    return Scaffold(
      backgroundColor: widget.gameSetup.darkColorScheme.surface,
      body: WillPopScope(
        onWillPop: () async {
          await _onClose();
          return false;
        },
        child: Stack(children: [
          if (_isPausedForShowingResult || _isStarted)
            Stack(
              children: [
                GameContent(
                    handleCorrect: _handleCorrect,
                    handleIncorrect: _handleIncorrect,
                    currentCard:
                        widget.gameSetup.gameCards[gameState!.currentIndex],
                    gameSetup: widget.gameSetup,
                    secondsLeft: _secondsLeft.toString()),
                ScaleTransition(
                  scale: _incorrectAnimation,
                  child: SplashContent(
                    isOutOfTime: _secondsLeft <= 0,
                    isNextToLast: gameState.currentIndex ==
                        widget.gameSetup.gameCards.length - 2,
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
                    isNextToLast: gameState.currentIndex ==
                        widget.gameSetup.gameCards.length - 2,
                    background: ThemeHelper.successColorLighter,
                    iconData: Icons.sentiment_satisfied_alt_rounded,
                  ),
                ),
              ],
            )
          else if (_secondsLeft == 0)
            PrepScreen(countdownText: l10n.labelGo)
          else
            PrepScreen(
                countdownText: _secondsLeft.toString(),
                descriptionText: l10n
                    .preparationOrientationDescription), //TODO remind users of directions each time
        ]),
      ),
    );
  }
}
