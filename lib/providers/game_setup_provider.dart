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
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlera/database/database.dart';
import 'package:parlera/models/game_setup.dart';
import 'package:parlera/providers/db_provider.dart';
import 'package:parlera/providers/deck_list_provider.dart';

class _GameSetupNotifier extends AsyncNotifier<GameSetup?> {
  @override
  FutureOr<GameSetup?> build() async {
    return null;
  }

  Future<void> setDeck(CardDeck deck, int gameDurationS, int? cardCount) async {
    state = const AsyncValue.loading();
    final db = ref.read(dbProvider);
    final deckContents = (await db.queryDeckContent(deck.id));
    final possibleCards = deckContents.cards;

    final finalCardCount = cardCount == null
        ? possibleCards.length
        : min(cardCount, possibleCards.length);
    possibleCards.shuffle();
    final gameCards = possibleCards.sublist(0, finalCardCount);

    state = AsyncValue.data(GameSetup(
      gameSetupType: GameSetupType.deck,
      deck: deck,
      deckContents: deckContents,
      gameCards: gameCards,
      gameDurationS: gameDurationS,
      isUnlimitedCardMode: cardCount == null,
    ));
  }

  Future<void> setCombo(
      List<CardDeck> combo, int gameDurationS, int? cardCount) async {
    state = const AsyncValue.loading();
    final db = ref.read(dbProvider);

    final cardsPerDeck = await Future.wait(List.generate(
      combo.length,
      (index) async => (await db.queryDeckContent(combo[index].id)).cards,
      growable: false,
    ));

    final extraCount = cardCount != null ? cardCount % combo.length : 0;
    final cardCountsPerDeck = List.generate(
        combo.length,
        (index) => cardCount != null
            ? cardCount ~/ combo.length + ((index < extraCount) ? 1 : 0)
            : cardsPerDeck[index].length);

    if (cardCount != null) {
      int unallotedCount = 0;
      for (int i = 0; i < cardCountsPerDeck.length; i++) {
        if (cardCountsPerDeck[i] > cardsPerDeck[i].length) {
          unallotedCount += cardCountsPerDeck[i] - cardsPerDeck[i].length;
          cardCountsPerDeck[i] = cardsPerDeck[i].length;
        }
      }
      for (int i = 0; i < cardCountsPerDeck.length; i++) {
        if (unallotedCount == 0) break;
        if (cardsPerDeck[i].length > cardCountsPerDeck[i]) {
          final amountToAdd = min(
              unallotedCount, cardsPerDeck[i].length - cardCountsPerDeck[i]);
          unallotedCount -= amountToAdd;
          cardCountsPerDeck[i] += amountToAdd;
        }
      }
    }

    final gameCards = List<String>.empty(growable: true);
    for (int i = 0; i < cardsPerDeck.length; i++) {
      final possibleCards = cardsPerDeck[i]..shuffle();
      gameCards.addAll(possibleCards.sublist(0, cardCountsPerDeck[i]));
    }
    gameCards.shuffle();

    state = AsyncValue.data(GameSetup(
      gameSetupType: GameSetupType.combo,
      gameCards: gameCards,
      deck: null,
      deckContents: null,
      gameDurationS: gameDurationS,
      isUnlimitedCardMode: cardCount == null,
    ));
  }

  Future<void> setGameDuration(int durationS) async {
    final oldState = state.valueOrNull;
    state = AsyncValue.data(oldState?.copyWith(gameDurationS: durationS));
  }

  Future<void> toggleFavorited() async {
    final oldState = state.asData?.value;
    final oldDeck = oldState?.deck;
    if (oldState != null && oldDeck != null) {
      final newDeck = oldDeck.copyWith(isFavorited: !oldDeck.isFavorited);
      await ref.read(dbProvider).updateDeck(newDeck);
      ref.invalidate(deckListProvider);
      state = AsyncValue.data(oldState.copyWith(deck: newDeck));
    }
  }

  Future<void> delete() async {
    final oldDeck = state.asData?.value?.deck;
    if (oldDeck != null) {
      state = const AsyncValue.loading();
      await ref.read(dbProvider).deleteDeck(oldDeck);
      ref.invalidate(deckListProvider);
      state = const AsyncValue.data(null);
    }
  }
}

final gameSetupProvider = AsyncNotifierProvider<_GameSetupNotifier, GameSetup?>(
    _GameSetupNotifier.new);
