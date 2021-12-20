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


import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:parlera/ui/shared/screen_loader.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

import 'localizations.dart';
import 'ui/theme.dart';
import 'ui/screens/category_detail.dart';
import 'ui/screens/game_play.dart';
import 'ui/screens/game_summary.dart';
import 'ui/screens/game_gallery.dart';
import 'ui/screens/settings.dart';
import 'ui/screens/tutorial.dart';
import 'ui/screens/home.dart';
import 'ui/screens/contributors.dart';
import 'services/language.dart';
import 'repository/category.dart';
import 'repository/question.dart';
import 'repository/language.dart';
import 'repository/settings.dart';
import 'repository/tutorial.dart';
import 'repository/contributor.dart';
import 'store/store.dart';
import 'store/category.dart';
import 'store/question.dart';
import 'store/tutorial.dart';
import 'store/settings.dart';
import 'store/language.dart';
import 'store/gallery.dart';
import 'store/contributor.dart';

class App extends StatelessWidget {
  final Map<Type, StoreModel> stores = {};

  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();

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

        return buildStore(context, snapshot.data);
      },
    );
  }

  Widget buildStore(BuildContext context, SharedPreferences? storage) {
    if (stores.isEmpty) {
      stores.addAll({
        CategoryModel: CategoryModel(CategoryRepository(storage: storage)),
        QuestionModel: QuestionModel(QuestionRepository()),
        TutorialModel: TutorialModel(TutorialRepository(storage: storage)),
        SettingsModel: SettingsModel(SettingsRepository(storage: storage)),
        LanguageModel: LanguageModel(LanguageRepository(storage: storage)),
        GalleryModel: GalleryModel(),
        ContributorModel: ContributorModel(ContributorRepository()),
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
                child: ScopedModel<ContributorModel>(
                  model: stores[ContributorModel] as ContributorModel,
                  child: buildApp(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildApp(BuildContext context) {
    return ScopedModelDescendant<LanguageModel>(
      builder: (context, child, model) {
        if (model.isLoading) {
          return const ScreenLoader();
        }

        bool languageSet = model.language != null;
        if (languageSet) {
          CategoryModel.of(context).load(model.language!);
          QuestionModel.of(context).load(model.language!);
        }

        return MaterialApp(
          title: 'Parlera',
          localeResolutionCallback: (locale, locales) {
            if (!languageSet) {
              model.changeLanguage(locale!.languageCode);
            }

            return locale;
          },
          localizationsDelegates: [
            SettingsLocalizationsDelegate(
              languageSet ? Locale(model.language!, '') : null
            ),
            const AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales:
              LanguageService.getCodes().map((code) => Locale(code, '')),
          theme: createTheme(context),
          home: const HomeScreen(),
          routes: {
            '/category': (context) => const CategoryDetailScreen(),
            '/game-play': (context) => const GamePlayScreen(),
            '/game-summary': (context) => const GameSummaryScreen(),
            '/game-gallery': (context) => const GameGalleryScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/tutorial': (context) => const TutorialScreen(),
            '/contributors': (context) => const ContributorsScreen(),
          },
        );
      },
    );
  }
}

void main() {
  runApp(App());
}
