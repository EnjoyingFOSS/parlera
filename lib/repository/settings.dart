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

import 'dart:core';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:parlera/models/game_time_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const defaultCardsPerGame = 10;

  static const _storageAudioEnabledKey = 'is_audio_enabled';
  static const _storageRotationControlEnabledKey =
      'is_rotation_control_enabled';
  static const _storageGameTimeTypeKey = 'game_time_type';
  static const _storageCustomGameTimeKey = 'custom_game_time';
  static const _unlimitedCardsPerGameKey = 'unlimited_cards';
  static const _cardsPerGameKey = 'cards_per_game';
  static const _storageNotificationsEnabledKey = 'is_notifications_enabled';

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

  GameTimeType getGameTimeType() {
    final typePos = storage.getInt(_storageGameTimeTypeKey);
    return typePos == null ? GameTimeType.medium : GameTimeType.values[typePos];
  }

  Future<GameTimeType> setGameTimeType(GameTimeType gameTimeType) async {
    await storage.setInt(_storageGameTimeTypeKey, gameTimeType.index);

    return gameTimeType;
  }

  int getCustomGameTime() => storage.getInt(_storageCustomGameTimeKey) ?? 120;

  Future<int> setCustomGameTime(int customGameTime) async {
    await storage.setInt(_storageCustomGameTimeKey, customGameTime);

    return customGameTime;
  }

  int? getCardsPerGame() =>
      (storage.getBool(_unlimitedCardsPerGameKey) ?? false)
          ? null
          : storage.getInt(_cardsPerGameKey) ?? defaultCardsPerGame;

  Future<int?> setCardsPerGame(int? cardsPerGame) async {
    final isUnlimited = cardsPerGame == null;
    if (!isUnlimited) {
      await storage.setInt(_cardsPerGameKey, cardsPerGame);
    }
    await storage.setBool(_unlimitedCardsPerGameKey, isUnlimited);

    return cardsPerGame;
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
