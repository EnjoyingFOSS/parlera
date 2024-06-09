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

import 'package:parlera/models/category.dart';
import 'package:parlera/models/phrase_card.dart';

class CardRepository {
  //TODO convert to static helper

  List<PhraseCard> _getShuffledCards(List<PhraseCard> cards, int? limit,
      {List<PhraseCard> excluded = const []}) {
    var allowedCards = cards.where((q) => !excluded.contains(q)).toList()
      ..shuffle();

    if (limit == null) {
      allowedCards.addAll(excluded);
      return allowedCards;
    }

    if (allowedCards.length < limit) {
      //include excluded recent cards if there aren't enough cards overall

      final remainingLimit = limit - allowedCards.length;
      final remainingCards = cards.where((q) => excluded.contains(q)).toList()
        ..shuffle();
      if (remainingLimit < remainingCards.length) {
        remainingCards.sublist(0, remainingLimit);
      }
      allowedCards.addAll(remainingCards);
    } else {
      allowedCards = allowedCards.sublist(0, limit);
    }

    return allowedCards;
  }

  List<PhraseCard> getRandomSelection(
    List<Category> categories,
    int? limit,
  ) {
    categories.shuffle();
    categories = categories.sublist(0, 3);

    final result = List<PhraseCard>.from(
      //TODO THIS CAN LEAD TO FEWER CARDS IF I PICK CATEGORIES WITH JUST 1 CARD EACH (but is that really a problem worth solving, though?)
      categories
          .map((cat) => _getShuffledCards(
              cat.cards, limit == null ? null : (limit ~/ 3) + 1))
          .expand<PhraseCard>((i) => i),
    );

    return _getShuffledCards(result, limit);
  }

  List<PhraseCard> getSelection(
          List<PhraseCard> categoryCards, String categoryId, int? limit,
          {List<PhraseCard> askedRecently = const []}) =>
      _getShuffledCards(
        categoryCards,
        limit,
        excluded: askedRecently,
      );

  PhraseCard? getNext(List<PhraseCard> cards, PhraseCard current) {
    final nextIndex = cards.indexOf(current) + 1;

    if (nextIndex == cards.length) {
      return null;
    }

    return cards[nextIndex];
  }
}
