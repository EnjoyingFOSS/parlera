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

import 'dart:convert';
import 'dart:io';

import 'package:parlera/helpers/language.dart';
import 'package:parlera/models/category_type.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:path/path.dart' show join;
import 'package:sembast/sembast_io.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/category.dart';
import '../models/editable_category.dart';

class DBHelper {
  static const _dbFile = "parlera.db";
  static const _dbVersion = 1;

  static const _bundledSignifier = "_bundled";
  static const _customSignifier = "_custom";
  static const _questionStoreSuffix = "_qs";

  static const _randomNames = {
    "cs": "Náhodné",
    "de": "Zufällig",
    "en": "Random",
    "fr": "Aléatoire",
    "id": "Acak",
    "it": "Casuale",
    "nb": "Tilfeldig",
    "pl": "Losowa",
    "tr": "Rastgele",
    "zh": "随机"
  };

  DBHelper._();
  static final DBHelper db = DBHelper._();

  static Database? _database;

  Future<Database> get _instance async {
    _database ??= await _openDB();

    return _database!;
  }

  Future<Database> _openDB() async {
    String path = await _getPath();
    DatabaseFactory dbFactory = databaseFactoryIo;
    return await dbFactory.openDatabase(path, version: _dbVersion,
        onVersionChanged: (database, oldV, newV) async {
      // always delete old bundled categories and add new ones
      // todo can just bundle the resulting db files, maybe — though would that depend on the platform?

      for (final langCode in LanguageHelper.codes) {
        await stringMapStoreFactory
            .store(_getQStoreName(langCode, isBundled: true))
            .drop(database); //todo ok even if the store doesn't exist?
        final List jsonMapList = (json.decode(
            await rootBundle.loadString(_getBundledJsonPath(langCode))));

        // print(jsonMapList);
        final newMap = jsonMapList
            .map((dynamic map) => Map<String, Object?>.from(map))
            .toList();
        //     as List<Map<String, Object?>>;
        final newStore =
            intMapStoreFactory.store(_getQStoreName(langCode, isBundled: true));
        await newStore.addAll(database, newMap);
      }
    });
  }

  String _getBundledJsonPath(String langCode) =>
      "assets/data/categories_$langCode.json";

  String _getQStoreName(String langCode, {required bool isBundled}) =>
      langCode +
      (isBundled ? _bundledSignifier : _customSignifier) +
      _questionStoreSuffix;

  Future<String> _getPath() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, _dbFile);
  }

  Future<List<Category>> getAllCategories(String langCode) async {
    final database = await _instance;
    final bundledStore =
        intMapStoreFactory.store(_getQStoreName(langCode, isBundled: true));
    final customStore =
        intMapStoreFactory.store(_getQStoreName(langCode, isBundled: false));

    final bundledCatList = await bundledStore.find(database);
    final customCatList = await customStore.find(database);

    return List.generate(bundledCatList.length + customCatList.length + 1,
        (index) {
      if (index == bundledCatList.length + customCatList.length) {
        return Category.random(langCode, _randomNames[langCode]!);
      }

      final isBundled = index < bundledCatList.length;
      final catMapItem = isBundled
          ? bundledCatList[index]
          : customCatList[index - bundledCatList.length];
      return Category.fromJson(
          langCode,
          catMapItem.key,
          isBundled ? CategoryType.bundled : CategoryType.custom,
          catMapItem.value);
    });
  }

  Future addOrUpdateCustomCategory(EditableCategory ec) async {
    final database = await _instance;
    final customStore =
        intMapStoreFactory.store(_getQStoreName(ec.langCode, isBundled: false));
    final sembastPos = ec.sembastPos;
    if (sembastPos != null) {
      return await customStore.record(sembastPos).update(database, ec.toJson());
    } else {
      return await customStore.add(database, ec.toJson());
    }
  }

  Future<int?> deleteCustomCategory(String langCode, int id) async {
    final database = await _instance;
    final customStore =
        intMapStoreFactory.store(_getQStoreName(langCode, isBundled: false));
    return await customStore.record(id).delete(database);
  }
}
