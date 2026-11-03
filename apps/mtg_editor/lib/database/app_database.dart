import 'package:backend_mtg/backend_mtg.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'mtg_tree_converter.dart';
import 'tables/organic_payloads.dart';
import 'tables/organics.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Organics, OrganicPayloads])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'mtg_plants_database',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  Stream<List<OrganicEntry>> watchOrganics({String searchQuery = ''}) {
    final query = select(organics);
    final search = searchQuery.trim();
    if (search.isNotEmpty) {
      final pattern = '%$search%';
      query.where((row) => row.name.like(pattern) | row.species.like(pattern));
    }
    query.orderBy([(row) => OrderingTerm.desc(row.updatedAt)]);
    return query.watch();
  }

  Future<MTGTree?> loadOrganicGraph(int organicId) async {
    final row =
        await (select(organicPayloads)
              ..where((payload) => payload.organicId.equals(organicId)))
            .getSingleOrNull();
    return row?.mtgData;
  }

  Future<int> saveOrganic({
    int? id,
    required String name,
    String? species,
    required MTGTree mtgTree,
  }) {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Name must not be empty.');
    }

    return transaction(() async {
      final now = DateTime.now();
      final calculatedNodes = MtgTreeCodec.countNodes(mtgTree);
      late final int organicId;

      if (id == null) {
        organicId = await into(organics).insert(
          OrganicsCompanion.insert(
            name: normalizedName,
            species: Value(_normalizeSpecies(species)),
            nodeCount: Value(calculatedNodes),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
      } else {
        final updated =
            await (update(organics)..where((row) => row.id.equals(id))).write(
              OrganicsCompanion(
                name: Value(normalizedName),
                species: Value(_normalizeSpecies(species)),
                nodeCount: Value(calculatedNodes),
                updatedAt: Value(now),
              ),
            );
        if (updated == 0) {
          throw StateError('Cannot update missing MTG entry with id $id.');
        }
        organicId = id;
      }

      await into(organicPayloads).insertOnConflictUpdate(
        OrganicPayloadsCompanion.insert(
          organicId: Value(organicId),
          mtgData: mtgTree,
        ),
      );
      return organicId;
    });
  }

  Future<int> deleteOrganic(int id) {
    return (delete(organics)..where((row) => row.id.equals(id))).go();
  }

  static String? _normalizeSpecies(String? species) {
    final normalized = species?.trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }
}
