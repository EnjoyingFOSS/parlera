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
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlera/database/database.dart';
import 'package:parlera/models/full_deck_companion.dart';
import 'package:parlera/models/parlera_locale.dart';
import 'package:parlera/providers/db_provider.dart';

class DeckListState {
  final ParleraLocale locale;
  final List<CardDeck> allDecks;
  final List<CardDeck> favorites;

  DeckListState(
      {required this.locale, required this.allDecks, required this.favorites});
}

class _DeckListNotifier extends AsyncNotifier<DeckListState?> {
  @override
  FutureOr<DeckListState?> build() async {
    final previousValue = state.valueOrNull;
    if (previousValue != null) {
      return await _getStateFromLocale(previousValue.locale);
    } else {
      return null;
    }
  }

  Future<DeckListState?> _getStateFromLocale(ParleraLocale locale) async =>
      await _getStateFromDB(
        locale,
        ref.read(dbProvider),
      );

  Future<void> setLocale(Locale locale) async {
    final oldLocale = state.valueOrNull?.locale.toLocale();

    if (locale != oldLocale) {
      state = AsyncValue.data(
          await _getStateFromLocale(ParleraLocale.fromLocale(locale)));
    }
  }

  Future<void> createOrUpdateCustomDeck(
      FullDeckCompanion fullDeckCompanion) async {
    final oldState = state.valueOrNull;
    state = const AsyncValue.loading();
    final db = ref.read(dbProvider);
    await db.insertOrUpdateFullDeck(
        fullDeckCompanion.deckCompanion, fullDeckCompanion.contentCompanion);
    final curLocale = oldState?.locale;
    if (curLocale != null &&
        fullDeckCompanion.deckCompanion.localeCode.value ==
            curLocale.getLocaleCode()) {
      state = AsyncValue.data(await _getStateFromDB(curLocale, db));
    } else {
      state = AsyncValue.data(oldState);
    }
  }

  Future<DeckListState> _getStateFromDB(
      ParleraLocale appLocale, AppDatabase db) async {
    final decks = await db.queryCardDecks(appLocale);
    return DeckListState(
      locale: appLocale,
      allDecks: decks,
      favorites: decks.where((c) => c.isFavorited).toList(growable: false),
    );
  }
}

final deckListProvider =
    AsyncNotifierProvider<_DeckListNotifier, DeckListState?>(
        _DeckListNotifier.new);
