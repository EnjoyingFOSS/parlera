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

import 'dart:math';

import 'package:parlera/models/setting_state.dart';

/// Saved as an intEnum in shared_preferences
enum GameDurationType {
  short,
  medium,
  long,
  custom;

  static const _defaultGameDurationS = 30;

  int getGameDuration(int? defaultDeckGameDurationS, int? settingsCardsPerGame,
      int settingsCustomGameDuration) {
    final gameDurationMultiplier = settingsCardsPerGame != null
        ? (settingsCardsPerGame / SettingState.defaultCardsPerGame)
        : 1;
    final mediumGameDuration = ((defaultDeckGameDurationS ?? _defaultGameDurationS) *
            gameDurationMultiplier)
        .ceil();
    final mediumGameDurationDiv2 = max(mediumGameDuration ~/ 2, 1);
    switch (this) {
      case GameDurationType.short:
        return mediumGameDurationDiv2;
      case GameDurationType.medium:
        return mediumGameDuration;
      case GameDurationType.long:
        return mediumGameDuration + mediumGameDurationDiv2;
      case GameDurationType.custom:
        return settingsCustomGameDuration;
    }
  }
}
