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

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlera/models/game_duration_type.dart';
import 'package:parlera/models/parlera_locale.dart';
import 'package:parlera/models/setting_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _SettingStateNotifier extends AsyncNotifier<SettingState> {
  static const _languageKey = 'language';
  static const _audioEnabledKey = 'is_audio_enabled';
  static const _rotationEnabledKey = 'is_rotation_control_enabled';
  static const _gameDurationTypeKey = 'game_time_type';
  static const _customGameDurationKey = 'custom_game_time';
  static const _unlimitedCardsPerGameKey = 'unlimited_cards';
  static const _cardsPerGameKey = 'cards_per_game';

  @override
  FutureOr<SettingState> build() async {
    final preferences = await SharedPreferences.getInstance();

    final langCode = preferences.getString(_languageKey);
    final gameDurationTypePos = preferences.getInt(_gameDurationTypeKey);

    return SettingState(
      preferredLocale:
          langCode != null ? ParleraLocale.fromLocaleCode(langCode) : null,
      audioEnabled: preferences.getBool(_audioEnabledKey) ??
          SettingState.defaultAudioEnabled,
      rotationEnabled: preferences.getBool(_rotationEnabledKey) ??
          SettingState.defaultRotationEnabled,
      gameDurationType: gameDurationTypePos != null
          ? GameDurationType.values[gameDurationTypePos]
          : SettingState.defaultGameDurationType,
      customGameDuration: preferences.getInt(_customGameDurationKey) ??
          SettingState.defaultCustomGameDuration,
      cardsPerGame: preferences.getBool(_unlimitedCardsPerGameKey) ??
              SettingState.defaultUnlimitedCardsPerGame
          ? null
          : preferences.getInt(_cardsPerGameKey) ??
              SettingState.defaultCardsPerGame,
    );
  }

  Future<void> setPreferredLocale(ParleraLocale? locale) async {
    final oldState = state.valueOrNull;
    if (oldState != null) {
      final sharedPreferences = await SharedPreferences.getInstance();
      if (locale != null) {
        await sharedPreferences.setString(_languageKey, locale.getLocaleCode());
      } else {
        await sharedPreferences.remove(_languageKey);
      }
      state = AsyncValue.data(oldState.copyWith(preferredLocale: locale));
    }
  }

  Future<void> setAudioEnabled(bool audioEnabled) async {
    final oldState = state.valueOrNull;
    if (oldState != null) {
      await (await SharedPreferences.getInstance())
          .setBool(_audioEnabledKey, audioEnabled);
      state = AsyncValue.data(oldState.copyWith(audioEnabled: audioEnabled));
    }
  }

  Future<void> setRotationEnabled(bool rotationEnabled) async {
    final oldState = state.valueOrNull;
    if (oldState != null) {
      await (await SharedPreferences.getInstance())
          .setBool(_rotationEnabledKey, rotationEnabled);
      state =
          AsyncValue.data(oldState.copyWith(rotationEnabled: rotationEnabled));
    }
  }

  Future<void> setGameDurationType(GameDurationType durationType) async {
    final oldState = state.valueOrNull;
    if (oldState != null) {
      await (await SharedPreferences.getInstance())
          .setInt(_gameDurationTypeKey, durationType.index);
      state =
          AsyncValue.data(oldState.copyWith(gameDurationType: durationType));
    }
  }

  Future<void> setCustomGameDuration(int duration) async {
    final oldState = state.valueOrNull;
    if (oldState != null) {
      await (await SharedPreferences.getInstance())
          .setInt(_customGameDurationKey, duration);
      state = AsyncValue.data(oldState.copyWith(customGameDuration: duration));
    }
  }

  Future<void> setCardsPerGame(int? cardsPerGame) async {
    final oldState = state.valueOrNull;
    if (oldState != null) {
      final sharedPreferences = await SharedPreferences.getInstance();
      if (cardsPerGame == null) {
        await sharedPreferences.setBool(_unlimitedCardsPerGameKey, true);
      } else {
        await sharedPreferences.setBool(_unlimitedCardsPerGameKey, false);
        await sharedPreferences.setInt(_cardsPerGameKey, cardsPerGame);
      }
      state = AsyncValue.data(oldState.copyWith(cardsPerGame: cardsPerGame));
    }
  }
}

final settingProvider =
    AsyncNotifierProvider<_SettingStateNotifier, SettingState>(
        _SettingStateNotifier.new);
