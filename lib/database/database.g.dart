// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CardDeckTableTable extends CardDeckTable
    with TableInfo<$CardDeckTableTable, CardDeck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardDeckTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumnWithTypeConverter<Color, int> color =
      GeneratedColumn<int>('color', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<Color>($CardDeckTableTable.$convertercolor);
  static const VerificationMeta _localeCodeMeta =
      const VerificationMeta('localeCode');
  @override
  late final GeneratedColumn<String> localeCode = GeneratedColumn<String>(
      'locale_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mediumGameDurationSMeta =
      const VerificationMeta('mediumGameDurationS');
  @override
  late final GeneratedColumn<int> mediumGameDurationS = GeneratedColumn<int>(
      'medium_game_duration_s', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _licenseMeta =
      const VerificationMeta('license');
  @override
  late final GeneratedColumnWithTypeConverter<License, String> license =
      GeneratedColumn<String>('license', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(License.copyrighted.name))
          .withConverter<License>($CardDeckTableTable.$converterlicense);
  static const VerificationMeta _lastPlayedMeta =
      const VerificationMeta('lastPlayed');
  @override
  late final GeneratedColumn<DateTime> lastPlayed = GeneratedColumn<DateTime>(
      'last_played', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isBundledMeta =
      const VerificationMeta('isBundled');
  @override
  late final GeneratedColumn<bool> isBundled = GeneratedColumn<bool>(
      'is_bundled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_bundled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isFavoritedMeta =
      const VerificationMeta('isFavorited');
  @override
  late final GeneratedColumn<bool> isFavorited = GeneratedColumn<bool>(
      'is_favorited', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_favorited" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        emoji,
        color,
        localeCode,
        mediumGameDurationS,
        author,
        license,
        lastPlayed,
        isBundled,
        isFavorited
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_deck_table';
  @override
  VerificationContext validateIntegrity(Insertable<CardDeck> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
          _emojiMeta, emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta));
    }
    context.handle(_colorMeta, const VerificationResult.success());
    if (data.containsKey('locale_code')) {
      context.handle(
          _localeCodeMeta,
          localeCode.isAcceptableOrUnknown(
              data['locale_code']!, _localeCodeMeta));
    } else if (isInserting) {
      context.missing(_localeCodeMeta);
    }
    if (data.containsKey('medium_game_duration_s')) {
      context.handle(
          _mediumGameDurationSMeta,
          mediumGameDurationS.isAcceptableOrUnknown(
              data['medium_game_duration_s']!, _mediumGameDurationSMeta));
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    }
    context.handle(_licenseMeta, const VerificationResult.success());
    if (data.containsKey('last_played')) {
      context.handle(
          _lastPlayedMeta,
          lastPlayed.isAcceptableOrUnknown(
              data['last_played']!, _lastPlayedMeta));
    }
    if (data.containsKey('is_bundled')) {
      context.handle(_isBundledMeta,
          isBundled.isAcceptableOrUnknown(data['is_bundled']!, _isBundledMeta));
    }
    if (data.containsKey('is_favorited')) {
      context.handle(
          _isFavoritedMeta,
          isFavorited.isAcceptableOrUnknown(
              data['is_favorited']!, _isFavoritedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardDeck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardDeck(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji']),
      color: $CardDeckTableTable.$convertercolor.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!),
      localeCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}locale_code'])!,
      mediumGameDurationS: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}medium_game_duration_s']),
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author']),
      license: $CardDeckTableTable.$converterlicense.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}license'])!),
      lastPlayed: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_played']),
      isBundled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_bundled'])!,
      isFavorited: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorited'])!,
    );
  }

  @override
  $CardDeckTableTable createAlias(String alias) {
    return $CardDeckTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Color, int> $convertercolor = const ColorConverter();
  static JsonTypeConverter2<License, String, String> $converterlicense =
      const EnumNameConverter<License>(License.values);
}

class CardDeck extends DataClass implements Insertable<CardDeck> {
  final int id;
  final String name;
  final String? emoji;
  final Color color;
  final String localeCode;
  final int? mediumGameDurationS;
  final String? author;
  final License license;
  final DateTime? lastPlayed;
  final bool isBundled;
  final bool isFavorited;
  const CardDeck(
      {required this.id,
      required this.name,
      this.emoji,
      required this.color,
      required this.localeCode,
      this.mediumGameDurationS,
      this.author,
      required this.license,
      this.lastPlayed,
      required this.isBundled,
      required this.isFavorited});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || emoji != null) {
      map['emoji'] = Variable<String>(emoji);
    }
    {
      map['color'] =
          Variable<int>($CardDeckTableTable.$convertercolor.toSql(color));
    }
    map['locale_code'] = Variable<String>(localeCode);
    if (!nullToAbsent || mediumGameDurationS != null) {
      map['medium_game_duration_s'] = Variable<int>(mediumGameDurationS);
    }
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    {
      map['license'] = Variable<String>(
          $CardDeckTableTable.$converterlicense.toSql(license));
    }
    if (!nullToAbsent || lastPlayed != null) {
      map['last_played'] = Variable<DateTime>(lastPlayed);
    }
    map['is_bundled'] = Variable<bool>(isBundled);
    map['is_favorited'] = Variable<bool>(isFavorited);
    return map;
  }

  CardDeckTableCompanion toCompanion(bool nullToAbsent) {
    return CardDeckTableCompanion(
      id: Value(id),
      name: Value(name),
      emoji:
          emoji == null && nullToAbsent ? const Value.absent() : Value(emoji),
      color: Value(color),
      localeCode: Value(localeCode),
      mediumGameDurationS: mediumGameDurationS == null && nullToAbsent
          ? const Value.absent()
          : Value(mediumGameDurationS),
      author:
          author == null && nullToAbsent ? const Value.absent() : Value(author),
      license: Value(license),
      lastPlayed: lastPlayed == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPlayed),
      isBundled: Value(isBundled),
      isFavorited: Value(isFavorited),
    );
  }

  factory CardDeck.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardDeck(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      emoji: serializer.fromJson<String?>(json['emoji']),
      color: serializer.fromJson<Color>(json['color']),
      localeCode: serializer.fromJson<String>(json['localeCode']),
      mediumGameDurationS:
          serializer.fromJson<int?>(json['mediumGameDurationS']),
      author: serializer.fromJson<String?>(json['author']),
      license: $CardDeckTableTable.$converterlicense
          .fromJson(serializer.fromJson<String>(json['license'])),
      lastPlayed: serializer.fromJson<DateTime?>(json['lastPlayed']),
      isBundled: serializer.fromJson<bool>(json['isBundled']),
      isFavorited: serializer.fromJson<bool>(json['isFavorited']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'emoji': serializer.toJson<String?>(emoji),
      'color': serializer.toJson<Color>(color),
      'localeCode': serializer.toJson<String>(localeCode),
      'mediumGameDurationS': serializer.toJson<int?>(mediumGameDurationS),
      'author': serializer.toJson<String?>(author),
      'license': serializer.toJson<String>(
          $CardDeckTableTable.$converterlicense.toJson(license)),
      'lastPlayed': serializer.toJson<DateTime?>(lastPlayed),
      'isBundled': serializer.toJson<bool>(isBundled),
      'isFavorited': serializer.toJson<bool>(isFavorited),
    };
  }

  CardDeck copyWith(
          {int? id,
          String? name,
          Value<String?> emoji = const Value.absent(),
          Color? color,
          String? localeCode,
          Value<int?> mediumGameDurationS = const Value.absent(),
          Value<String?> author = const Value.absent(),
          License? license,
          Value<DateTime?> lastPlayed = const Value.absent(),
          bool? isBundled,
          bool? isFavorited}) =>
      CardDeck(
        id: id ?? this.id,
        name: name ?? this.name,
        emoji: emoji.present ? emoji.value : this.emoji,
        color: color ?? this.color,
        localeCode: localeCode ?? this.localeCode,
        mediumGameDurationS: mediumGameDurationS.present
            ? mediumGameDurationS.value
            : this.mediumGameDurationS,
        author: author.present ? author.value : this.author,
        license: license ?? this.license,
        lastPlayed: lastPlayed.present ? lastPlayed.value : this.lastPlayed,
        isBundled: isBundled ?? this.isBundled,
        isFavorited: isFavorited ?? this.isFavorited,
      );
  @override
  String toString() {
    return (StringBuffer('CardDeck(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('emoji: $emoji, ')
          ..write('color: $color, ')
          ..write('localeCode: $localeCode, ')
          ..write('mediumGameDurationS: $mediumGameDurationS, ')
          ..write('author: $author, ')
          ..write('license: $license, ')
          ..write('lastPlayed: $lastPlayed, ')
          ..write('isBundled: $isBundled, ')
          ..write('isFavorited: $isFavorited')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, emoji, color, localeCode,
      mediumGameDurationS, author, license, lastPlayed, isBundled, isFavorited);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardDeck &&
          other.id == this.id &&
          other.name == this.name &&
          other.emoji == this.emoji &&
          other.color == this.color &&
          other.localeCode == this.localeCode &&
          other.mediumGameDurationS == this.mediumGameDurationS &&
          other.author == this.author &&
          other.license == this.license &&
          other.lastPlayed == this.lastPlayed &&
          other.isBundled == this.isBundled &&
          other.isFavorited == this.isFavorited);
}

