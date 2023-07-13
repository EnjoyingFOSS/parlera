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

import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:parlera/models/question.dart';
import 'package:parlera/repository/question.dart';
import 'package:parlera/store/store.dart';

import '../models/category.dart';

class QuestionModel extends StoreModel {
  QuestionRepository repository;

  List<Question> _currentCards = [];
  List<Question> get currentCards => _currentCards;
  List<Question> get cardsAnswered =>
      _currentCards.where((q) => q.answeredCorrectly != null).toList();
  List<Question> get correctCards =>
      cardsAnswered.where((q) => q.answeredCorrectly!).toList();
  List<Question> get incorrectCards =>
      cardsAnswered.where((q) => !q.answeredCorrectly!).toList();
  final List<Question> _latestCards = [];
  List<Question> get latestCards => _latestCards;

  Category? _currentCategory;
  Category? get currentCategory => _currentCategory;
  Question? _currentCard;
  Question? get currentCard => _currentCard;

  QuestionModel(this.repository);

  void pickRandomCards(
      Category randomCategory, List<Category> allCategories, int cardsPerGame) {
    _currentCards = repository.getRandomSelection(allCategories, cardsPerGame);
    _initCards(randomCategory);
  }

  void pickCardsFromCategory(Category category, int cardsPerGame) {
    _currentCards = repository.getSelection(
      category.questions,
      category.getUniqueId(),
      cardsPerGame,
      askedRecently: _latestCards,
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

  static QuestionModel of(BuildContext context) =>
      ScopedModel.of<QuestionModel>(context);
}
