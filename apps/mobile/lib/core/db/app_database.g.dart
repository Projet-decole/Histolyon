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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final Profil profil = Profil(this);
  late final Preference preference = Preference(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [profil, preference];
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
          PrefetchHooks Function({bool preferenceRefs})
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
          prefetchHooksCallback: ({preferenceRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (preferenceRefs) db.preference],
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
                      referencedTable: $ProfilReferences._preferenceRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $ProfilReferences(db, table, p0).preferenceRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.profilId == item.id),
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
      PrefetchHooks Function({bool preferenceRefs})
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $ProfilTableManager get profil => $ProfilTableManager(_db, _db.profil);
  $PreferenceTableManager get preference =>
      $PreferenceTableManager(_db, _db.preference);
}
