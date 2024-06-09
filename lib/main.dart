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

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:l10n_esperanto/l10n_esperanto.dart';
import 'package:parlera/helpers/theme.dart';
import 'package:parlera/models/language.dart';
import 'package:parlera/repository/card.dart';
import 'package:parlera/repository/category.dart';
import 'package:parlera/repository/language.dart';
import 'package:parlera/repository/settings.dart';
import 'package:parlera/repository/tutorial.dart';
import 'package:parlera/screens/game_cover/game_cover.dart';
import 'package:parlera/screens/game_player/game_player.dart';
import 'package:parlera/screens/game_results/game_results.dart';
import 'package:parlera/screens/home/home.dart';
import 'package:parlera/screens/tutorial/tutorial.dart';
import 'package:parlera/store/card.dart';
import 'package:parlera/store/category.dart';
import 'package:parlera/store/language.dart';
import 'package:parlera/store/settings.dart';
import 'package:parlera/store/store.dart';
import 'package:parlera/store/tutorial.dart';
import 'package:parlera/widgets/screen_loader.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

class Parlera extends StatelessWidget {
  final Map<Type, StoreModel> stores = {};

  Parlera({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb && !Platform.isLinux) {
      //TODO change after support is added
      Wakelock.enable();
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
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
            CardModel: CardModel(CardRepository()),
            TutorialModel: TutorialModel(TutorialRepository(storage: storage)),
            SettingsModel: SettingsModel(SettingsRepository(storage: storage)),
            LanguageModel: LanguageModel(LanguageRepository(storage: storage)),
            // GalleryModel: GalleryModel(),
          });
          for (final store in stores.values) {
            store.initialize();
          }
        }

        return ScopedModel<CategoryModel>(
          model: stores[CategoryModel] as CategoryModel,
          child: ScopedModel<CardModel>(
            model: stores[CardModel] as CardModel,
            child: ScopedModel<TutorialModel>(
              model: stores[TutorialModel] as TutorialModel,
              child: ScopedModel<SettingsModel>(
                model: stores[SettingsModel] as SettingsModel,
                child: ScopedModel<LanguageModel>(
                  model: stores[LanguageModel] as LanguageModel,
                  child: const ParleraApp(),
                  // ),
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
  const ParleraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LanguageModel>(builder: (context, _, model) {
      return MaterialApp(
        title: 'Parlera',
        // debugShowCheckedModeBanner: false, // used for screenshots
        localeListResolutionCallback: (userLocales, supportedLocales) {
          ParleraLanguage? resLang = model.lang;
          if (resLang == null) {
            // system language resolution
            for (final locale in userLocales ?? const <Locale>[]) {
              try {
                final lang = ParleraLanguage.fromLocale(locale);
                model.setLanguage(lang);
                resLang = lang;
                break;
              } catch (_) {}
            }
            if (resLang == null) {
              model.setLanguage(ParleraLanguage.defaultLang);
              resLang = ParleraLanguage.defaultLang;
            }
          }
          CategoryModel.of(context).load(resLang);
          return resLang.toLocale();
        },
        locale: model.lang?.toLocale(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          MaterialLocalizationsEo.delegate,
          CupertinoLocalizationsEo.delegate,
          LocaleNamesLocalizationsDelegate()
        ],
        supportedLocales: ParleraLanguage.values.map((lang) => lang.toLocale()),
        theme: ThemeHelper.darkTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/category': (context) => const GameCoverScreen(),
          '/game-play': (context) => const GamePlayerScreen(),
          '/game-summary': (context) => const GameResultsScreen(),
          '/tutorial': (context) => const TutorialScreen(),
        },
      );
    });
  }
}

void main() {
  runApp(Parlera());
}
