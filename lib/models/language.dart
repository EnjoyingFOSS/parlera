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

import 'package:flutter/widgets.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

enum ParleraLanguage {
  en("en", "Random"),
  bg("bg", "Случайна"),
  cs("cs", "Náhodné"),
  de("de", "Zufällig"),
  eo("eo", "Hazarde"),
  es("es", "Aleatorio"),
  fr("fr", "Aléatoire"),
  hu("hu", "Random"),
  it("it", "Casuale"),
  nl("nl", "Willekeurig"),
  pa("pa", "ਬੇਤਰਤੀਬ"),
  pl("pl", "Losowa"),
  pt("pt", "Aleatório"),
  ptBr("pt", "Aleatório", countryCode: "BR"),
  ru("ru", "Случайно"),
  tr("tr", "Rastgele"),
  uk("uk", "Випадково"),
  vi("vi", "Ngẫu nhiên"),
  zh("zh", "随机");

  static const defaultLang = en;
  final String _langCode;
  final String? _countryCode;
  final String randomName;

  const ParleraLanguage(this._langCode, this.randomName, {String? countryCode})
      : _countryCode = countryCode;

  static ParleraLanguage fromLocale(Locale locale) =>
      fromLocaleCode("${locale.languageCode}_${locale.countryCode}");

  static ParleraLanguage fromLocaleCode(String localeCode) {
    final localeCodeSplit = splitLocaleCode(localeCode);
    final languageCode = localeCodeSplit.first;
    final countryCode = localeCodeSplit.length > 1 ? localeCodeSplit[1] : null;
    if (countryCode == "BR" && languageCode == "pt") {
      return ptBr;
    } else {
      switch (languageCode) {
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
        case "nl":
          return nl;
        case "pa":
          return pa;
        case "pl":
          return pl;
        case "pt":
          return pt;
        case "ru":
          return ru;
        case "tr":
          return tr;
        case "uk":
          return uk;
        case "vi":
          return vi;
        case "zh":
          return zh;
        default:
          throw ArgumentError();
      }
    }
  }

  String getLocaleCode() =>
      _countryCode != null ? "${_langCode}_$_countryCode" : _langCode;

  static List<String> splitLocaleCode(String localeCode) =>
      localeCode.split("_");

  Locale toLocale() => Locale(_langCode, _countryCode);

  String getLanguageName(BuildContext context) {
    final localeCode = getLocaleCode();
    return LocaleNames.of(context)!.nameOf(localeCode) ?? localeCode;
  }
}
