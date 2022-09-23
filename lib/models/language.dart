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

import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ParleraLanguage {
  en("en"),
  cs("cs"),
  de("de"),
  fr("fr"),
  it("it"),
  tr("tr");

  static const defaultLang = en;
  final String langCode;

  const ParleraLanguage(this.langCode);

  static ParleraLanguage getLang(String langCode) {
    switch (langCode) {
      case "en":
        return en;
      case "cs":
        return cs;
      case "de":
        return de;
      case "fr":
        return fr;
      case "it":
        return it;
      case "tr":
        return tr;
      default:
        throw ArgumentError();
    }
  }

  Locale toLocale() => Locale(langCode);

  String randomName() {
    switch (this) {
      case en:
        return "Random";
      case cs:
        return "Náhodné";
      case de:
        return "Zufällig";
      case fr:
        return "Aléatoire";
      case it:
        return "Casuale";
      case tr:
        return "Rastgele";
      //     case id: return "Acak";
      // case nb: return "Tilfeldig";
      // case pl: return "Losowa";
      // case zh: return "随机";
    }
    throw ArgumentError();
  }

  String getLanguageName(BuildContext context) {
    switch (this) {
      case en:
        return AppLocalizations.of(context).languageEnglish;
      case cs:
        return AppLocalizations.of(context).languageCzech;
      case de:
        return AppLocalizations.of(context).languageGerman;
      case fr:
        return AppLocalizations.of(context).languageFrench;
      case it:
        return AppLocalizations.of(context).languageItalian;
      case tr:
        return AppLocalizations.of(context).languageTurkish;
    }
    throw ArgumentError();
  }
}
