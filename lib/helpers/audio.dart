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

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:parlera/store/settings.dart';

class AudioHelper {
  static final _player = AudioPlayer();
  static final _soundIncorrect = AssetSource('audio/choice_incorrect.wav');
  static final _soundCorrect = AssetSource('audio/choice_correct.wav');
  static final _soundCountdown = AssetSource('audio/countdown.wav');
  static final _soundStart = AssetSource('audio/start.wav');
  static final _soundCountdownStart = AssetSource('audio/countdown_start.wav');
  static final _soundTimesUp = AssetSource('audio/times_up.wav');
  static final _soundResults = AssetSource('audio/results.wav');

  static bool _audioEnabled(BuildContext context) =>
      SettingsModel.of(context).isAudioEnabled;

  static Future<void> playIncorrect(BuildContext context) async {
    if (_audioEnabled(context)) {
      await _player.stop();
      await _player.play(
          _soundIncorrect); //TODO the stop() is temporary, due to https://github.com/bluefireteam/audioplayers/issues/1165
    }
  }

  static Future<void> playCorrect(BuildContext context) async {
    if (_audioEnabled(context)) {
      await _player.stop();
      await _player.play(
          _soundCorrect); //TODO the stop() is temporary, due to https://github.com/bluefireteam/audioplayers/issues/1165
    }
  }

  static Future<void> playCountdown(BuildContext context) async {
    if (_audioEnabled(context)) {
      await _player.stop();
      await _player.play(
          _soundCountdown); //TODO the stop() is temporary, due to https://github.com/bluefireteam/audioplayers/issues/1165
    }
  }

  static Future<void> playStart(BuildContext context) async {
    if (_audioEnabled(context)) {
      await _player.stop();
      await _player.play(
          _soundStart); //TODO the stop() is temporary, due to https://github.com/bluefireteam/audioplayers/issues/1165
    }
  }

  static Future<void> playCountdownStart(BuildContext context) async {
    if (_audioEnabled(context)) {
      await _player.stop();
      await _player.play(_soundCountdownStart);
      //TODO the stop() is temporary, due to https://github.com/bluefireteam/audioplayers/issues/1165
    }
  }

  static Future<void> playTimesUp(BuildContext context) async {
    if (_audioEnabled(context)) {
      await _player.stop();
      await _player.play(_soundTimesUp);
      //TODO the stop() is temporary, due to https://github.com/bluefireteam/audioplayers/issues/1165
    }
  }

  static Future<void> playResults(BuildContext context) async {
    if (_audioEnabled(context)) {
      await _player.stop();
      await _player.play(_soundResults);
      //TODO the stop() is temporary, due to https://github.com/bluefireteam/audioplayers/issues/1165
    }
  }
}