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
import '../models/category_type.dart';

class QuestionModel extends StoreModel {
  static const _questionsPerGame = 10;

  QuestionRepository repository;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Map<String, List<Question>> _questions = {};
  Map<String, List<Question>> get questions => _questions;

  List<Question> _currentQuestions = [];
  List<Question> get currentQuestions => _currentQuestions;
  List<Question> get questionsAnswered =>
      _currentQuestions.where((q) => q.answeredCorrectly != null).toList();
  List<Question> get questionsPassed =>
      questionsAnswered.where((q) => q.answeredCorrectly!).toList();
  List<Question> get questionsFailed =>
      questionsAnswered.where((q) => !q.answeredCorrectly!).toList();
  final List<Question> _latestQuestions = [];
  List<Question> get latestQuestions => _latestQuestions;

  Question? _currentQuestion;
  Question? get currentQuestion => _currentQuestion;

  QuestionModel(this.repository);

  Future<void> load(String languageCode) async {
    _isLoading = true;
    notifyListeners();

    _questions = await repository.getAllQuestions(languageCode);
    _isLoading = false;
    notifyListeners();
  }

  void pickGameQuestions(Category category) {
    if (category.type == CategoryType.random) {
      _currentQuestions =
          repository.getRandomSelection(questions, _questionsPerGame);
    } else {
      _currentQuestions = repository.getSelection(
        _questions,
        category.getUniqueId(),
        _questionsPerGame,
        excluded: _latestQuestions,
      );
    }
    for (var q in _currentQuestions) {
      q.answeredCorrectly = null;
    }
    _latestQuestions.addAll(_currentQuestions);
    _currentQuestion = _currentQuestions[0];
    notifyListeners();
  }

  bool isPreLastQuestion() {
    if (_currentQuestion == null) {
      return false;
    }

    var nextQuestion = repository.getNext(_currentQuestions, _currentQuestion!);
    if (nextQuestion == null) {
      return false;
    }

    return repository.getNext(_currentQuestions, nextQuestion) == null;
  }

  void setNextQuestion() {
    if (_currentQuestion != null) {
      _currentQuestion =
          repository.getNext(_currentQuestions, _currentQuestion!);
      notifyListeners();
    }
  }

  void answerQuestion(bool isValid) {
    if (_currentQuestion != null) {
      _currentQuestion!.answeredCorrectly = isValid;
      notifyListeners();
    }
  }

  static QuestionModel of(BuildContext context) =>
      ScopedModel.of<QuestionModel>(context);
}
