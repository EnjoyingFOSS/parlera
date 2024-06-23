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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_esperanto/l10n_esperanto.dart';
import 'package:parlera/helpers/theme.dart';
import 'package:parlera/models/parlera_locale.dart';
import 'package:parlera/providers/setting_provider.dart';
import 'package:parlera/screens/game_cover/game_cover.dart';
import 'package:parlera/screens/game_player/game_player.dart';
import 'package:parlera/screens/game_results/game_results.dart';
import 'package:parlera/screens/home/home.dart';
import 'package:parlera/screens/main_redirect/main_redirect.dart';
import 'package:parlera/screens/tutorial/tutorial.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Parlera extends StatelessWidget {
  const Parlera({super.key});

  Future<SharedPreferences> initAndGetPreferences() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    return await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      // ignore: discarded_futures
      future: initAndGetPreferences(),
      builder: (
        BuildContext context,
        AsyncSnapshot<SharedPreferences> snapshot,
      ) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        return const ParleraApp();
      },
    );
  }
}

class ParleraApp extends ConsumerWidget {
  const ParleraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferredLocale = ref.watch(
      settingProvider.select((v) => v.valueOrNull?.preferredLocale),
    );

    return MaterialApp(
      title: 'Parlera',
      // debugShowCheckedModeBanner: false, // used for screenshots
      locale: preferredLocale?.toLocale(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        MaterialLocalizationsEo.delegate,
        CupertinoLocalizationsEo.delegate,
        LocaleNamesLocalizationsDelegate()
      ],
      supportedLocales: ParleraLocale.supportedLocales,
      theme: ThemeHelper.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainRedirectScreen(),
        '/home': (context) => const HomeScreen(),
        '/game-cover': (context) => const GameCoverScreen(),
        '/game-play': (context) => const GamePlayerScreen(),
        '/game-summary': (context) => const GameResultsScreen(),
        '/tutorial': (context) => const TutorialScreen(),
      },
    );
  }
}

void main() {
  runApp(const ProviderScope(child: Parlera()));
}
