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

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:parlera/models/category.dart';
import 'package:parlera/models/category_type.dart';
import 'package:parlera/models/editable_category.dart';
import 'package:parlera/models/language.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:xdg_directories/xdg_directories.dart';

/// No longer used Sembast DB (last used in v4.0.1 = 15), used here for migrating to new database
@Deprecated("Use AppDatabase instead")
class OldSembastDB {
  static const _dbFile = "parlera.db";
  static const _dbVersion = 3;

  static const _bundledSignifier = "_bundled";
  static const _customSignifier = "_custom";
  static const _cardStoreSuffix = "_qs";

  OldSembastDB._();
  static final OldSembastDB db = OldSembastDB._();

  static Database? _database;

  Future<Database> get _instance async {
    _database ??= await _openDB();

    return _database!;
  }

  Future<Database> _openDB() async {
    final path = await getPath();
    final dbFactory = databaseFactoryIo;
    return await dbFactory.openDatabase(path, version: _dbVersion,
        onVersionChanged: (database, oldV, newV) async {
      // always delete old bundled categories and add new ones
      // todo can just bundle the resulting db files, maybe — though would that depend on the platform?

      for (final lang in ParleraLanguage.values) {
        await stringMapStoreFactory
            .store(_getQStoreName(lang, isBundled: true))
            .drop(database);
        final List jsonMapList =
            (json.decode(await rootBundle.loadString(_getBundledJsonPath(lang)))
                as List<dynamic>);

        final newMap = jsonMapList
            .map((dynamic map) =>
                Map<String, Object?>.from(map as Map<dynamic, dynamic>))
            .toList();

        final newStore =
            intMapStoreFactory.store(_getQStoreName(lang, isBundled: true));
        await newStore.addAll(database, newMap);
      }
    });
  }

  String _getBundledJsonPath(ParleraLanguage lang) =>
      "assets/data/categories_${lang.getLocaleCode()}.json";

  String _getQStoreName(ParleraLanguage lang, {required bool isBundled}) =>
      lang.getLocaleCode() +
      (isBundled ? _bundledSignifier : _customSignifier) +
      _cardStoreSuffix;

  static Future<String> getPath() async {
    final documentsDirectory = (Platform.isLinux)
        ? Directory(dataHome.path)
        : await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, _dbFile);
  }

  Future<List<Category>> getCustomCategories(ParleraLanguage lang) async {
    final database = await _instance;
    final customStore =
        intMapStoreFactory.store(_getQStoreName(lang, isBundled: false));

    final customCatList = await customStore.find(database);

    return customCatList
        .map(
            (c) => Category.fromJson(lang, c.key, CategoryType.custom, c.value))
        .toList(growable: false);
  }
}
