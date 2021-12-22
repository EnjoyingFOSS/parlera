import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parlera/helpers/language.dart';
import 'package:parlera/store/settings.dart';
import 'package:parlera/store/language.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Future<bool> requestCameraPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
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
                  subtitle:
                      Text(AppLocalizations.of(context).settingsCameraHint),
                  value: model.isCameraEnabled!,
                  onChanged: (bool value) async {
                    if (value && !await requestCameraPermissions()) {
                      return;
                    }

                    // logChange('settings_camera', value);
                    model.toggleCamera();
                  },
                  secondary: const Icon(Icons.camera_alt),
                ),
              if (Platform.isIOS || Platform.isAndroid)
                SwitchListTile(
                  title:
                      Text(AppLocalizations.of(context).settingsAccelerometer),
                  subtitle: Text(
                      AppLocalizations.of(context).settingsAccelerometerHint),
                  value: model.isRotationControlEnabled!,
                  onChanged: (bool value) {
                    // logChange('settings_accelerometer', value);
                    model.toggleRotationControl();
                  },
                  secondary: const Icon(Icons.screen_rotation),
                ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context).settingsAudio),
                value: model.isAudioEnabled!,
                onChanged: (bool value) {
                  // logChange('settings_audio', value);
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
        applicationName: packageInfo.appName,
        applicationVersion: packageInfo.version);
  }
}
