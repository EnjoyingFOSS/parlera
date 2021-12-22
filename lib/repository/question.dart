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

import 'dart:core';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'package:parlera/models/question.dart';

class QuestionRepository {
  Future<Map<String?, List<Question>>> getAll(String languageCode) async {
    languageCode = languageCode.toLowerCase();
    List<dynamic> categoryList = json.decode(await rootBundle
        .loadString('assets/data/categories_$languageCode.json'));

    Map<String?, List<Question>> questions = {};
    for (Map<String, dynamic> categoryMap in categoryList) {
      questions[categoryMap['id']] = List.from(categoryMap['questions']
          .map((name) => Question(name, categoryMap['name'])));
    }

    return questions;
  }

  _getRandomQuestions(List<Question> questions, int limit,
      {List<Question?> excluded = const []}) {
    var allowedQuestions =
        questions.where((q) => !excluded.contains(q)).toList();
    allowedQuestions.shuffle();
    allowedQuestions = allowedQuestions.sublist(0, limit);

    return allowedQuestions;
  }

  List<Question> getRandomMixUp(
    Map<String?, List<Question>> questions,
    int limit,
  ) {
    var keys = questions.keys.where((q) => q != 'mixup').toList();
    keys.shuffle();
    keys = keys.sublist(0, 3);

    List<Question> result = List.from(
      keys
          .map((k) => _getRandomQuestions(questions[k]!, (limit ~/ 3) + 1))
          .expand((i) => i),
    );

    return _getRandomQuestions(result, limit);
  }

  List<Question> getRandom(
      Map<String?, List<Question>> questions, String? categoryId, int limit,
      {List<Question?> excluded = const []}) {
    if (categoryId == 'mixup') {
      return getRandomMixUp(questions, limit);
    }

    return _getRandomQuestions(
      questions[categoryId]!,
      limit,
      excluded: excluded,
    );
  }

  Question? getNext(List<Question?> questions, Question? current) {
    int nextIndex = questions.indexOf(current) + 1;

    if (nextIndex == questions.length) {
      return null;
    }

    return questions[nextIndex];
  }
}
