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

import 'dart:core';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const String _storageAudioEnabledKey = 'is_audio_enabled';
  static const String _storageRotationControlEnabledKey =
      'is_rotation_control_enabled';
  // static const String storageCameraEnabledKey = 'is_camera_enabled'; // TODO CAMERA: Make it work and work well
  static const String _storageRoundTimeKey = 'round_time';
  static const String _storageGamesPlayedKey = 'games_played';
  static const String _storageGamesFinishedKey = 'games_finished';
  static const String _storageNotificationsEnabledKey =
      'is_notifications_enabled';

  final SharedPreferences storage;

  SettingsRepository({required this.storage});

  bool isAudioEnabled() {
    return storage.getBool(_storageAudioEnabledKey) ?? true;
  }

  Future<bool> toggleAudio() async {
    final value = !isAudioEnabled();

    await storage.setBool(_storageAudioEnabledKey, value);

    return value;
  }

  bool isRotationControlEnabled() {
    return storage.getBool(_storageRotationControlEnabledKey) ??
        ((!kIsWeb && (Platform.isAndroid || Platform.isIOS)) ? true : false);
  }

  Future<bool> toggleRotationControl() async {
    final value = !isRotationControlEnabled();

    await storage.setBool(_storageRotationControlEnabledKey, value);

    return value;
  }

  // TODO CAMERA: Make it work and work well
  // bool isCameraEnabled() {
  //   return storage.getBool(storageCameraEnabledKey) ?? false;
  // }

  // bool toggleCamera() {
  //   final value = !isCameraEnabled();

  //   storage.setBool(storageCameraEnabledKey, value);

  //   return value;
  // }

  int getRoundTime() {
    return storage.getInt(_storageRoundTimeKey) ?? 60;
  }

  Future<int> setRoundTime(int roundTime) async {
    await storage.setInt(_storageRoundTimeKey, roundTime);

    return roundTime;
  }

  int getGamesPlayed() {
    return storage.getInt(_storageGamesPlayedKey) ?? 0;
  }

  Future<int> increaseGamesPlayed() async {
    final gamesPlayed = getGamesPlayed() + 1;
    await storage.setInt(_storageGamesPlayedKey, gamesPlayed);

    return gamesPlayed;
  }

  int getGamesFinished() {
    return storage.getInt(_storageGamesFinishedKey) ?? 0;
  }

  Future<int> increaseGamesFinished() async {
    final gamesFinished = getGamesFinished() + 1;

    await storage.setInt(_storageGamesFinishedKey, gamesFinished);

    return gamesFinished;
  }

  bool areNotificationsEnabled() {
    return storage.getBool(_storageNotificationsEnabledKey) ?? false;
  }

  Future<void> enableNotifications() async {
    await storage.setBool(_storageNotificationsEnabledKey, true);
  }

  Future<String> getAppVersion() async {
    return (await PackageInfo.fromPlatform()).version;
  }
}
