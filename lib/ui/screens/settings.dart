import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:package_info/package_info.dart';

import 'package:parlera/localizations.dart';

import 'package:parlera/services/language.dart';
import 'package:parlera/store/settings.dart';
import 'package:parlera/store/language.dart';
import '../shared/widgets.dart';
import 'package:parlera/ui/templates/screen.dart';

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

  // void logChange(String field, dynamic value) {
  //   AnalyticsService.logEvent(field, {"value": value});
  // }

  Widget buildContent(context) {
    return Container(
      child: ScopedModelDescendant<SettingsModel>(
        builder: (context, child, model) {
          return ListView(
            children: [
              SwitchListTile(
                title: Text(AppLocalizations.of(context).settingsCamera),
                subtitle: Text(AppLocalizations.of(context).settingsCameraHint),
                value: model.isCameraEnabled!,
                onChanged: (bool value) async {
                  if (value && !await requestCameraPermissions()) {
                    return;
                  }

                  // logChange('settings_camera', value);
                  model.toggleCamera();
                },
                secondary: Icon(Icons.camera_alt),
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context).settingsAccelerometer),
                subtitle: Text(
                    AppLocalizations.of(context).settingsAccelerometerHint),
                value: model.isRotationControlEnabled!,
                onChanged: (bool value) {
                  // logChange('settings_accelerometer', value);
                  model.toggleRotationControl();
                },
                secondary: Icon(Icons.screen_rotation),
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context).settingsAudio),
                value: model.isAudioEnabled!,
                onChanged: (bool value) {
                  // logChange('settings_audio', value);
                  model.toggleAudio();
                },
                secondary: Icon(Icons.music_note),
              ),
              ScopedModelDescendant<LanguageModel>(
                builder: (context, child, model) {
                  return ListTile(
                      title:
                          Text(AppLocalizations.of(context).settingsLanguage),
                      leading: Icon(Icons.flag),
                      trailing: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: model.language,
                          items: LanguageService.getCodes()
                              .map(
                                (code) => DropdownMenuItem(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: FlagImage(country: code),
                                      ),
                                      Text(code.toUpperCase()),
                                    ],
                                  ),
                                  value: code,
                                ),
                              )
                              .toList(),
                          onChanged: (String? language) {
                            // logChange('settings_language', language);
                            model.changeLanguage(language);
                          },
                        ),
                      ));
                },
              ),
              ListTile(
                leading: Icon(Icons.open_in_browser),
                title: Text(AppLocalizations.of(context).settingsPrivacyPolicy),
                onTap: openPrivacyPolicy,
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text(AppLocalizations.of(context).settingsStartTutorial),
                onTap: () => openTutorial(context),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: buildContent(context),
            ),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GestureDetector(
                    onTap: () => openCredits(context),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('v ${snapshot.data!.version}'),
                    ),
                  );
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  openTutorial(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/tutorial',
    );
  }

  openCredits(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/contributors',
    );
  }

  openPrivacyPolicy() async {
    const url = SettingsModel.privacyPolicyUrl;
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
