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

import 'package:flutter/widgets.dart';
import 'package:parlera/models/category.dart';
import 'package:parlera/models/phrase_card.dart';
import 'package:parlera/repository/card.dart';
import 'package:parlera/store/store.dart';
import 'package:scoped_model/scoped_model.dart';

class CardModel extends StoreModel {
  CardRepository repository;

  List<PhraseCard> _currentCards = [];
  List<PhraseCard> get currentCards => _currentCards;
  List<PhraseCard> get cardsAnswered =>
      _currentCards.where((q) => q.answeredCorrectly != null).toList();
  List<PhraseCard> get correctCards =>
      cardsAnswered.where((q) => q.answeredCorrectly!).toList();
  List<PhraseCard> get incorrectCards =>
      cardsAnswered.where((q) => !q.answeredCorrectly!).toList();
  final List<PhraseCard> _latestCards = [];
  List<PhraseCard> get latestCards => _latestCards;

  Category? _currentCategory;
  Category? get currentCategory => _currentCategory;
  PhraseCard? _currentCard;
  PhraseCard? get currentCard => _currentCard;

  CardModel(this.repository);

  void pickRandomCards(Category randomCategory, List<Category> allCategories,
      int? cardsPerGame) {
    _currentCards = repository.getRandomSelection(allCategories, cardsPerGame);
    _initCards(randomCategory);
  }

  void pickCardsFromCategory(Category category, int? cardsPerGame) {
    _currentCards = repository.getSelection(
      category.cards,
      category.getUniqueId(),
      cardsPerGame,
      askedRecently: cardsAnswered,
    );
    _initCards(category);
  }

  void _initCards(Category category) {
    for (final q in _currentCards) {
      q.answeredCorrectly = null;
    }
    _latestCards.addAll(_currentCards);
    _currentCategory = category;
    _currentCard = _currentCards[0];
    notifyListeners();
  }

  bool isPreLastCard() {
    if (_currentCard == null) {
      return false;
    }

    final nextCard = repository.getNext(_currentCards, _currentCard!);
    if (nextCard == null) {
      return false;
    }

    return repository.getNext(_currentCards, nextCard) == null;
  }

  void setNextCard() {
    if (_currentCard != null) {
      _currentCard = repository.getNext(_currentCards, _currentCard!);
      notifyListeners();
    }
  }

  void answerCard(bool isValid) {
    if (_currentCard != null) {
      _currentCard!.answeredCorrectly = isValid;
      notifyListeners();
    }
  }

  static CardModel of(BuildContext context) =>
      ScopedModel.of<CardModel>(context);
}
