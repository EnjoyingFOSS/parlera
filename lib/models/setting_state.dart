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

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parlera/models/game_duration_type.dart';
import 'package:parlera/models/parlera_locale.dart';

part 'setting_state.freezed.dart';

@freezed
class SettingState with _$SettingState {
  const SettingState._();

  static const defaultAudioEnabled = true;
  static final defaultRotationEnabled =
      !kIsWeb && (Platform.isAndroid || Platform.isIOS) ? true : false;
  static const defaultGameDurationType = GameDurationType.medium;
  static const defaultCardsPerGame = 10;
  static const defaultUnlimitedCardsPerGame = false;
  static const defaultCustomGameDuration = 120;

  const factory SettingState({
    @Default(null) ParleraLocale? preferredLocale,
    @Default(SettingState.defaultAudioEnabled) bool audioEnabled,
    required bool rotationEnabled,
    @Default(SettingState.defaultGameDurationType) GameDurationType gameDurationType,
    @Default(SettingState.defaultCustomGameDuration) int customGameDuration,
    @Default(SettingState.defaultCardsPerGame) int? cardsPerGame,
  }) = _SettingState;
}
