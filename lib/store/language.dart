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
import 'package:parlera/models/language.dart';
import 'package:parlera/repository/language.dart';
import 'package:parlera/store/store.dart';
import 'package:scoped_model/scoped_model.dart';

class LanguageModel extends StoreModel {
  LanguageRepository repository;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  late ParleraLanguage? _lang;
  ParleraLanguage? get lang => _lang;

  ParleraLanguage? get savedLang => repository.getLang();

  LanguageModel(this.repository);

  @override
  Future<void> initialize() async {
    _lang = repository.getLang();
    _isLoading = false;
    notifyListeners();
  }

  /// Saves the language to local settings and sets it as the UI language
  Future<void> saveLang(ParleraLanguage? lang) async {
    _lang = await repository.setLang(lang);
    notifyListeners();
  }

  /// Sets the UI language, but doesn't save it as a setting. Appropriate for resolving a null language setting.
  void setLanguage(ParleraLanguage lang) {
    _lang = lang;
    notifyListeners();
  }

  static LanguageModel of(BuildContext context) =>
      ScopedModel.of<LanguageModel>(context);
}
