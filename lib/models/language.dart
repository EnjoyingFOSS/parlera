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
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

enum ParleraLanguage {
  en("en"),
  bg("bg"),
  cs("cs"),
  de("de"),
  eo("eo"),
  es("es"),
  fr("fr"),
  hu("hu"),
  it("it"),
  pl("pl"),
  ru("ru"),
  tr("tr"),
  uk("uk"),
  zh("zh");

  static const defaultLang = en;
  final String langCode;

  const ParleraLanguage(this.langCode);

  static ParleraLanguage getLang(String langCode) {
    switch (langCode) {
      case "en":
        return en;
      case "bg":
        return bg;
      case "cs":
        return cs;
      case "de":
        return de;
      case "eo":
        return eo;
      case "es":
        return es;
      case "fr":
        return fr;
      case "hu":
        return hu;
      case "it":
        return it;
      case "pl":
        return pl;
      case "ru":
        return ru;
      case "tr":
        return tr;
      case "uk":
        return uk;
      case "zh":
        return zh;
      default:
        throw ArgumentError();
    }
  }

  Locale toLocale() => Locale(langCode);

  String randomName() {
    switch (this) {
      case en:
        return "Random";
      case bg:
        return "Случайна";
      case cs:
        return "Náhodné";
      case de:
        return "Zufällig";
      case es:
        return "Aleatorio";
      case eo:
        return "Hazarde";
      case fr:
        return "Aléatoire";
      case hu:
        return "Random";
      case it:
        return "Casuale";
      case pl:
        return "Losowa";
      case ru:
        return "Случайно";
      case tr:
        return "Rastgele";
      case uk:
        return "Випадково";
      case zh:
        return "随机";
    }
    throw ArgumentError();
  }

  String getLanguageName(BuildContext context) =>
      LocaleNames.of(context)!.nameOf(langCode) ?? langCode;
}
