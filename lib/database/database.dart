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

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:parlera/database/old_sembast_db.dart';
import 'package:parlera/enums/license.dart';
import 'package:parlera/models/full_deck_companion.dart';
import 'package:parlera/models/parlera_locale.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

class CardListConverter extends TypeConverter<List<String>, String> {
  static const _divider = "\n";

  const CardListConverter();

  @override
  List<String> fromSql(String fromDb) => fromDb.split(_divider);

  @override
  String toSql(List<String> value) => value.join(_divider);
}

class ColorConverter extends TypeConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromSql(int fromDb) => Color(fromDb);

  @override
  int toSql(Color value) => value.value;
}

@DataClassName("CardDeck")
class CardDeckTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get emoji => text().nullable()();
  IntColumn get color => integer().map(const ColorConverter())();
  TextColumn get localeCode => text()();
  IntColumn get mediumGameDurationS => integer().nullable()();
  TextColumn get author => text().nullable()();
  TextColumn get license =>
      textEnum<License>().withDefault(Constant(License.copyrighted.name))();
  DateTimeColumn get lastPlayed => dateTime().nullable()();
  BoolColumn get isBundled => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorited => boolean().withDefault(const Constant(false))();
}

@DataClassName("DeckContents")
class DeckContentTable extends Table {
  IntColumn get deck => integer().references(CardDeckTable, #id)();
  TextColumn get cards => text().map(const CardListConverter())();

  @override
  Set<Column>? get primaryKey => {deck};
}

@DriftDatabase(tables: [CardDeckTable, DeckContentTable])
class AppDatabase extends _$AppDatabase {
  // Named deliberately differently from the Sembast database
  static const String _dbFilename = "parlera_db.db";
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();

        await _createBundled([]);

        // ignore: deprecated_member_use_from_same_package
        if (File(await OldSembastDB.getPath()).existsSync()) {
          final sharedPrefs = await SharedPreferences.getInstance();

          for (final lang in ParleraLocale.values) {
            final favoriteIds = sharedPrefs.getStringList(
                'category_favorite_list_${lang.getLocaleCode()}');
            final customDecks =
                // ignore: deprecated_member_use_from_same_package
                await OldSembastDB.db.getCustomDecks(lang);
            for (final deck in customDecks) {
              await insertOrUpdateFullDeck(
                  deck.$1.deckCompanion.copyWith(
                    license: const Value(License.copyrighted),
                    isBundled: const Value(false),
                    isFavorited: Value(favoriteIds?.contains(deck.$2) ?? false),
                  ),
                  deck.$1.contentCompanion);
            }
          }
        }
      },
      // TODO test that this works with the next version!
      onUpgrade: (m, from, to) async {
        final favoriteBundled = await _queryFavoriteBundledDecks();
        await _deleteBundled();
        await _createBundled(favoriteBundled);
      },
    );
  }

  Future<void> _createBundled(List<CardDeck> favoritedBundledDecks) async {
    for (final lang in ParleraLocale.values) {
      final jsonPath = p.join(
        'assets',
        'data',
        'categories_${lang.getLocaleCode()}.json',
      );
      final List jsonMapList =
          (jsonDecode(await rootBundle.loadString(jsonPath)) as List<dynamic>);

      for (final map in jsonMapList) {
        final newCategory = FullDeckCompanion.fromJson(map, lang);
        final equivalentIndex = favoritedBundledDecks.indexWhere((cd) =>
            cd.localeCode == lang.getLocaleCode() &&
            cd.name == newCategory.deckCompanion.name.value);
        await insertOrUpdateFullDeck(
            newCategory.deckCompanion.copyWith(
              isBundled: const Value(true),
              isFavorited: Value(equivalentIndex > -1),
            ),
            newCategory.contentCompanion);
      }
    }
  }

  Future<void> _deleteBundled() async {
    final bundledDecks = await (select(cardDeckTable)
          ..where((cc) => cc.isBundled.equals(true)))
        .get();
    for (final bundledDeck in bundledDecks) {
      await (delete(deckContentTable)
            ..where((cd) => cd.deck.equals(bundledDeck.id)))
          .go();
      await delete(cardDeckTable).delete(bundledDeck);
    }
  }

  Future<List<CardDeck>> queryCardDecks(ParleraLocale locale) async =>
      await (select(cardDeckTable)
            ..where((cc) => cc.localeCode.equals(locale.getLocaleCode())))
          .get();

  Future<List<CardDeck>> _queryFavoriteBundledDecks() async =>
      await (select(cardDeckTable)
            ..where((cc) =>
                cc.isBundled.equals(true) & cc.isFavorited.equals(true)))
          .get();

  Future<DeckContents> queryDeckContent(int deckId) async =>
      await (select(deckContentTable)..where((cd) => cd.deck.equals(deckId)))
          .getSingle();

  Future<void> insertOrUpdateFullDeck(CardDeckTableCompanion deck,
      DeckContentTableCompanion deckContent) async {
    final newDeckRowId = await into(cardDeckTable).insertOnConflictUpdate(deck);

    final deckId = (await (select(cardDeckTable)
              ..where((cc) => cc.rowId.equals(newDeckRowId)))
            .getSingle())
        .id;

    await into(deckContentTable)
        .insertOnConflictUpdate(deckContent.copyWith(deck: Value(deckId)));
  }

  Future<void> updateDeck(CardDeck deck) async {
    await update(cardDeckTable).replace(deck);
  }

  Future<void> deleteDeck(CardDeck deck) async {
    await (delete(deckContentTable)..where((cd) => cd.deck.equals(deck.id)))
        .go();
    await delete(cardDeckTable).delete(deck);
  }

  static Future<File> _getDbFile() async => File(
      p.join((await getApplicationDocumentsDirectory()).path, _dbFilename));

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFile = await _getDbFile();

      if (Platform.isAndroid) {
        await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      }

      final cachebase = (await getTemporaryDirectory()).path;
      sqlite3.tempDirectory = cachebase;

      return NativeDatabase.createInBackground(dbFile);
    });
  }
}
