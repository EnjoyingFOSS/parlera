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

import 'package:flutter/foundation.dart' as flutter_foundation;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:parlera/helpers/url_launcher.dart';
import 'package:parlera/screens/languages/languages.dart';
import 'package:parlera/screens/settings/widgets/cards_per_game_dialog.dart';
import 'package:parlera/store/settings.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SettingsModel>(
        builder: (context, _, model) => SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  if (!flutter_foundation.kIsWeb &&
                      (Platform.isIOS || Platform.isAndroid))
                    SwitchListTile(
                      title: Text(
                          AppLocalizations.of(context).settingsAccelerometer),
                      value: model.isRotationControlEnabled,
                      onChanged: (bool value) async {
                        await model.toggleRotationControl();
                      },
                      secondary: const Icon(Icons.screen_rotation_rounded),
                    ),
                  SwitchListTile(
                    title: Text(AppLocalizations.of(context).settingsAudio),
                    value: model.isAudioEnabled,
                    onChanged: (bool value) async {
                      await model.toggleAudio();
                    },
                    secondary: const Icon(Icons.music_note_rounded),
                  ),
                  ListTile(
                    title: Text(AppLocalizations.of(context).txtCardsPerGame),
                    leading: const Icon(Icons.style_rounded),
                    trailing: Text(
                      model.cardsPerGame?.toString() ??
                          AppLocalizations.of(context).txtUnlimitedCards,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () async {
                      final cardsPerGame = await CardsPerGameDialog.show(
                          context, model.cardsPerGame);
                      await model.setCardsPerGame(cardsPerGame);
                    },
                  ),
                  ListTile(
                    title: Text(AppLocalizations.of(context).settingsLanguage),
                    leading: const Icon(Icons.language_rounded),
                    onTap: () async => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (context) => const LanguageScreen())),
                  ),
                  ListTile(
                    leading: const Icon(Icons.help_rounded),
                    title: Text(
                        AppLocalizations.of(context).settingsStartTutorial),
                    onTap: () async => _openTutorial(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.volunteer_activism_rounded),
                    title: Text(AppLocalizations.of(context).contribute),
                    onTap: () => UrlLauncher.launchURL(context,
                        "https://gitlab.com/enjoyingfoss/parlera/-/blob/master/README.md#contribute"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.attach_money_rounded),
                    title: Text(AppLocalizations.of(context).donate),
                    onTap: () => UrlLauncher.launchURL(
                        context, "https://en.liberapay.com/Parlera/"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_rounded),
                    title: Text(AppLocalizations.of(context).aboutParlera),
                    onTap: () => _showAboutDialog(context),
                  ),
                ],
              ),
            ));
  }

  Future<void> _openTutorial(BuildContext context) async =>
      await Navigator.pushNamed(
        context,
        '/tutorial',
      );

  void _showAboutDialog(BuildContext context) async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (context.mounted) {
      showAboutDialog(
          context: context,
          applicationIcon: const SizedBox(
            width: 48,
            height: 48,
            child: Image(
              image: AssetImage('assets/images/icon_generic.webp'),
            ),
          ),
          applicationName: packageInfo.appName,
          applicationVersion: packageInfo.version);
    }
  }
}
