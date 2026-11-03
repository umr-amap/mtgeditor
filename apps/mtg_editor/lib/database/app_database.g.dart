// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $OrganicsTable extends Organics
    with TableInfo<$OrganicsTable, OrganicEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrganicsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speciesMeta = const VerificationMeta(
    'species',
  );
  @override
  late final GeneratedColumn<String> species = GeneratedColumn<String>(
    'species',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nodeCountMeta = const VerificationMeta(
    'nodeCount',
  );
  @override
  late final GeneratedColumn<int> nodeCount = GeneratedColumn<int>(
    'node_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    species,
    nodeCount,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'organics';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrganicEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('species')) {
      context.handle(
        _speciesMeta,
        species.isAcceptableOrUnknown(data['species']!, _speciesMeta),
      );
    }
    if (data.containsKey('node_count')) {
      context.handle(
        _nodeCountMeta,
        nodeCount.isAcceptableOrUnknown(data['node_count']!, _nodeCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrganicEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrganicEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      species: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species'],
      ),
      nodeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}node_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $OrganicsTable createAlias(String alias) {
    return $OrganicsTable(attachedDatabase, alias);
  }
}

class OrganicEntry extends DataClass implements Insertable<OrganicEntry> {
  final int id;
  final String name;
  final String? species;
  final int nodeCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  const OrganicEntry({
    required this.id,
    required this.name,
    this.species,
    required this.nodeCount,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || species != null) {
      map['species'] = Variable<String>(species);
    }
    map['node_count'] = Variable<int>(nodeCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OrganicsCompanion toCompanion(bool nullToAbsent) {
    return OrganicsCompanion(
      id: Value(id),
      name: Value(name),
      species: species == null && nullToAbsent
          ? const Value.absent()
          : Value(species),
      nodeCount: Value(nodeCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory OrganicEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrganicEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      species: serializer.fromJson<String?>(json['species']),
      nodeCount: serializer.fromJson<int>(json['nodeCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'species': serializer.toJson<String?>(species),
      'nodeCount': serializer.toJson<int>(nodeCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  OrganicEntry copyWith({
    int? id,
    String? name,
    Value<String?> species = const Value.absent(),
    int? nodeCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => OrganicEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    species: species.present ? species.value : this.species,
    nodeCount: nodeCount ?? this.nodeCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  OrganicEntry copyWithCompanion(OrganicsCompanion data) {
    return OrganicEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      species: data.species.present ? data.species.value : this.species,
      nodeCount: data.nodeCount.present ? data.nodeCount.value : this.nodeCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrganicEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('species: $species, ')
          ..write('nodeCount: $nodeCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, species, nodeCount, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrganicEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.species == this.species &&
          other.nodeCount == this.nodeCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OrganicsCompanion extends UpdateCompanion<OrganicEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> species;
  final Value<int> nodeCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const OrganicsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.species = const Value.absent(),
    this.nodeCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  OrganicsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.species = const Value.absent(),
    this.nodeCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<OrganicEntry> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? species,
    Expression<int>? nodeCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (species != null) 'species': species,
      if (nodeCount != null) 'node_count': nodeCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  OrganicsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? species,
    Value<int>? nodeCount,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return OrganicsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      nodeCount: nodeCount ?? this.nodeCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (species.present) {
      map['species'] = Variable<String>(species.value);
    }
    if (nodeCount.present) {
      map['node_count'] = Variable<int>(nodeCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrganicsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('species: $species, ')
          ..write('nodeCount: $nodeCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $OrganicPayloadsTable extends OrganicPayloads
    with TableInfo<$OrganicPayloadsTable, OrganicPayload> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrganicPayloadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _organicIdMeta = const VerificationMeta(
    'organicId',
  );
  @override
  late final GeneratedColumn<int> organicId = GeneratedColumn<int>(
    'organic_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES organics (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<MTGTree, String> mtgData =
      GeneratedColumn<String>(
        'mtg_data',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MTGTree>($OrganicPayloadsTable.$convertermtgData);
  @override
  List<GeneratedColumn> get $columns => [organicId, mtgData];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'organic_payloads';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrganicPayload> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('organic_id')) {
      context.handle(
        _organicIdMeta,
        organicId.isAcceptableOrUnknown(data['organic_id']!, _organicIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {organicId};
  @override
  OrganicPayload map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrganicPayload(
      organicId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organic_id'],
      )!,
      mtgData: $OrganicPayloadsTable.$convertermtgData.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}mtg_data'],
        )!,
      ),
    );
  }

  @override
  $OrganicPayloadsTable createAlias(String alias) {
    return $OrganicPayloadsTable(attachedDatabase, alias);
  }

  static TypeConverter<MTGTree, String> $convertermtgData =
      const MtgTreeConverter();
}

class OrganicPayload extends DataClass implements Insertable<OrganicPayload> {
  final int organicId;
  final MTGTree mtgData;
  const OrganicPayload({required this.organicId, required this.mtgData});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['organic_id'] = Variable<int>(organicId);
    {
      map['mtg_data'] = Variable<String>(
        $OrganicPayloadsTable.$convertermtgData.toSql(mtgData),
      );
    }
    return map;
  }

  OrganicPayloadsCompanion toCompanion(bool nullToAbsent) {
    return OrganicPayloadsCompanion(
      organicId: Value(organicId),
      mtgData: Value(mtgData),
    );
  }

  factory OrganicPayload.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrganicPayload(
      organicId: serializer.fromJson<int>(json['organicId']),
      mtgData: serializer.fromJson<MTGTree>(json['mtgData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'organicId': serializer.toJson<int>(organicId),
      'mtgData': serializer.toJson<MTGTree>(mtgData),
    };
  }

  OrganicPayload copyWith({int? organicId, MTGTree? mtgData}) => OrganicPayload(
    organicId: organicId ?? this.organicId,
    mtgData: mtgData ?? this.mtgData,
  );
  OrganicPayload copyWithCompanion(OrganicPayloadsCompanion data) {
    return OrganicPayload(
      organicId: data.organicId.present ? data.organicId.value : this.organicId,
      mtgData: data.mtgData.present ? data.mtgData.value : this.mtgData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrganicPayload(')
          ..write('organicId: $organicId, ')
          ..write('mtgData: $mtgData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(organicId, mtgData);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrganicPayload &&
          other.organicId == this.organicId &&
          other.mtgData == this.mtgData);
}

class OrganicPayloadsCompanion extends UpdateCompanion<OrganicPayload> {
  final Value<int> organicId;
  final Value<MTGTree> mtgData;
  const OrganicPayloadsCompanion({
    this.organicId = const Value.absent(),
    this.mtgData = const Value.absent(),
  });
  OrganicPayloadsCompanion.insert({
    this.organicId = const Value.absent(),
    required MTGTree mtgData,
  }) : mtgData = Value(mtgData);
  static Insertable<OrganicPayload> custom({
    Expression<int>? organicId,
    Expression<String>? mtgData,
  }) {
    return RawValuesInsertable({
      if (organicId != null) 'organic_id': organicId,
      if (mtgData != null) 'mtg_data': mtgData,
    });
  }

  OrganicPayloadsCompanion copyWith({
    Value<int>? organicId,
    Value<MTGTree>? mtgData,
  }) {
    return OrganicPayloadsCompanion(
      organicId: organicId ?? this.organicId,
      mtgData: mtgData ?? this.mtgData,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (organicId.present) {
      map['organic_id'] = Variable<int>(organicId.value);
    }
    if (mtgData.present) {
      map['mtg_data'] = Variable<String>(
        $OrganicPayloadsTable.$convertermtgData.toSql(mtgData.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrganicPayloadsCompanion(')
          ..write('organicId: $organicId, ')
          ..write('mtgData: $mtgData')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OrganicsTable organics = $OrganicsTable(this);
  late final $OrganicPayloadsTable organicPayloads = $OrganicPayloadsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    organics,
    organicPayloads,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'organics',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('organic_payloads', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$OrganicsTableCreateCompanionBuilder = OrganicsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> species,
  Value<int> nodeCount,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$OrganicsTableUpdateCompanionBuilder = OrganicsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> species,
  Value<int> nodeCount,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$OrganicsTableReferences
    extends BaseReferences<_$AppDatabase, $OrganicsTable, OrganicEntry> {
  $$OrganicsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrganicPayloadsTable, List<OrganicPayload>>
  _organicPayloadsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.organicPayloads,
    aliasName: 'organics__id__organic_payloads__organic_id',
  );

  $$OrganicPayloadsTableProcessedTableManager get organicPayloadsRefs {
    final manager = $$OrganicPayloadsTableTableManager(
      $_db,
      $_db.organicPayloads,
    ).filter((f) => f.organicId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _organicPayloadsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrganicsTableFilterComposer
    extends Composer<_$AppDatabase, $OrganicsTable> {
  $$OrganicsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get species => $composableBuilder(
    column: $table.species,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nodeCount => $composableBuilder(
    column: $table.nodeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> organicPayloadsRefs(
    Expression<bool> Function($$OrganicPayloadsTableFilterComposer f) f,
  ) {
    final $$OrganicPayloadsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.organicPayloads,
      getReferencedColumn: (t) => t.organicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganicPayloadsTableFilterComposer(
            $db: $db,
            $table: $db.organicPayloads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrganicsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrganicsTable> {
  $$OrganicsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get species => $composableBuilder(
    column: $table.species,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nodeCount => $composableBuilder(
    column: $table.nodeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrganicsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrganicsTable> {
  $$OrganicsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get species =>
      $composableBuilder(column: $table.species, builder: (column) => column);

  GeneratedColumn<int> get nodeCount =>
      $composableBuilder(column: $table.nodeCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> organicPayloadsRefs<T extends Object>(
    Expression<T> Function($$OrganicPayloadsTableAnnotationComposer a) f,
  ) {
    final $$OrganicPayloadsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.organicPayloads,
      getReferencedColumn: (t) => t.organicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganicPayloadsTableAnnotationComposer(
            $db: $db,
            $table: $db.organicPayloads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrganicsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrganicsTable,
          OrganicEntry,
          $$OrganicsTableFilterComposer,
          $$OrganicsTableOrderingComposer,
          $$OrganicsTableAnnotationComposer,
          $$OrganicsTableCreateCompanionBuilder,
          $$OrganicsTableUpdateCompanionBuilder,
          (OrganicEntry, $$OrganicsTableReferences),
          OrganicEntry,
          PrefetchHooks Function({bool organicPayloadsRefs})
        > {
  $$OrganicsTableTableManager(_$AppDatabase db, $OrganicsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrganicsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrganicsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrganicsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> species = const Value.absent(),
                Value<int> nodeCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => OrganicsCompanion(
                id: id,
                name: name,
                species: species,
                nodeCount: nodeCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> species = const Value.absent(),
                Value<int> nodeCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => OrganicsCompanion.insert(
                id: id,
                name: name,
                species: species,
                nodeCount: nodeCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrganicsTable, OrganicEntry>(table),
                  $$OrganicsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({organicPayloadsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (organicPayloadsRefs) db.organicPayloads,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (organicPayloadsRefs)
                    await $_getPrefetchedDataByColumns<
                      OrganicEntry,
                      $OrganicsTable,
                      OrganicPayload,
                      $OrganicPayloadsTable
                    >(
                      currentTable: table,
                      referencedTable: $$OrganicsTableReferences
                          ._organicPayloadsRefsTable(db),
                      managerFromTypedResult: (p0) => $$OrganicsTableReferences(
                        db,
                        table,
                        p0,
                      ).organicPayloadsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'organic_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$OrganicsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrganicsTable,
      OrganicEntry,
      $$OrganicsTableFilterComposer,
      $$OrganicsTableOrderingComposer,
      $$OrganicsTableAnnotationComposer,
      $$OrganicsTableCreateCompanionBuilder,
      $$OrganicsTableUpdateCompanionBuilder,
      (OrganicEntry, $$OrganicsTableReferences),
      OrganicEntry,
      PrefetchHooks Function({bool organicPayloadsRefs})
    >;
typedef $$OrganicPayloadsTableCreateCompanionBuilder =
    OrganicPayloadsCompanion Function({
      Value<int> organicId,
      required MTGTree mtgData,
    });
typedef $$OrganicPayloadsTableUpdateCompanionBuilder =
    OrganicPayloadsCompanion Function({
      Value<int> organicId,
      Value<MTGTree> mtgData,
    });

final class $$OrganicPayloadsTableReferences
    extends
        BaseReferences<_$AppDatabase, $OrganicPayloadsTable, OrganicPayload> {
  $$OrganicPayloadsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrganicsTable _organicIdTable(_$AppDatabase db) =>
      db.organics.createAlias('organic_payloads__organic_id__organics__id');

  $$OrganicsTableProcessedTableManager get organicId {
    final $_column = $_itemColumn<int>('organic_id')!;

    final manager = $$OrganicsTableTableManager(
      $_db,
      $_db.organics,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_organicIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrganicPayloadsTableFilterComposer
    extends Composer<_$AppDatabase, $OrganicPayloadsTable> {
  $$OrganicPayloadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<MTGTree, MTGTree, String> get mtgData =>
      $composableBuilder(
        column: $table.mtgData,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$OrganicsTableFilterComposer get organicId {
    final $$OrganicsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organicId,
      referencedTable: $db.organics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganicsTableFilterComposer(
            $db: $db,
            $table: $db.organics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrganicPayloadsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrganicPayloadsTable> {
  $$OrganicPayloadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mtgData => $composableBuilder(
    column: $table.mtgData,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrganicsTableOrderingComposer get organicId {
    final $$OrganicsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organicId,
      referencedTable: $db.organics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganicsTableOrderingComposer(
            $db: $db,
            $table: $db.organics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrganicPayloadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrganicPayloadsTable> {
  $$OrganicPayloadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<MTGTree, String> get mtgData =>
      $composableBuilder(column: $table.mtgData, builder: (column) => column);

  $$OrganicsTableAnnotationComposer get organicId {
    final $$OrganicsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organicId,
      referencedTable: $db.organics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganicsTableAnnotationComposer(
            $db: $db,
            $table: $db.organics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrganicPayloadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrganicPayloadsTable,
          OrganicPayload,
          $$OrganicPayloadsTableFilterComposer,
          $$OrganicPayloadsTableOrderingComposer,
          $$OrganicPayloadsTableAnnotationComposer,
          $$OrganicPayloadsTableCreateCompanionBuilder,
          $$OrganicPayloadsTableUpdateCompanionBuilder,
          (OrganicPayload, $$OrganicPayloadsTableReferences),
          OrganicPayload,
          PrefetchHooks Function({bool organicId})
        > {
  $$OrganicPayloadsTableTableManager(
    _$AppDatabase db,
    $OrganicPayloadsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrganicPayloadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrganicPayloadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrganicPayloadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> organicId = const Value.absent(),
                Value<MTGTree> mtgData = const Value.absent(),
              }) => OrganicPayloadsCompanion(
                organicId: organicId,
                mtgData: mtgData,
              ),
          createCompanionCallback:
              ({
                Value<int> organicId = const Value.absent(),
                required MTGTree mtgData,
              }) => OrganicPayloadsCompanion.insert(
                organicId: organicId,
                mtgData: mtgData,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrganicPayloadsTable, OrganicPayload>(table),
                  $$OrganicPayloadsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({organicId = false}) {
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
                    if (organicId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.organicId,
                        referencedTable: $$OrganicPayloadsTableReferences
                            ._organicIdTable(db),
                        referencedColumn: $$OrganicPayloadsTableReferences
                            ._organicIdTable(db)
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

typedef $$OrganicPayloadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrganicPayloadsTable,
      OrganicPayload,
      $$OrganicPayloadsTableFilterComposer,
      $$OrganicPayloadsTableOrderingComposer,
      $$OrganicPayloadsTableAnnotationComposer,
      $$OrganicPayloadsTableCreateCompanionBuilder,
      $$OrganicPayloadsTableUpdateCompanionBuilder,
      (OrganicPayload, $$OrganicPayloadsTableReferences),
      OrganicPayload,
      PrefetchHooks Function({bool organicId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OrganicsTableTableManager get organics =>
      $$OrganicsTableTableManager(_db, _db.organics);
  $$OrganicPayloadsTableTableManager get organicPayloads =>
      $$OrganicPayloadsTableTableManager(_db, _db.organicPayloads);
}
