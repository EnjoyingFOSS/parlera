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

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlera/helpers/url_util.dart';
import 'package:parlera/models/parlera_locale.dart';
import 'package:parlera/providers/setting_provider.dart';
import 'package:parlera/widgets/max_width_container.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    const languages = ParleraLocale.values;
    final infoColor = Theme.of(context).colorScheme.onSurface.withAlpha(162);

    final preferredLocale = ref.watch(settingProvider.select((v) => v.valueOrNull?.preferredLocale));

    return Scaffold(
      body: MaxWidthContainer(
          child: CustomScrollView(slivers: [
        SliverAppBar(
          title: Text(l10n.settingsLanguage),
        ),
        SliverList(
            delegate: SliverChildListDelegate.fixed(
                List.generate(languages.length + 1, (i) {
          final lang = i == 0 ? null : languages[i - 1];

          return RadioListTile<String?>(
              title: Text(lang != null
                  ? l10n.txtLanguageChoice(
                      lang.getLocaleCode(), lang.getLocaleName(context))
                  : l10n.languageSystem),
              value: lang?.getLocaleCode(),
              groupValue: preferredLocale?.getLocaleCode(),
              onChanged: (String? newLangCode) async {
                await ref.read(settingProvider.notifier).setPreferredLocale(
                    newLangCode == null
                        ? null
                        : ParleraLocale.fromLocaleCode(newLangCode));
              });
        }))),
        SliverList(
          delegate: SliverChildListDelegate.fixed([
            ListTile(
              title: Text(
                l10n.btnContributeLanguage,
              ),
              leading: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(Icons.add_rounded)),
              onTap: () async => await URLUtil.launchURL(
                  context, 'https://hosted.weblate.org/projects/parlera/'),
            ),
            Container(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(32),
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
                            l10n.languagesVaryNotice,
                            style: TextStyle(color: infoColor)))
                  ],
                )),
          ]),
        )
      ])),
    );
  }
}
