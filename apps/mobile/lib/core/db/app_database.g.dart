// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class Profil extends Table with TableInfo<Profil, ProfilData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Profil(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _creeLeMeta = const VerificationMeta('creeLe');
  late final GeneratedColumn<DateTime> creeLe = GeneratedColumn<DateTime>(
    'cree_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [id, creeLe];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profil';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfilData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cree_le')) {
      context.handle(
        _creeLeMeta,
        creeLe.isAcceptableOrUnknown(data['cree_le']!, _creeLeMeta),
      );
    } else if (isInserting) {
      context.missing(_creeLeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfilData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfilData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      creeLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cree_le'],
      )!,
    );
  }

  @override
  Profil createAlias(String alias) {
    return Profil(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ProfilData extends DataClass implements Insertable<ProfilData> {
  final String id;
  final DateTime creeLe;
  const ProfilData({required this.id, required this.creeLe});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cree_le'] = Variable<DateTime>(creeLe);
    return map;
  }

  ProfilCompanion toCompanion(bool nullToAbsent) {
    return ProfilCompanion(id: Value(id), creeLe: Value(creeLe));
  }

  factory ProfilData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfilData(
      id: serializer.fromJson<String>(json['id']),
      creeLe: serializer.fromJson<DateTime>(json['cree_le']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cree_le': serializer.toJson<DateTime>(creeLe),
    };
  }

  ProfilData copyWith({String? id, DateTime? creeLe}) =>
      ProfilData(id: id ?? this.id, creeLe: creeLe ?? this.creeLe);
  ProfilData copyWithCompanion(ProfilCompanion data) {
    return ProfilData(
      id: data.id.present ? data.id.value : this.id,
      creeLe: data.creeLe.present ? data.creeLe.value : this.creeLe,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfilData(')
          ..write('id: $id, ')
          ..write('creeLe: $creeLe')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, creeLe);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfilData &&
          other.id == this.id &&
          other.creeLe == this.creeLe);
}

class ProfilCompanion extends UpdateCompanion<ProfilData> {
  final Value<String> id;
  final Value<DateTime> creeLe;
  final Value<int> rowid;
  const ProfilCompanion({
    this.id = const Value.absent(),
    this.creeLe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilCompanion.insert({
    required String id,
    required DateTime creeLe,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       creeLe = Value(creeLe);
  static Insertable<ProfilData> custom({
    Expression<String>? id,
    Expression<DateTime>? creeLe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (creeLe != null) 'cree_le': creeLe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? creeLe,
    Value<int>? rowid,
  }) {
    return ProfilCompanion(
      id: id ?? this.id,
      creeLe: creeLe ?? this.creeLe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (creeLe.present) {
      map['cree_le'] = Variable<DateTime>(creeLe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilCompanion(')
          ..write('id: $id, ')
          ..write('creeLe: $creeLe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Preference extends Table with TableInfo<Preference, PreferenceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Preference(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profilIdMeta = const VerificationMeta(
    'profilId',
  );
  late final GeneratedColumn<String> profilId = GeneratedColumn<String>(
    'profil_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES profil(id)',
  );
  static const VerificationMeta _cleMeta = const VerificationMeta('cle');
  late final GeneratedColumn<String> cle = GeneratedColumn<String>(
    'cle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _valeurMeta = const VerificationMeta('valeur');
  late final GeneratedColumn<String> valeur = GeneratedColumn<String>(
    'valeur',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [profilId, cle, valeur];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preference';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreferenceData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profil_id')) {
      context.handle(
        _profilIdMeta,
        profilId.isAcceptableOrUnknown(data['profil_id']!, _profilIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profilIdMeta);
    }
    if (data.containsKey('cle')) {
      context.handle(
        _cleMeta,
        cle.isAcceptableOrUnknown(data['cle']!, _cleMeta),
      );
    } else if (isInserting) {
      context.missing(_cleMeta);
    }
    if (data.containsKey('valeur')) {
      context.handle(
        _valeurMeta,
        valeur.isAcceptableOrUnknown(data['valeur']!, _valeurMeta),
      );
    } else if (isInserting) {
      context.missing(_valeurMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profilId, cle};
  @override
  PreferenceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenceData(
      profilId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profil_id'],
      )!,
      cle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cle'],
      )!,
      valeur: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valeur'],
      )!,
    );
  }

  @override
  Preference createAlias(String alias) {
    return Preference(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['PRIMARY KEY(profil_id, cle)'];
  @override
  bool get dontWriteConstraints => true;
}

class PreferenceData extends DataClass implements Insertable<PreferenceData> {
  final String profilId;
  final String cle;
  final String valeur;
  const PreferenceData({
    required this.profilId,
    required this.cle,
    required this.valeur,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profil_id'] = Variable<String>(profilId);
    map['cle'] = Variable<String>(cle);
    map['valeur'] = Variable<String>(valeur);
    return map;
  }

  PreferenceCompanion toCompanion(bool nullToAbsent) {
    return PreferenceCompanion(
      profilId: Value(profilId),
      cle: Value(cle),
      valeur: Value(valeur),
    );
  }

  factory PreferenceData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenceData(
      profilId: serializer.fromJson<String>(json['profil_id']),
      cle: serializer.fromJson<String>(json['cle']),
      valeur: serializer.fromJson<String>(json['valeur']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profil_id': serializer.toJson<String>(profilId),
      'cle': serializer.toJson<String>(cle),
      'valeur': serializer.toJson<String>(valeur),
    };
  }

  PreferenceData copyWith({String? profilId, String? cle, String? valeur}) =>
      PreferenceData(
        profilId: profilId ?? this.profilId,
        cle: cle ?? this.cle,
        valeur: valeur ?? this.valeur,
      );
  PreferenceData copyWithCompanion(PreferenceCompanion data) {
    return PreferenceData(
      profilId: data.profilId.present ? data.profilId.value : this.profilId,
      cle: data.cle.present ? data.cle.value : this.cle,
      valeur: data.valeur.present ? data.valeur.value : this.valeur,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceData(')
          ..write('profilId: $profilId, ')
          ..write('cle: $cle, ')
          ..write('valeur: $valeur')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(profilId, cle, valeur);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenceData &&
          other.profilId == this.profilId &&
          other.cle == this.cle &&
          other.valeur == this.valeur);
}

class PreferenceCompanion extends UpdateCompanion<PreferenceData> {
  final Value<String> profilId;
  final Value<String> cle;
  final Value<String> valeur;
  final Value<int> rowid;
  const PreferenceCompanion({
    this.profilId = const Value.absent(),
    this.cle = const Value.absent(),
    this.valeur = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PreferenceCompanion.insert({
    required String profilId,
    required String cle,
    required String valeur,
    this.rowid = const Value.absent(),
  }) : profilId = Value(profilId),
       cle = Value(cle),
       valeur = Value(valeur);
  static Insertable<PreferenceData> custom({
    Expression<String>? profilId,
    Expression<String>? cle,
    Expression<String>? valeur,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profilId != null) 'profil_id': profilId,
      if (cle != null) 'cle': cle,
      if (valeur != null) 'valeur': valeur,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PreferenceCompanion copyWith({
    Value<String>? profilId,
    Value<String>? cle,
    Value<String>? valeur,
    Value<int>? rowid,
  }) {
    return PreferenceCompanion(
      profilId: profilId ?? this.profilId,
      cle: cle ?? this.cle,
      valeur: valeur ?? this.valeur,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profilId.present) {
      map['profil_id'] = Variable<String>(profilId.value);
    }
    if (cle.present) {
      map['cle'] = Variable<String>(cle.value);
    }
    if (valeur.present) {
      map['valeur'] = Variable<String>(valeur.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceCompanion(')
          ..write('profilId: $profilId, ')
          ..write('cle: $cle, ')
          ..write('valeur: $valeur, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Favori extends Table with TableInfo<Favori, FavoriData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Favori(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _profilIdMeta = const VerificationMeta(
    'profilId',
  );
  late final GeneratedColumn<String> profilId = GeneratedColumn<String>(
    'profil_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES profil(id)',
  );
  static const VerificationMeta _typeDeCibleMeta = const VerificationMeta(
    'typeDeCible',
  );
  late final GeneratedColumn<String> typeDeCible = GeneratedColumn<String>(
    'type_de_cible',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (type_de_cible IN (\'pin\', \'parcours\'))',
  );
  static const VerificationMeta _cibleIdMeta = const VerificationMeta(
    'cibleId',
  );
  late final GeneratedColumn<String> cibleId = GeneratedColumn<String>(
    'cible_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _ajouteLeMeta = const VerificationMeta(
    'ajouteLe',
  );
  late final GeneratedColumn<DateTime> ajouteLe = GeneratedColumn<DateTime>(
    'ajoute_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profilId,
    typeDeCible,
    cibleId,
    ajouteLe,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favori';
  @override
  VerificationContext validateIntegrity(
    Insertable<FavoriData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profil_id')) {
      context.handle(
        _profilIdMeta,
        profilId.isAcceptableOrUnknown(data['profil_id']!, _profilIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profilIdMeta);
    }
    if (data.containsKey('type_de_cible')) {
      context.handle(
        _typeDeCibleMeta,
        typeDeCible.isAcceptableOrUnknown(
          data['type_de_cible']!,
          _typeDeCibleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_typeDeCibleMeta);
    }
    if (data.containsKey('cible_id')) {
      context.handle(
        _cibleIdMeta,
        cibleId.isAcceptableOrUnknown(data['cible_id']!, _cibleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cibleIdMeta);
    }
    if (data.containsKey('ajoute_le')) {
      context.handle(
        _ajouteLeMeta,
        ajouteLe.isAcceptableOrUnknown(data['ajoute_le']!, _ajouteLeMeta),
      );
    } else if (isInserting) {
      context.missing(_ajouteLeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {profilId, typeDeCible, cibleId},
  ];
  @override
  FavoriData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profilId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profil_id'],
      )!,
      typeDeCible: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_de_cible'],
      )!,
      cibleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cible_id'],
      )!,
      ajouteLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ajoute_le'],
      )!,
    );
  }

  @override
  Favori createAlias(String alias) {
    return Favori(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'UNIQUE(profil_id, type_de_cible, cible_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class FavoriData extends DataClass implements Insertable<FavoriData> {
  final String id;
  final String profilId;
  final String typeDeCible;
  final String cibleId;
  final DateTime ajouteLe;
  const FavoriData({
    required this.id,
    required this.profilId,
    required this.typeDeCible,
    required this.cibleId,
    required this.ajouteLe,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profil_id'] = Variable<String>(profilId);
    map['type_de_cible'] = Variable<String>(typeDeCible);
    map['cible_id'] = Variable<String>(cibleId);
    map['ajoute_le'] = Variable<DateTime>(ajouteLe);
    return map;
  }

  FavoriCompanion toCompanion(bool nullToAbsent) {
    return FavoriCompanion(
      id: Value(id),
      profilId: Value(profilId),
      typeDeCible: Value(typeDeCible),
      cibleId: Value(cibleId),
      ajouteLe: Value(ajouteLe),
    );
  }

  factory FavoriData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriData(
      id: serializer.fromJson<String>(json['id']),
      profilId: serializer.fromJson<String>(json['profil_id']),
      typeDeCible: serializer.fromJson<String>(json['type_de_cible']),
      cibleId: serializer.fromJson<String>(json['cible_id']),
      ajouteLe: serializer.fromJson<DateTime>(json['ajoute_le']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profil_id': serializer.toJson<String>(profilId),
      'type_de_cible': serializer.toJson<String>(typeDeCible),
      'cible_id': serializer.toJson<String>(cibleId),
      'ajoute_le': serializer.toJson<DateTime>(ajouteLe),
    };
  }

  FavoriData copyWith({
    String? id,
    String? profilId,
    String? typeDeCible,
    String? cibleId,
    DateTime? ajouteLe,
  }) => FavoriData(
    id: id ?? this.id,
    profilId: profilId ?? this.profilId,
    typeDeCible: typeDeCible ?? this.typeDeCible,
    cibleId: cibleId ?? this.cibleId,
    ajouteLe: ajouteLe ?? this.ajouteLe,
  );
  FavoriData copyWithCompanion(FavoriCompanion data) {
    return FavoriData(
      id: data.id.present ? data.id.value : this.id,
      profilId: data.profilId.present ? data.profilId.value : this.profilId,
      typeDeCible: data.typeDeCible.present
          ? data.typeDeCible.value
          : this.typeDeCible,
      cibleId: data.cibleId.present ? data.cibleId.value : this.cibleId,
      ajouteLe: data.ajouteLe.present ? data.ajouteLe.value : this.ajouteLe,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriData(')
          ..write('id: $id, ')
          ..write('profilId: $profilId, ')
          ..write('typeDeCible: $typeDeCible, ')
          ..write('cibleId: $cibleId, ')
          ..write('ajouteLe: $ajouteLe')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profilId, typeDeCible, cibleId, ajouteLe);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriData &&
          other.id == this.id &&
          other.profilId == this.profilId &&
          other.typeDeCible == this.typeDeCible &&
          other.cibleId == this.cibleId &&
          other.ajouteLe == this.ajouteLe);
}

class FavoriCompanion extends UpdateCompanion<FavoriData> {
  final Value<String> id;
  final Value<String> profilId;
  final Value<String> typeDeCible;
  final Value<String> cibleId;
  final Value<DateTime> ajouteLe;
  final Value<int> rowid;
  const FavoriCompanion({
    this.id = const Value.absent(),
    this.profilId = const Value.absent(),
    this.typeDeCible = const Value.absent(),
    this.cibleId = const Value.absent(),
    this.ajouteLe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoriCompanion.insert({
    required String id,
    required String profilId,
    required String typeDeCible,
    required String cibleId,
    required DateTime ajouteLe,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profilId = Value(profilId),
       typeDeCible = Value(typeDeCible),
       cibleId = Value(cibleId),
       ajouteLe = Value(ajouteLe);
  static Insertable<FavoriData> custom({
    Expression<String>? id,
    Expression<String>? profilId,
    Expression<String>? typeDeCible,
    Expression<String>? cibleId,
    Expression<DateTime>? ajouteLe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profilId != null) 'profil_id': profilId,
      if (typeDeCible != null) 'type_de_cible': typeDeCible,
      if (cibleId != null) 'cible_id': cibleId,
      if (ajouteLe != null) 'ajoute_le': ajouteLe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoriCompanion copyWith({
    Value<String>? id,
    Value<String>? profilId,
    Value<String>? typeDeCible,
    Value<String>? cibleId,
    Value<DateTime>? ajouteLe,
    Value<int>? rowid,
  }) {
    return FavoriCompanion(
      id: id ?? this.id,
      profilId: profilId ?? this.profilId,
      typeDeCible: typeDeCible ?? this.typeDeCible,
      cibleId: cibleId ?? this.cibleId,
      ajouteLe: ajouteLe ?? this.ajouteLe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profilId.present) {
      map['profil_id'] = Variable<String>(profilId.value);
    }
    if (typeDeCible.present) {
      map['type_de_cible'] = Variable<String>(typeDeCible.value);
    }
    if (cibleId.present) {
      map['cible_id'] = Variable<String>(cibleId.value);
    }
    if (ajouteLe.present) {
      map['ajoute_le'] = Variable<DateTime>(ajouteLe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriCompanion(')
          ..write('id: $id, ')
          ..write('profilId: $profilId, ')
          ..write('typeDeCible: $typeDeCible, ')
          ..write('cibleId: $cibleId, ')
          ..write('ajouteLe: $ajouteLe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class HistoriqueVisite extends Table
    with TableInfo<HistoriqueVisite, HistoriqueVisiteData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  HistoriqueVisite(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _profilIdMeta = const VerificationMeta(
    'profilId',
  );
  late final GeneratedColumn<String> profilId = GeneratedColumn<String>(
    'profil_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES profil(id)',
  );
  static const VerificationMeta _typeEvenementMeta = const VerificationMeta(
    'typeEvenement',
  );
  late final GeneratedColumn<String> typeEvenement = GeneratedColumn<String>(
    'type_evenement',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _typeDeCibleMeta = const VerificationMeta(
    'typeDeCible',
  );
  late final GeneratedColumn<String> typeDeCible = GeneratedColumn<String>(
    'type_de_cible',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (type_de_cible IN (\'pin\', \'parcours\'))',
  );
  static const VerificationMeta _cibleIdMeta = const VerificationMeta(
    'cibleId',
  );
  late final GeneratedColumn<String> cibleId = GeneratedColumn<String>(
    'cible_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _horodatageMeta = const VerificationMeta(
    'horodatage',
  );
  late final GeneratedColumn<DateTime> horodatage = GeneratedColumn<DateTime>(
    'horodatage',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _dureeSecondesMeta = const VerificationMeta(
    'dureeSecondes',
  );
  late final GeneratedColumn<int> dureeSecondes = GeneratedColumn<int>(
    'duree_secondes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _scoreQuizMeta = const VerificationMeta(
    'scoreQuiz',
  );
  late final GeneratedColumn<int> scoreQuiz = GeneratedColumn<int>(
    'score_quiz',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profilId,
    typeEvenement,
    typeDeCible,
    cibleId,
    horodatage,
    dureeSecondes,
    scoreQuiz,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'historique_visite';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistoriqueVisiteData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profil_id')) {
      context.handle(
        _profilIdMeta,
        profilId.isAcceptableOrUnknown(data['profil_id']!, _profilIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profilIdMeta);
    }
    if (data.containsKey('type_evenement')) {
      context.handle(
        _typeEvenementMeta,
        typeEvenement.isAcceptableOrUnknown(
          data['type_evenement']!,
          _typeEvenementMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_typeEvenementMeta);
    }
    if (data.containsKey('type_de_cible')) {
      context.handle(
        _typeDeCibleMeta,
        typeDeCible.isAcceptableOrUnknown(
          data['type_de_cible']!,
          _typeDeCibleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_typeDeCibleMeta);
    }
    if (data.containsKey('cible_id')) {
      context.handle(
        _cibleIdMeta,
        cibleId.isAcceptableOrUnknown(data['cible_id']!, _cibleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cibleIdMeta);
    }
    if (data.containsKey('horodatage')) {
      context.handle(
        _horodatageMeta,
        horodatage.isAcceptableOrUnknown(data['horodatage']!, _horodatageMeta),
      );
    } else if (isInserting) {
      context.missing(_horodatageMeta);
    }
    if (data.containsKey('duree_secondes')) {
      context.handle(
        _dureeSecondesMeta,
        dureeSecondes.isAcceptableOrUnknown(
          data['duree_secondes']!,
          _dureeSecondesMeta,
        ),
      );
    }
    if (data.containsKey('score_quiz')) {
      context.handle(
        _scoreQuizMeta,
        scoreQuiz.isAcceptableOrUnknown(data['score_quiz']!, _scoreQuizMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistoriqueVisiteData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoriqueVisiteData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profilId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profil_id'],
      )!,
      typeEvenement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_evenement'],
      )!,
      typeDeCible: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_de_cible'],
      )!,
      cibleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cible_id'],
      )!,
      horodatage: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}horodatage'],
      )!,
      dureeSecondes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duree_secondes'],
      ),
      scoreQuiz: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score_quiz'],
      ),
    );
  }

  @override
  HistoriqueVisite createAlias(String alias) {
    return HistoriqueVisite(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class HistoriqueVisiteData extends DataClass
    implements Insertable<HistoriqueVisiteData> {
  final String id;
  final String profilId;
  final String typeEvenement;
  final String typeDeCible;
  final String cibleId;
  final DateTime horodatage;
  final int? dureeSecondes;
  final int? scoreQuiz;
  const HistoriqueVisiteData({
    required this.id,
    required this.profilId,
    required this.typeEvenement,
    required this.typeDeCible,
    required this.cibleId,
    required this.horodatage,
    this.dureeSecondes,
    this.scoreQuiz,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profil_id'] = Variable<String>(profilId);
    map['type_evenement'] = Variable<String>(typeEvenement);
    map['type_de_cible'] = Variable<String>(typeDeCible);
    map['cible_id'] = Variable<String>(cibleId);
    map['horodatage'] = Variable<DateTime>(horodatage);
    if (!nullToAbsent || dureeSecondes != null) {
      map['duree_secondes'] = Variable<int>(dureeSecondes);
    }
    if (!nullToAbsent || scoreQuiz != null) {
      map['score_quiz'] = Variable<int>(scoreQuiz);
    }
    return map;
  }

  HistoriqueVisiteCompanion toCompanion(bool nullToAbsent) {
    return HistoriqueVisiteCompanion(
      id: Value(id),
      profilId: Value(profilId),
      typeEvenement: Value(typeEvenement),
      typeDeCible: Value(typeDeCible),
      cibleId: Value(cibleId),
      horodatage: Value(horodatage),
      dureeSecondes: dureeSecondes == null && nullToAbsent
          ? const Value.absent()
          : Value(dureeSecondes),
      scoreQuiz: scoreQuiz == null && nullToAbsent
          ? const Value.absent()
          : Value(scoreQuiz),
    );
  }

  factory HistoriqueVisiteData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoriqueVisiteData(
      id: serializer.fromJson<String>(json['id']),
      profilId: serializer.fromJson<String>(json['profil_id']),
      typeEvenement: serializer.fromJson<String>(json['type_evenement']),
      typeDeCible: serializer.fromJson<String>(json['type_de_cible']),
      cibleId: serializer.fromJson<String>(json['cible_id']),
      horodatage: serializer.fromJson<DateTime>(json['horodatage']),
      dureeSecondes: serializer.fromJson<int?>(json['duree_secondes']),
      scoreQuiz: serializer.fromJson<int?>(json['score_quiz']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profil_id': serializer.toJson<String>(profilId),
      'type_evenement': serializer.toJson<String>(typeEvenement),
      'type_de_cible': serializer.toJson<String>(typeDeCible),
      'cible_id': serializer.toJson<String>(cibleId),
      'horodatage': serializer.toJson<DateTime>(horodatage),
      'duree_secondes': serializer.toJson<int?>(dureeSecondes),
      'score_quiz': serializer.toJson<int?>(scoreQuiz),
    };
  }

  HistoriqueVisiteData copyWith({
    String? id,
    String? profilId,
    String? typeEvenement,
    String? typeDeCible,
    String? cibleId,
    DateTime? horodatage,
    Value<int?> dureeSecondes = const Value.absent(),
    Value<int?> scoreQuiz = const Value.absent(),
  }) => HistoriqueVisiteData(
    id: id ?? this.id,
    profilId: profilId ?? this.profilId,
    typeEvenement: typeEvenement ?? this.typeEvenement,
    typeDeCible: typeDeCible ?? this.typeDeCible,
    cibleId: cibleId ?? this.cibleId,
    horodatage: horodatage ?? this.horodatage,
    dureeSecondes: dureeSecondes.present
        ? dureeSecondes.value
        : this.dureeSecondes,
    scoreQuiz: scoreQuiz.present ? scoreQuiz.value : this.scoreQuiz,
  );
  HistoriqueVisiteData copyWithCompanion(HistoriqueVisiteCompanion data) {
    return HistoriqueVisiteData(
      id: data.id.present ? data.id.value : this.id,
      profilId: data.profilId.present ? data.profilId.value : this.profilId,
      typeEvenement: data.typeEvenement.present
          ? data.typeEvenement.value
          : this.typeEvenement,
      typeDeCible: data.typeDeCible.present
          ? data.typeDeCible.value
          : this.typeDeCible,
      cibleId: data.cibleId.present ? data.cibleId.value : this.cibleId,
      horodatage: data.horodatage.present
          ? data.horodatage.value
          : this.horodatage,
      dureeSecondes: data.dureeSecondes.present
          ? data.dureeSecondes.value
          : this.dureeSecondes,
      scoreQuiz: data.scoreQuiz.present ? data.scoreQuiz.value : this.scoreQuiz,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoriqueVisiteData(')
          ..write('id: $id, ')
          ..write('profilId: $profilId, ')
          ..write('typeEvenement: $typeEvenement, ')
          ..write('typeDeCible: $typeDeCible, ')
          ..write('cibleId: $cibleId, ')
          ..write('horodatage: $horodatage, ')
          ..write('dureeSecondes: $dureeSecondes, ')
          ..write('scoreQuiz: $scoreQuiz')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profilId,
    typeEvenement,
    typeDeCible,
    cibleId,
    horodatage,
    dureeSecondes,
    scoreQuiz,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoriqueVisiteData &&
          other.id == this.id &&
          other.profilId == this.profilId &&
          other.typeEvenement == this.typeEvenement &&
          other.typeDeCible == this.typeDeCible &&
          other.cibleId == this.cibleId &&
          other.horodatage == this.horodatage &&
          other.dureeSecondes == this.dureeSecondes &&
          other.scoreQuiz == this.scoreQuiz);
}

class HistoriqueVisiteCompanion extends UpdateCompanion<HistoriqueVisiteData> {
  final Value<String> id;
  final Value<String> profilId;
  final Value<String> typeEvenement;
  final Value<String> typeDeCible;
  final Value<String> cibleId;
  final Value<DateTime> horodatage;
  final Value<int?> dureeSecondes;
  final Value<int?> scoreQuiz;
  final Value<int> rowid;
  const HistoriqueVisiteCompanion({
    this.id = const Value.absent(),
    this.profilId = const Value.absent(),
    this.typeEvenement = const Value.absent(),
    this.typeDeCible = const Value.absent(),
    this.cibleId = const Value.absent(),
    this.horodatage = const Value.absent(),
    this.dureeSecondes = const Value.absent(),
    this.scoreQuiz = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HistoriqueVisiteCompanion.insert({
    required String id,
    required String profilId,
    required String typeEvenement,
    required String typeDeCible,
    required String cibleId,
    required DateTime horodatage,
    this.dureeSecondes = const Value.absent(),
    this.scoreQuiz = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profilId = Value(profilId),
       typeEvenement = Value(typeEvenement),
       typeDeCible = Value(typeDeCible),
       cibleId = Value(cibleId),
       horodatage = Value(horodatage);
  static Insertable<HistoriqueVisiteData> custom({
    Expression<String>? id,
    Expression<String>? profilId,
    Expression<String>? typeEvenement,
    Expression<String>? typeDeCible,
    Expression<String>? cibleId,
    Expression<DateTime>? horodatage,
    Expression<int>? dureeSecondes,
    Expression<int>? scoreQuiz,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profilId != null) 'profil_id': profilId,
      if (typeEvenement != null) 'type_evenement': typeEvenement,
      if (typeDeCible != null) 'type_de_cible': typeDeCible,
      if (cibleId != null) 'cible_id': cibleId,
      if (horodatage != null) 'horodatage': horodatage,
      if (dureeSecondes != null) 'duree_secondes': dureeSecondes,
      if (scoreQuiz != null) 'score_quiz': scoreQuiz,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HistoriqueVisiteCompanion copyWith({
    Value<String>? id,
    Value<String>? profilId,
    Value<String>? typeEvenement,
    Value<String>? typeDeCible,
    Value<String>? cibleId,
    Value<DateTime>? horodatage,
    Value<int?>? dureeSecondes,
    Value<int?>? scoreQuiz,
    Value<int>? rowid,
  }) {
    return HistoriqueVisiteCompanion(
      id: id ?? this.id,
      profilId: profilId ?? this.profilId,
      typeEvenement: typeEvenement ?? this.typeEvenement,
      typeDeCible: typeDeCible ?? this.typeDeCible,
      cibleId: cibleId ?? this.cibleId,
      horodatage: horodatage ?? this.horodatage,
      dureeSecondes: dureeSecondes ?? this.dureeSecondes,
      scoreQuiz: scoreQuiz ?? this.scoreQuiz,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profilId.present) {
      map['profil_id'] = Variable<String>(profilId.value);
    }
    if (typeEvenement.present) {
      map['type_evenement'] = Variable<String>(typeEvenement.value);
    }
    if (typeDeCible.present) {
      map['type_de_cible'] = Variable<String>(typeDeCible.value);
    }
    if (cibleId.present) {
      map['cible_id'] = Variable<String>(cibleId.value);
    }
    if (horodatage.present) {
      map['horodatage'] = Variable<DateTime>(horodatage.value);
    }
    if (dureeSecondes.present) {
      map['duree_secondes'] = Variable<int>(dureeSecondes.value);
    }
    if (scoreQuiz.present) {
      map['score_quiz'] = Variable<int>(scoreQuiz.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoriqueVisiteCompanion(')
          ..write('id: $id, ')
          ..write('profilId: $profilId, ')
          ..write('typeEvenement: $typeEvenement, ')
          ..write('typeDeCible: $typeDeCible, ')
          ..write('cibleId: $cibleId, ')
          ..write('horodatage: $horodatage, ')
          ..write('dureeSecondes: $dureeSecondes, ')
          ..write('scoreQuiz: $scoreQuiz, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final Profil profil = Profil(this);
  late final Preference preference = Preference(this);
  late final Favori favori = Favori(this);
  late final HistoriqueVisite historiqueVisite = HistoriqueVisite(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profil,
    preference,
    favori,
    historiqueVisite,
  ];
}

typedef $ProfilCreateCompanionBuilder = ProfilCompanion Function({
  required String id,
  required DateTime creeLe,
  Value<int> rowid,
});
typedef $ProfilUpdateCompanionBuilder = ProfilCompanion Function({
  Value<String> id,
  Value<DateTime> creeLe,
  Value<int> rowid,
});

final class $ProfilReferences
    extends BaseReferences<_$AppDatabase, Profil, ProfilData> {
  $ProfilReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Preference, List<PreferenceData>>
  _preferenceRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.preference,
    aliasName: 'profil__id__preference__profil_id',
  );

  $PreferenceProcessedTableManager get preferenceRefs {
    final manager = $PreferenceTableManager(
      $_db,
      $_db.preference,
    ).filter((f) => f.profilId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_preferenceRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Favori, List<FavoriData>> _favoriRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.favori,
    aliasName: 'profil__id__favori__profil_id',
  );

  $FavoriProcessedTableManager get favoriRefs {
    final manager = $FavoriTableManager(
      $_db,
      $_db.favori,
    ).filter((f) => f.profilId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_favoriRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<HistoriqueVisite, List<HistoriqueVisiteData>>
  _historiqueVisiteRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.historiqueVisite,
    aliasName: 'profil__id__historique_visite__profil_id',
  );

  $HistoriqueVisiteProcessedTableManager get historiqueVisiteRefs {
    final manager = $HistoriqueVisiteTableManager(
      $_db,
      $_db.historiqueVisite,
    ).filter((f) => f.profilId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _historiqueVisiteRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $ProfilFilterComposer extends Composer<_$AppDatabase, Profil> {
  $ProfilFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> preferenceRefs(
    Expression<bool> Function($PreferenceFilterComposer f) f,
  ) {
    final $PreferenceFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.preference,
      getReferencedColumn: (t) => t.profilId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PreferenceFilterComposer(
            $db: $db,
            $table: $db.preference,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> favoriRefs(
    Expression<bool> Function($FavoriFilterComposer f) f,
  ) {
    final $FavoriFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favori,
      getReferencedColumn: (t) => t.profilId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FavoriFilterComposer(
            $db: $db,
            $table: $db.favori,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> historiqueVisiteRefs(
    Expression<bool> Function($HistoriqueVisiteFilterComposer f) f,
  ) {
    final $HistoriqueVisiteFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.historiqueVisite,
      getReferencedColumn: (t) => t.profilId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HistoriqueVisiteFilterComposer(
            $db: $db,
            $table: $db.historiqueVisite,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $ProfilOrderingComposer extends Composer<_$AppDatabase, Profil> {
  $ProfilOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnOrderings(column),
  );
}

class $ProfilAnnotationComposer extends Composer<_$AppDatabase, Profil> {
  $ProfilAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get creeLe =>
      $composableBuilder(column: $table.creeLe, builder: (column) => column);

  Expression<T> preferenceRefs<T extends Object>(
    Expression<T> Function($PreferenceAnnotationComposer a) f,
  ) {
    final $PreferenceAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.preference,
      getReferencedColumn: (t) => t.profilId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PreferenceAnnotationComposer(
            $db: $db,
            $table: $db.preference,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> favoriRefs<T extends Object>(
    Expression<T> Function($FavoriAnnotationComposer a) f,
  ) {
    final $FavoriAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favori,
      getReferencedColumn: (t) => t.profilId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FavoriAnnotationComposer(
            $db: $db,
            $table: $db.favori,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> historiqueVisiteRefs<T extends Object>(
    Expression<T> Function($HistoriqueVisiteAnnotationComposer a) f,
  ) {
    final $HistoriqueVisiteAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.historiqueVisite,
      getReferencedColumn: (t) => t.profilId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HistoriqueVisiteAnnotationComposer(
            $db: $db,
            $table: $db.historiqueVisite,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $ProfilTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Profil,
          ProfilData,
          $ProfilFilterComposer,
          $ProfilOrderingComposer,
          $ProfilAnnotationComposer,
          $ProfilCreateCompanionBuilder,
          $ProfilUpdateCompanionBuilder,
          (ProfilData, $ProfilReferences),
          ProfilData,
          PrefetchHooks Function({
            bool preferenceRefs,
            bool favoriRefs,
            bool historiqueVisiteRefs,
          })
        > {
  $ProfilTableManager(_$AppDatabase db, Profil table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ProfilFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ProfilOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ProfilAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> creeLe = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => ProfilCompanion(id: id, creeLe: creeLe, rowid: rowid),
          createCompanionCallback: ({
            required String id,
            required DateTime creeLe,
            Value<int> rowid = const Value.absent(),
          }) => ProfilCompanion.insert(id: id, creeLe: creeLe, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Profil, ProfilData>(table),
                  $ProfilReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                preferenceRefs = false,
                favoriRefs = false,
                historiqueVisiteRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (preferenceRefs) db.preference,
                    if (favoriRefs) db.favori,
                    if (historiqueVisiteRefs) db.historiqueVisite,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (preferenceRefs)
                        await $_getPrefetchedData<
                          ProfilData,
                          Profil,
                          PreferenceData
                        >(
                          currentTable: table,
                          referencedTable: $ProfilReferences
                              ._preferenceRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $ProfilReferences(db, table, p0).preferenceRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profilId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (favoriRefs)
                        await $_getPrefetchedData<
                          ProfilData,
                          Profil,
                          FavoriData
                        >(
                          currentTable: table,
                          referencedTable: $ProfilReferences._favoriRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $ProfilReferences(db, table, p0).favoriRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profilId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (historiqueVisiteRefs)
                        await $_getPrefetchedData<
                          ProfilData,
                          Profil,
                          HistoriqueVisiteData
                        >(
                          currentTable: table,
                          referencedTable: $ProfilReferences
                              ._historiqueVisiteRefsTable(db),
                          managerFromTypedResult: (p0) => $ProfilReferences(
                            db,
                            table,
                            p0,
                          ).historiqueVisiteRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profilId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $ProfilProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Profil,
      ProfilData,
      $ProfilFilterComposer,
      $ProfilOrderingComposer,
      $ProfilAnnotationComposer,
      $ProfilCreateCompanionBuilder,
      $ProfilUpdateCompanionBuilder,
      (ProfilData, $ProfilReferences),
      ProfilData,
      PrefetchHooks Function({
        bool preferenceRefs,
        bool favoriRefs,
        bool historiqueVisiteRefs,
      })
    >;
typedef $PreferenceCreateCompanionBuilder = PreferenceCompanion Function({
  required String profilId,
  required String cle,
  required String valeur,
  Value<int> rowid,
});
typedef $PreferenceUpdateCompanionBuilder = PreferenceCompanion Function({
  Value<String> profilId,
  Value<String> cle,
  Value<String> valeur,
  Value<int> rowid,
});

final class $PreferenceReferences
    extends BaseReferences<_$AppDatabase, Preference, PreferenceData> {
  $PreferenceReferences(super.$_db, super.$_table, super.$_typedResult);

  static Profil _profilIdTable(_$AppDatabase db) =>
      db.profil.createAlias('preference__profil_id__profil__id');

  $ProfilProcessedTableManager get profilId {
    final $_column = $_itemColumn<String>('profil_id')!;

    final manager = $ProfilTableManager(
      $_db,
      $_db.profil,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profilIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $PreferenceFilterComposer extends Composer<_$AppDatabase, Preference> {
  $PreferenceFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cle => $composableBuilder(
    column: $table.cle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valeur => $composableBuilder(
    column: $table.valeur,
    builder: (column) => ColumnFilters(column),
  );

  $ProfilFilterComposer get profilId {
    final $ProfilFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profilId,
      referencedTable: $db.profil,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProfilFilterComposer(
            $db: $db,
            $table: $db.profil,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $PreferenceOrderingComposer extends Composer<_$AppDatabase, Preference> {
  $PreferenceOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cle => $composableBuilder(
    column: $table.cle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valeur => $composableBuilder(
    column: $table.valeur,
    builder: (column) => ColumnOrderings(column),
  );

  $ProfilOrderingComposer get profilId {
    final $ProfilOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profilId,
      referencedTable: $db.profil,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProfilOrderingComposer(
            $db: $db,
            $table: $db.profil,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $PreferenceAnnotationComposer
    extends Composer<_$AppDatabase, Preference> {
  $PreferenceAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cle =>
      $composableBuilder(column: $table.cle, builder: (column) => column);

  GeneratedColumn<String> get valeur =>
      $composableBuilder(column: $table.valeur, builder: (column) => column);

  $ProfilAnnotationComposer get profilId {
    final $ProfilAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profilId,
      referencedTable: $db.profil,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProfilAnnotationComposer(
            $db: $db,
            $table: $db.profil,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $PreferenceTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Preference,
          PreferenceData,
          $PreferenceFilterComposer,
          $PreferenceOrderingComposer,
          $PreferenceAnnotationComposer,
          $PreferenceCreateCompanionBuilder,
          $PreferenceUpdateCompanionBuilder,
          (PreferenceData, $PreferenceReferences),
          PreferenceData,
          PrefetchHooks Function({bool profilId})
        > {
  $PreferenceTableManager(_$AppDatabase db, Preference table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $PreferenceFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $PreferenceOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $PreferenceAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> profilId = const Value.absent(),
                Value<String> cle = const Value.absent(),
                Value<String> valeur = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PreferenceCompanion(
                profilId: profilId,
                cle: cle,
                valeur: valeur,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profilId,
                required String cle,
                required String valeur,
                Value<int> rowid = const Value.absent(),
              }) => PreferenceCompanion.insert(
                profilId: profilId,
                cle: cle,
                valeur: valeur,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Preference, PreferenceData>(table),
                  $PreferenceReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profilId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profilId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profilId,
                        referencedTable: $PreferenceReferences._profilIdTable(
                          db,
                        ),
                        referencedColumn: $PreferenceReferences
                            ._profilIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $PreferenceProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Preference,
      PreferenceData,
      $PreferenceFilterComposer,
      $PreferenceOrderingComposer,
      $PreferenceAnnotationComposer,
      $PreferenceCreateCompanionBuilder,
      $PreferenceUpdateCompanionBuilder,
      (PreferenceData, $PreferenceReferences),
      PreferenceData,
      PrefetchHooks Function({bool profilId})
    >;
typedef $FavoriCreateCompanionBuilder = FavoriCompanion Function({
  required String id,
  required String profilId,
  required String typeDeCible,
  required String cibleId,
  required DateTime ajouteLe,
  Value<int> rowid,
});
typedef $FavoriUpdateCompanionBuilder = FavoriCompanion Function({
  Value<String> id,
  Value<String> profilId,
  Value<String> typeDeCible,
  Value<String> cibleId,
  Value<DateTime> ajouteLe,
  Value<int> rowid,
});

final class $FavoriReferences
    extends BaseReferences<_$AppDatabase, Favori, FavoriData> {
  $FavoriReferences(super.$_db, super.$_table, super.$_typedResult);

  static Profil _profilIdTable(_$AppDatabase db) =>
      db.profil.createAlias('favori__profil_id__profil__id');

  $ProfilProcessedTableManager get profilId {
    final $_column = $_itemColumn<String>('profil_id')!;

    final manager = $ProfilTableManager(
      $_db,
      $_db.profil,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profilIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $FavoriFilterComposer extends Composer<_$AppDatabase, Favori> {
  $FavoriFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeDeCible => $composableBuilder(
    column: $table.typeDeCible,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cibleId => $composableBuilder(
    column: $table.cibleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ajouteLe => $composableBuilder(
    column: $table.ajouteLe,
    builder: (column) => ColumnFilters(column),
  );

  $ProfilFilterComposer get profilId {
    final $ProfilFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profilId,
      referencedTable: $db.profil,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProfilFilterComposer(
            $db: $db,
            $table: $db.profil,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $FavoriOrderingComposer extends Composer<_$AppDatabase, Favori> {
  $FavoriOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeDeCible => $composableBuilder(
    column: $table.typeDeCible,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cibleId => $composableBuilder(
    column: $table.cibleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ajouteLe => $composableBuilder(
    column: $table.ajouteLe,
    builder: (column) => ColumnOrderings(column),
  );

  $ProfilOrderingComposer get profilId {
    final $ProfilOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profilId,
      referencedTable: $db.profil,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProfilOrderingComposer(
            $db: $db,
            $table: $db.profil,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $FavoriAnnotationComposer extends Composer<_$AppDatabase, Favori> {
  $FavoriAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get typeDeCible => $composableBuilder(
    column: $table.typeDeCible,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cibleId =>
      $composableBuilder(column: $table.cibleId, builder: (column) => column);

  GeneratedColumn<DateTime> get ajouteLe =>
      $composableBuilder(column: $table.ajouteLe, builder: (column) => column);

  $ProfilAnnotationComposer get profilId {
    final $ProfilAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profilId,
      referencedTable: $db.profil,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProfilAnnotationComposer(
            $db: $db,
            $table: $db.profil,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $FavoriTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Favori,
          FavoriData,
          $FavoriFilterComposer,
          $FavoriOrderingComposer,
          $FavoriAnnotationComposer,
          $FavoriCreateCompanionBuilder,
          $FavoriUpdateCompanionBuilder,
          (FavoriData, $FavoriReferences),
          FavoriData,
          PrefetchHooks Function({bool profilId})
        > {
  $FavoriTableManager(_$AppDatabase db, Favori table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $FavoriFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $FavoriOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $FavoriAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profilId = const Value.absent(),
                Value<String> typeDeCible = const Value.absent(),
                Value<String> cibleId = const Value.absent(),
                Value<DateTime> ajouteLe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoriCompanion(
                id: id,
                profilId: profilId,
                typeDeCible: typeDeCible,
                cibleId: cibleId,
                ajouteLe: ajouteLe,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profilId,
                required String typeDeCible,
                required String cibleId,
                required DateTime ajouteLe,
                Value<int> rowid = const Value.absent(),
              }) => FavoriCompanion.insert(
                id: id,
                profilId: profilId,
                typeDeCible: typeDeCible,
                cibleId: cibleId,
                ajouteLe: ajouteLe,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Favori, FavoriData>(table),
                  $FavoriReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profilId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profilId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profilId,
                        referencedTable: $FavoriReferences._profilIdTable(db),
                        referencedColumn: $FavoriReferences
                            ._profilIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $FavoriProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Favori,
      FavoriData,
      $FavoriFilterComposer,
      $FavoriOrderingComposer,
      $FavoriAnnotationComposer,
      $FavoriCreateCompanionBuilder,
      $FavoriUpdateCompanionBuilder,
      (FavoriData, $FavoriReferences),
      FavoriData,
      PrefetchHooks Function({bool profilId})
    >;
typedef $HistoriqueVisiteCreateCompanionBuilder =
    HistoriqueVisiteCompanion Function({
      required String id,
      required String profilId,
      required String typeEvenement,
      required String typeDeCible,
      required String cibleId,
      required DateTime horodatage,
      Value<int?> dureeSecondes,
      Value<int?> scoreQuiz,
      Value<int> rowid,
    });
typedef $HistoriqueVisiteUpdateCompanionBuilder =
    HistoriqueVisiteCompanion Function({
      Value<String> id,
      Value<String> profilId,
      Value<String> typeEvenement,
      Value<String> typeDeCible,
      Value<String> cibleId,
      Value<DateTime> horodatage,
      Value<int?> dureeSecondes,
      Value<int?> scoreQuiz,
      Value<int> rowid,
    });

final class $HistoriqueVisiteReferences
    extends
        BaseReferences<_$AppDatabase, HistoriqueVisite, HistoriqueVisiteData> {
  $HistoriqueVisiteReferences(super.$_db, super.$_table, super.$_typedResult);

  static Profil _profilIdTable(_$AppDatabase db) =>
      db.profil.createAlias('historique_visite__profil_id__profil__id');

  $ProfilProcessedTableManager get profilId {
    final $_column = $_itemColumn<String>('profil_id')!;

    final manager = $ProfilTableManager(
      $_db,
      $_db.profil,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profilIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $HistoriqueVisiteFilterComposer
    extends Composer<_$AppDatabase, HistoriqueVisite> {
  $HistoriqueVisiteFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeEvenement => $composableBuilder(
    column: $table.typeEvenement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeDeCible => $composableBuilder(
    column: $table.typeDeCible,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cibleId => $composableBuilder(
    column: $table.cibleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get horodatage => $composableBuilder(
    column: $table.horodatage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dureeSecondes => $composableBuilder(
    column: $table.dureeSecondes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scoreQuiz => $composableBuilder(
    column: $table.scoreQuiz,
    builder: (column) => ColumnFilters(column),
  );

  $ProfilFilterComposer get profilId {
    final $ProfilFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profilId,
      referencedTable: $db.profil,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProfilFilterComposer(
            $db: $db,
            $table: $db.profil,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $HistoriqueVisiteOrderingComposer
    extends Composer<_$AppDatabase, HistoriqueVisite> {
  $HistoriqueVisiteOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeEvenement => $composableBuilder(
    column: $table.typeEvenement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeDeCible => $composableBuilder(
    column: $table.typeDeCible,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cibleId => $composableBuilder(
    column: $table.cibleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get horodatage => $composableBuilder(
    column: $table.horodatage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dureeSecondes => $composableBuilder(
    column: $table.dureeSecondes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scoreQuiz => $composableBuilder(
    column: $table.scoreQuiz,
    builder: (column) => ColumnOrderings(column),
  );

  $ProfilOrderingComposer get profilId {
    final $ProfilOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profilId,
      referencedTable: $db.profil,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProfilOrderingComposer(
            $db: $db,
            $table: $db.profil,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $HistoriqueVisiteAnnotationComposer
    extends Composer<_$AppDatabase, HistoriqueVisite> {
  $HistoriqueVisiteAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get typeEvenement => $composableBuilder(
    column: $table.typeEvenement,
    builder: (column) => column,
  );

  GeneratedColumn<String> get typeDeCible => $composableBuilder(
    column: $table.typeDeCible,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cibleId =>
      $composableBuilder(column: $table.cibleId, builder: (column) => column);

  GeneratedColumn<DateTime> get horodatage => $composableBuilder(
    column: $table.horodatage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dureeSecondes => $composableBuilder(
    column: $table.dureeSecondes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scoreQuiz =>
      $composableBuilder(column: $table.scoreQuiz, builder: (column) => column);

  $ProfilAnnotationComposer get profilId {
    final $ProfilAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profilId,
      referencedTable: $db.profil,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProfilAnnotationComposer(
            $db: $db,
            $table: $db.profil,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $HistoriqueVisiteTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          HistoriqueVisite,
          HistoriqueVisiteData,
          $HistoriqueVisiteFilterComposer,
          $HistoriqueVisiteOrderingComposer,
          $HistoriqueVisiteAnnotationComposer,
          $HistoriqueVisiteCreateCompanionBuilder,
          $HistoriqueVisiteUpdateCompanionBuilder,
          (HistoriqueVisiteData, $HistoriqueVisiteReferences),
          HistoriqueVisiteData,
          PrefetchHooks Function({bool profilId})
        > {
  $HistoriqueVisiteTableManager(_$AppDatabase db, HistoriqueVisite table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $HistoriqueVisiteFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $HistoriqueVisiteOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $HistoriqueVisiteAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profilId = const Value.absent(),
                Value<String> typeEvenement = const Value.absent(),
                Value<String> typeDeCible = const Value.absent(),
                Value<String> cibleId = const Value.absent(),
                Value<DateTime> horodatage = const Value.absent(),
                Value<int?> dureeSecondes = const Value.absent(),
                Value<int?> scoreQuiz = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HistoriqueVisiteCompanion(
                id: id,
                profilId: profilId,
                typeEvenement: typeEvenement,
                typeDeCible: typeDeCible,
                cibleId: cibleId,
                horodatage: horodatage,
                dureeSecondes: dureeSecondes,
                scoreQuiz: scoreQuiz,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profilId,
                required String typeEvenement,
                required String typeDeCible,
                required String cibleId,
                required DateTime horodatage,
                Value<int?> dureeSecondes = const Value.absent(),
                Value<int?> scoreQuiz = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HistoriqueVisiteCompanion.insert(
                id: id,
                profilId: profilId,
                typeEvenement: typeEvenement,
                typeDeCible: typeDeCible,
                cibleId: cibleId,
                horodatage: horodatage,
                dureeSecondes: dureeSecondes,
                scoreQuiz: scoreQuiz,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<HistoriqueVisite, HistoriqueVisiteData>(table),
                  $HistoriqueVisiteReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profilId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profilId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profilId,
                        referencedTable: $HistoriqueVisiteReferences
                            ._profilIdTable(db),
                        referencedColumn: $HistoriqueVisiteReferences
                            ._profilIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $HistoriqueVisiteProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      HistoriqueVisite,
      HistoriqueVisiteData,
      $HistoriqueVisiteFilterComposer,
      $HistoriqueVisiteOrderingComposer,
      $HistoriqueVisiteAnnotationComposer,
      $HistoriqueVisiteCreateCompanionBuilder,
      $HistoriqueVisiteUpdateCompanionBuilder,
      (HistoriqueVisiteData, $HistoriqueVisiteReferences),
      HistoriqueVisiteData,
      PrefetchHooks Function({bool profilId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $ProfilTableManager get profil => $ProfilTableManager(_db, _db.profil);
  $PreferenceTableManager get preference =>
      $PreferenceTableManager(_db, _db.preference);
  $FavoriTableManager get favori => $FavoriTableManager(_db, _db.favori);
  $HistoriqueVisiteTableManager get historiqueVisite =>
      $HistoriqueVisiteTableManager(_db, _db.historiqueVisite);
}
