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

import 'package:parlera/models/question.dart';
import '../models/category.dart';

class QuestionRepository {
  //TODO convert to static helper

  List<Question> _getShuffledQuestions(List<Question> questions, int limit,
      {List<Question> excluded = const []}) {
    var allowedQuestions =
        questions.where((q) => !excluded.contains(q)).toList();
    allowedQuestions.shuffle();

    if (allowedQuestions.length < limit) {
      //include excluded recent questions if there aren't enough questions overall

      final remainingLimit = limit - allowedQuestions.length;
      final remainingQuestions =
          questions.where((q) => excluded.contains(q)).toList();
      remainingQuestions.shuffle();
      if (remainingLimit < remainingQuestions.length) {
        remainingQuestions.sublist(0, remainingLimit);
      }
      allowedQuestions.addAll(remainingQuestions);
    } else {
      allowedQuestions = allowedQuestions.sublist(0, limit);
    }

    return allowedQuestions;
  }

  List<Question> getRandomSelection(
    List<Category> categories,
    int limit,
  ) {
    categories.shuffle();
    categories = categories.sublist(0, 3);

    List<Question> result = List.from(
      //todo THIS CAN LEAD TO FEWER QUESTIONS IF I PICK CATEGORIES WITH JUST 1 QUESTION EACH (but is that really a problem worth solving, though?)
      categories
          .map((cat) => _getShuffledQuestions(cat.questions, (limit ~/ 3) + 1))
          .expand<Question>((i) => i),
    );

    return _getShuffledQuestions(result, limit);
  }

  List<Question> getSelection(
          List<Question> categoryQs, String categoryId, int limit,
          {List<Question> askedRecently = const []}) =>
      _getShuffledQuestions(
        categoryQs,
        limit,
        excluded: askedRecently,
      );

  Question? getNext(List<Question> questions, Question current) {
    int nextIndex = questions.indexOf(current) + 1;

    if (nextIndex == questions.length) {
      return null;
    }

    return questions[nextIndex];
  }
}
