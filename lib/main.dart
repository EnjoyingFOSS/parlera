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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:parlera/screens/category_detail/category_detail.dart';
import 'package:parlera/screens/game_gallery/game_gallery.dart';
import 'package:parlera/screens/game_play/game_play.dart';
import 'package:parlera/screens/game_summary/game_summary.dart';
import 'package:parlera/screens/home/home.dart';
import 'package:parlera/screens/tutorial/tutorial.dart';
import 'package:parlera/widgets/screen_loader.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'helpers/theme.dart';
import 'helpers/language.dart';
import 'repository/category.dart';
import 'repository/question.dart';
import 'repository/language.dart';
import 'repository/settings.dart';
import 'repository/tutorial.dart';
import 'store/store.dart';
import 'store/category.dart';
import 'store/question.dart';
import 'store/tutorial.dart';
import 'store/settings.dart';
import 'store/language.dart';
import 'store/gallery.dart';

class Parlera extends StatelessWidget {
  final Map<Type, StoreModel> stores = {};

  Parlera({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Platform.isLinux) {
      //todo change after support is added
      Wakelock.enable();
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (
        BuildContext context,
        AsyncSnapshot<SharedPreferences> snapshot,
      ) {
        if (snapshot.data == null) {
          return const ScreenLoader();
        }

        //build store
        if (stores.isEmpty) {
          final storage = snapshot.data!;
          stores.addAll({
            CategoryModel: CategoryModel(CategoryRepository(storage: storage)),
            QuestionModel: QuestionModel(QuestionRepository()),
            TutorialModel: TutorialModel(TutorialRepository(storage: storage)),
            SettingsModel: SettingsModel(SettingsRepository(storage: storage)),
            LanguageModel: LanguageModel(LanguageRepository(storage: storage)),
            GalleryModel: GalleryModel(),
          });
          for (var store in stores.values) {
            store.initialize();
          }
        }

        return ScopedModel<CategoryModel>(
          model: stores[CategoryModel] as CategoryModel,
          child: ScopedModel<QuestionModel>(
            model: stores[QuestionModel] as QuestionModel,
            child: ScopedModel<TutorialModel>(
              model: stores[TutorialModel] as TutorialModel,
              child: ScopedModel<SettingsModel>(
                model: stores[SettingsModel] as SettingsModel,
                child: ScopedModel<LanguageModel>(
                  model: stores[LanguageModel] as LanguageModel,
                  child: ScopedModel<GalleryModel>(
                    model: stores[GalleryModel] as GalleryModel,
                    child: const ParleraApp(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ParleraApp extends StatelessWidget {
  static const nullLocale =
      "vo"; //todo Ugly hack to make localeListResolutionCallback run when categoryLanguage is set; will need to be replaced if Volapük is ever added
  const ParleraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LanguageModel>(
      builder: (context, _, model) {
        return MaterialApp(
          title: 'Parlera',
          // debugShowCheckedModeBanner: false, // used for screenshots
          localeListResolutionCallback: (userLocales, supportedLocales) {
            Locale? result;
            if (LanguageHelper.codes.contains(model.language)) {
              result = Locale(model.language!, '');
            } else if (userLocales != null) {
              for (var locale in userLocales) {
                if (supportedLocales.contains(locale)) {
                  model.setLanguage(locale.languageCode);
                  result = locale;
                  break;
                }
              }
              if (result == null) {
                model.setLanguage(LanguageHelper.defaultLocale.languageCode);
                result = LanguageHelper.defaultLocale;
              }
            }
            final langCode = result!.languageCode;
            CategoryModel.of(context).load(langCode);
            QuestionModel.of(context).load(langCode);
            return result;
          },
          locale: Locale(model.language ?? nullLocale, ''),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales:
              LanguageHelper.codes.map((code) => Locale(code, '')),
          theme: ThemeHelper.darkTheme,
          home: const HomeScreen(),
          routes: {
            '/category': (context) => const CategoryDetailScreen(),
            '/game-play': (context) => const GamePlayScreen(),
            '/game-summary': (context) => const GameSummaryScreen(),
            '/game-gallery': (context) => const GameGalleryScreen(),
            '/tutorial': (context) => const TutorialScreen(),
          },
        );
      },
    );
  }
}

void main() {
  runApp(Parlera());
}
