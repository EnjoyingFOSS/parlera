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

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parlera/helpers/url_launcher.dart';
import 'package:parlera/models/language.dart';
import 'package:parlera/store/language.dart';
import 'package:parlera/widgets/max_width_container.dart';
import 'package:scoped_model/scoped_model.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const languages = ParleraLanguage.values;
    final infoColor = Theme.of(context).colorScheme.onBackground.withAlpha(162);
    return Scaffold(
      body: ScopedModelDescendant<LanguageModel>(
          //TODO check whether I'm within safe area
          builder: (context, _, model) => MaxWidthContainer(
                  child: CustomScrollView(slivers: [
                SliverAppBar(
                  title: Text(AppLocalizations.of(context).settingsLanguage),
                ),
                SliverList(
                    delegate: SliverChildListDelegate.fixed(
                        List.generate(languages.length + 1, (i) {
                  final lang = i == 0 ? null : languages[i - 1];
                  return RadioListTile<String?>(
                      title: Text(lang?.getLanguageName(context) ??
                          AppLocalizations.of(context).languageSystem),
                      value: lang?.langCode,
                      groupValue: model.savedLang?.langCode,
                      onChanged: (String? newLangCode) async {
                        await model.saveLang(newLangCode == null
                            ? null
                            : ParleraLanguage.getLang(newLangCode));
                      });
                }))),
                SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context).btnContributeLanguage,
                      ),
                      leading: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(Icons.add_rounded)),
                      onTap: () => UrlLauncher.launchURL(context,
                          'https://hosted.weblate.org/projects/parlera/ui/'),
                    ),
                    Container(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withAlpha(32),
                      height: 1,
                      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: infoColor,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Flexible(
                                child: Text(
                                    AppLocalizations.of(context)
                                        .languagesVaryNotice,
                                    style: TextStyle(color: infoColor)))
                          ],
                        )),
                  ]),
                )
              ]))),
    );
  }
}
