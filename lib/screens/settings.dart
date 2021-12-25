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
import 'package:package_info_plus/package_info_plus.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parlera/helpers/language.dart';
import 'package:parlera/store/settings.dart';
import 'package:parlera/store/language.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Future<bool> requestCameraPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    var res = true;
    for (var status in statuses.values) {
      if (status != PermissionStatus.granted) {
        res = false;
      }
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScopedModelDescendant<SettingsModel>(
        builder: (context, child, model) {
          return ListView(
            padding: const EdgeInsets.all(8),
            children: [
              if (Platform.isIOS || Platform.isAndroid)
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).settingsCamera),
                  value: model.isCameraEnabled!,
                  onChanged: (bool value) async {
                    if (value && !await requestCameraPermissions()) {
                      return;
                    }
                    model.toggleCamera();
                  },
                  secondary: const Icon(Icons.camera_alt),
                ),
              if (Platform.isIOS || Platform.isAndroid)
                SwitchListTile(
                  title:
                      Text(AppLocalizations.of(context).settingsAccelerometer),
                  value: model.isRotationControlEnabled!,
                  onChanged: (bool value) {
                    model.toggleRotationControl();
                  },
                  secondary: const Icon(Icons.screen_rotation),
                ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context).settingsAudio),
                value: model.isAudioEnabled!,
                onChanged: (bool value) {
                  model.toggleAudio();
                },
                secondary: const Icon(Icons.music_note),
              ),
              ScopedModelDescendant<LanguageModel>(
                builder: (context, child, model) {
                  return ListTile(
                      title:
                          Text(AppLocalizations.of(context).settingsLanguage),
                      leading: const Icon(Icons.language),
                      trailing: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: model.language,
                          items: LanguageHelper.getCodes()
                              .map(
                                (code) => DropdownMenuItem(
                                  child: Text(code.toUpperCase()),
                                  value: code,
                                ),
                              )
                              .toList(),
                          onChanged: (String? language) {
                            // logChange('settings_language', language);
                            model.changeLanguage(
                                language); //todo make it change global language too
                          },
                        ),
                      ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: Text(AppLocalizations.of(context).settingsStartTutorial),
                onTap: () => openTutorial(context),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: Text(AppLocalizations.of(context).about),
                onTap: () => _showAboutDialog(context),
              ),
            ],
          );
        },
      ),
    );
  }

  openTutorial(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/tutorial',
    );
  }

  void _showAboutDialog(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    showAboutDialog(
        context: context,
        applicationIcon: const SizedBox(
          width: 48,
          height: 48,
          child: Image(
            image: AssetImage('assets/images/icon_generic.png'),
          ),
        ),
        applicationName: packageInfo.appName,
        applicationVersion: packageInfo.version);
  }
}