class CardDeckTableCompanion extends UpdateCompanion<CardDeck> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> emoji;
  final Value<Color> color;
  final Value<String> localeCode;
  final Value<int?> mediumGameDurationS;
  final Value<String?> author;
  final Value<License> license;
  final Value<DateTime?> lastPlayed;
  final Value<bool> isBundled;
  final Value<bool> isFavorited;
  const CardDeckTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.emoji = const Value.absent(),
    this.color = const Value.absent(),
    this.localeCode = const Value.absent(),
    this.mediumGameDurationS = const Value.absent(),
    this.author = const Value.absent(),
    this.license = const Value.absent(),
    this.lastPlayed = const Value.absent(),
    this.isBundled = const Value.absent(),
    this.isFavorited = const Value.absent(),
  });
  CardDeckTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.emoji = const Value.absent(),
    required Color color,
    required String localeCode,
    this.mediumGameDurationS = const Value.absent(),
    this.author = const Value.absent(),
    this.license = const Value.absent(),
    this.lastPlayed = const Value.absent(),
    this.isBundled = const Value.absent(),
    this.isFavorited = const Value.absent(),
  })  : name = Value(name),
        color = Value(color),
        localeCode = Value(localeCode);
  static Insertable<CardDeck> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? emoji,
    Expression<int>? color,
    Expression<String>? localeCode,
    Expression<int>? mediumGameDurationS,
    Expression<String>? author,
    Expression<String>? license,
    Expression<DateTime>? lastPlayed,
    Expression<bool>? isBundled,
    Expression<bool>? isFavorited,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (emoji != null) 'emoji': emoji,
      if (color != null) 'color': color,
      if (localeCode != null) 'locale_code': localeCode,
      if (mediumGameDurationS != null)
        'medium_game_duration_s': mediumGameDurationS,
      if (author != null) 'author': author,
      if (license != null) 'license': license,
      if (lastPlayed != null) 'last_played': lastPlayed,
      if (isBundled != null) 'is_bundled': isBundled,
      if (isFavorited != null) 'is_favorited': isFavorited,
    });
  }

  CardDeckTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? emoji,
      Value<Color>? color,
      Value<String>? localeCode,
      Value<int?>? mediumGameDurationS,
      Value<String?>? author,
      Value<License>? license,
      Value<DateTime?>? lastPlayed,
      Value<bool>? isBundled,
      Value<bool>? isFavorited}) {
    return CardDeckTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      localeCode: localeCode ?? this.localeCode,
      mediumGameDurationS: mediumGameDurationS ?? this.mediumGameDurationS,
      author: author ?? this.author,
      license: license ?? this.license,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      isBundled: isBundled ?? this.isBundled,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (color.present) {
      map['color'] =
          Variable<int>($CardDeckTableTable.$convertercolor.toSql(color.value));
    }
    if (localeCode.present) {
      map['locale_code'] = Variable<String>(localeCode.value);
    }
    if (mediumGameDurationS.present) {
      map['medium_game_duration_s'] = Variable<int>(mediumGameDurationS.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (license.present) {
      map['license'] = Variable<String>(
          $CardDeckTableTable.$converterlicense.toSql(license.value));
    }
    if (lastPlayed.present) {
      map['last_played'] = Variable<DateTime>(lastPlayed.value);
    }
    if (isBundled.present) {
      map['is_bundled'] = Variable<bool>(isBundled.value);
    }
    if (isFavorited.present) {
      map['is_favorited'] = Variable<bool>(isFavorited.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardDeckTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('emoji: $emoji, ')
          ..write('color: $color, ')
          ..write('localeCode: $localeCode, ')
          ..write('mediumGameDurationS: $mediumGameDurationS, ')
          ..write('author: $author, ')
          ..write('license: $license, ')
          ..write('lastPlayed: $lastPlayed, ')
          ..write('isBundled: $isBundled, ')
          ..write('isFavorited: $isFavorited')
          ..write(')'))
        .toString();
  }
}

class $DeckContentTableTable extends DeckContentTable
    with TableInfo<$DeckContentTableTable, DeckContents> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeckContentTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deckMeta = const VerificationMeta('deck');
  @override
  late final GeneratedColumn<int> deck = GeneratedColumn<int>(
      'deck', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES card_deck_table (id)'));
  static const VerificationMeta _cardsMeta = const VerificationMeta('cards');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> cards =
      GeneratedColumn<String>('cards', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($DeckContentTableTable.$convertercards);
  @override
  List<GeneratedColumn> get $columns => [deck, cards];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deck_content_table';
  @override
  VerificationContext validateIntegrity(Insertable<DeckContents> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('deck')) {
      context.handle(
          _deckMeta, deck.isAcceptableOrUnknown(data['deck']!, _deckMeta));
    }
    context.handle(_cardsMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deck};
  @override
  DeckContents map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeckContents(
      deck: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deck'])!,
      cards: $DeckContentTableTable.$convertercards.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cards'])!),
    );
  }

  @override
  $DeckContentTableTable createAlias(String alias) {
    return $DeckContentTableTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertercards =
      const CardListConverter();
}

class DeckContents extends DataClass implements Insertable<DeckContents> {
  final int deck;
  final List<String> cards;
  const DeckContents({required this.deck, required this.cards});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['deck'] = Variable<int>(deck);
    {
      map['cards'] =
          Variable<String>($DeckContentTableTable.$convertercards.toSql(cards));
    }
    return map;
  }

  DeckContentTableCompanion toCompanion(bool nullToAbsent) {
    return DeckContentTableCompanion(
      deck: Value(deck),
      cards: Value(cards),
    );
  }

  factory DeckContents.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeckContents(
      deck: serializer.fromJson<int>(json['deck']),
      cards: serializer.fromJson<List<String>>(json['cards']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deck': serializer.toJson<int>(deck),
      'cards': serializer.toJson<List<String>>(cards),
    };
  }

  DeckContents copyWith({int? deck, List<String>? cards}) => DeckContents(
        deck: deck ?? this.deck,
        cards: cards ?? this.cards,
      );
  @override
  String toString() {
    return (StringBuffer('DeckContents(')
          ..write('deck: $deck, ')
          ..write('cards: $cards')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(deck, cards);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeckContents &&
          other.deck == this.deck &&
          other.cards == this.cards);
}

class DeckContentTableCompanion extends UpdateCompanion<DeckContents> {
  final Value<int> deck;
  final Value<List<String>> cards;
  const DeckContentTableCompanion({
    this.deck = const Value.absent(),
    this.cards = const Value.absent(),
  });
  DeckContentTableCompanion.insert({
    this.deck = const Value.absent(),
    required List<String> cards,
  }) : cards = Value(cards);
  static Insertable<DeckContents> custom({
    Expression<int>? deck,
    Expression<String>? cards,
  }) {
    return RawValuesInsertable({
      if (deck != null) 'deck': deck,
      if (cards != null) 'cards': cards,
    });
  }

  DeckContentTableCompanion copyWith(
      {Value<int>? deck, Value<List<String>>? cards}) {
    return DeckContentTableCompanion(
      deck: deck ?? this.deck,
      cards: cards ?? this.cards,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deck.present) {
      map['deck'] = Variable<int>(deck.value);
    }
    if (cards.present) {
      map['cards'] = Variable<String>(
          $DeckContentTableTable.$convertercards.toSql(cards.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeckContentTableCompanion(')
          ..write('deck: $deck, ')
          ..write('cards: $cards')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabaseManager get managers => _$AppDatabaseManager(this);
  late final $CardDeckTableTable cardDeckTable = $CardDeckTableTable(this);
  late final $DeckContentTableTable deckContentTable =
      $DeckContentTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [cardDeckTable, deckContentTable];
}

typedef $$CardDeckTableTableInsertCompanionBuilder = CardDeckTableCompanion
    Function({
  Value<int> id,
  required String name,
  Value<String?> emoji,
  required Color color,
  required String localeCode,
  Value<int?> mediumGameDurationS,
  Value<String?> author,
  Value<License> license,
  Value<DateTime?> lastPlayed,
  Value<bool> isBundled,
  Value<bool> isFavorited,
});
typedef $$CardDeckTableTableUpdateCompanionBuilder = CardDeckTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String?> emoji,
  Value<Color> color,
  Value<String> localeCode,
  Value<int?> mediumGameDurationS,
  Value<String?> author,
  Value<License> license,
  Value<DateTime?> lastPlayed,
  Value<bool> isBundled,
  Value<bool> isFavorited,
});

class $$CardDeckTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CardDeckTableTable,
    CardDeck,
    $$CardDeckTableTableFilterComposer,
    $$CardDeckTableTableOrderingComposer,
    $$CardDeckTableTableProcessedTableManager,
    $$CardDeckTableTableInsertCompanionBuilder,
    $$CardDeckTableTableUpdateCompanionBuilder> {
  $$CardDeckTableTableTableManager(_$AppDatabase db, $CardDeckTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CardDeckTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CardDeckTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$CardDeckTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> emoji = const Value.absent(),
            Value<Color> color = const Value.absent(),
            Value<String> localeCode = const Value.absent(),
            Value<int?> mediumGameDurationS = const Value.absent(),
            Value<String?> author = const Value.absent(),
            Value<License> license = const Value.absent(),
            Value<DateTime?> lastPlayed = const Value.absent(),
            Value<bool> isBundled = const Value.absent(),
            Value<bool> isFavorited = const Value.absent(),
          }) =>
              CardDeckTableCompanion(
            id: id,
            name: name,
            emoji: emoji,
            color: color,
            localeCode: localeCode,
            mediumGameDurationS: mediumGameDurationS,
            author: author,
            license: license,
            lastPlayed: lastPlayed,
            isBundled: isBundled,
            isFavorited: isFavorited,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> emoji = const Value.absent(),
            required Color color,
            required String localeCode,
            Value<int?> mediumGameDurationS = const Value.absent(),
            Value<String?> author = const Value.absent(),
            Value<License> license = const Value.absent(),
            Value<DateTime?> lastPlayed = const Value.absent(),
            Value<bool> isBundled = const Value.absent(),
            Value<bool> isFavorited = const Value.absent(),
          }) =>
              CardDeckTableCompanion.insert(
            id: id,
            name: name,
            emoji: emoji,
            color: color,
            localeCode: localeCode,
            mediumGameDurationS: mediumGameDurationS,
            author: author,
            license: license,
            lastPlayed: lastPlayed,
            isBundled: isBundled,
            isFavorited: isFavorited,
          ),
        ));
}

class $$CardDeckTableTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $CardDeckTableTable,
    CardDeck,
    $$CardDeckTableTableFilterComposer,
    $$CardDeckTableTableOrderingComposer,
    $$CardDeckTableTableProcessedTableManager,
    $$CardDeckTableTableInsertCompanionBuilder,
    $$CardDeckTableTableUpdateCompanionBuilder> {
  $$CardDeckTableTableProcessedTableManager(super.$state);
}

class $$CardDeckTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CardDeckTableTable> {
  $$CardDeckTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get emoji => $state.composableBuilder(
      column: $state.table.emoji,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<Color, Color, int> get color =>
      $state.composableBuilder(
          column: $state.table.color,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get localeCode => $state.composableBuilder(
      column: $state.table.localeCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get mediumGameDurationS => $state.composableBuilder(
      column: $state.table.mediumGameDurationS,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get author => $state.composableBuilder(
      column: $state.table.author,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<License, License, String> get license =>
      $state.composableBuilder(
          column: $state.table.license,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastPlayed => $state.composableBuilder(
      column: $state.table.lastPlayed,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isBundled => $state.composableBuilder(
      column: $state.table.isBundled,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isFavorited => $state.composableBuilder(
      column: $state.table.isFavorited,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter deckContentTableRefs(
      ComposableFilter Function($$DeckContentTableTableFilterComposer f) f) {
    final $$DeckContentTableTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.deckContentTable,
            getReferencedColumn: (t) => t.deck,
            builder: (joinBuilder, parentComposers) =>
                $$DeckContentTableTableFilterComposer(ComposerState($state.db,
                    $state.db.deckContentTable, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$CardDeckTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CardDeckTableTable> {
  $$CardDeckTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get emoji => $state.composableBuilder(
      column: $state.table.emoji,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get color => $state.composableBuilder(
      column: $state.table.color,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get localeCode => $state.composableBuilder(
      column: $state.table.localeCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get mediumGameDurationS => $state.composableBuilder(
      column: $state.table.mediumGameDurationS,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get author => $state.composableBuilder(
      column: $state.table.author,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get license => $state.composableBuilder(
      column: $state.table.license,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastPlayed => $state.composableBuilder(
      column: $state.table.lastPlayed,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isBundled => $state.composableBuilder(
      column: $state.table.isBundled,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isFavorited => $state.composableBuilder(
      column: $state.table.isFavorited,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$DeckContentTableTableInsertCompanionBuilder
    = DeckContentTableCompanion Function({
  Value<int> deck,
  required List<String> cards,
});
typedef $$DeckContentTableTableUpdateCompanionBuilder
    = DeckContentTableCompanion Function({
  Value<int> deck,
  Value<List<String>> cards,
});

class $$DeckContentTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DeckContentTableTable,
    DeckContents,
    $$DeckContentTableTableFilterComposer,
    $$DeckContentTableTableOrderingComposer,
    $$DeckContentTableTableProcessedTableManager,
    $$DeckContentTableTableInsertCompanionBuilder,
    $$DeckContentTableTableUpdateCompanionBuilder> {
  $$DeckContentTableTableTableManager(
      _$AppDatabase db, $DeckContentTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$DeckContentTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$DeckContentTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$DeckContentTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> deck = const Value.absent(),
            Value<List<String>> cards = const Value.absent(),
          }) =>
              DeckContentTableCompanion(
            deck: deck,
            cards: cards,
          ),
          getInsertCompanionBuilder: ({
            Value<int> deck = const Value.absent(),
            required List<String> cards,
          }) =>
              DeckContentTableCompanion.insert(
            deck: deck,
            cards: cards,
          ),
        ));
}

class $$DeckContentTableTableProcessedTableManager
    extends ProcessedTableManager<
        _$AppDatabase,
        $DeckContentTableTable,
        DeckContents,
        $$DeckContentTableTableFilterComposer,
        $$DeckContentTableTableOrderingComposer,
        $$DeckContentTableTableProcessedTableManager,
        $$DeckContentTableTableInsertCompanionBuilder,
        $$DeckContentTableTableUpdateCompanionBuilder> {
  $$DeckContentTableTableProcessedTableManager(super.$state);
}

class $$DeckContentTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $DeckContentTableTable> {
  $$DeckContentTableTableFilterComposer(super.$state);
  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get cards => $state.composableBuilder(
          column: $state.table.cards,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  $$CardDeckTableTableFilterComposer get deck {
    final $$CardDeckTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deck,
        referencedTable: $state.db.cardDeckTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CardDeckTableTableFilterComposer(ComposerState($state.db,
                $state.db.cardDeckTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$DeckContentTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $DeckContentTableTable> {
  $$DeckContentTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get cards => $state.composableBuilder(
      column: $state.table.cards,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$CardDeckTableTableOrderingComposer get deck {
    final $$CardDeckTableTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.deck,
            referencedTable: $state.db.cardDeckTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$CardDeckTableTableOrderingComposer(ComposerState($state.db,
                    $state.db.cardDeckTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class _$AppDatabaseManager {
  final _$AppDatabase _db;
  _$AppDatabaseManager(this._db);
  $$CardDeckTableTableTableManager get cardDeckTable =>
      $$CardDeckTableTableTableManager(_db, _db.cardDeckTable);
  $$DeckContentTableTableTableManager get deckContentTable =>
      $$DeckContentTableTableTableManager(_db, _db.deckContentTable);
}
