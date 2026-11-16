import 'package:backend_mtg/backend_mtg.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mtg_editor/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('saves searchable metadata and restores the MTG graph', () async {
    final scale = MTGScale(symbol: 'P', echelle: 1);
    final root = MTGNode(
      id: '1',
      scale: scale,
      attributes: {
        MTGAttribute(name: 'height', type: MTGAttributeType.double): 1.75,
        MTGAttribute(name: 'observedAt', type: MTGAttributeType.Date):
            DateTime.utc(2025, 3, 14),
      },
    );
    final child = MTGNode(id: '1.1', scale: scale, connexion: '+');
    root.addDescendant(child, connexion: '+');
    final tree = MTGTree(
      scales: [scale],
      root: root,
      nodes: {'1': root, '1.1': child},
      description: [
        MTGDescription(
          parents: [scale],
          enfants: [scale],
          operation: 'decomposition',
          limite: 2,
        ),
      ],
    );

    final id = await database.saveOrganic(
      name: 'Ficus',
      species: 'Ficus elastica',
      mtgTree: tree,
    );

    final entry = await database.watchOrganics(searchQuery: 'elastica').first;
    expect(entry, hasLength(1));
    expect(entry.single.id, id);
    expect(entry.single.nodeCount, 2);

    final restored = await database.loadOrganicGraph(id);
    expect(restored, isNotNull);
    expect(restored!.getRoot()!.getDescendants()!.single.getId(), '1.1');
    expect(restored.getRoot()!.getScale()!.getSymbol(), 'P');
    expect(restored.getDescriptions()!.single.getOperation(), 'decomposition');
    expect(restored.getDescriptions()!.single.getLimite(), 2);
    expect(restored.getRoot()!.getAttributes()!.values, contains(1.75));
    expect(
      restored.getRoot()!.getAttributes()!.values,
      contains(DateTime.utc(2025, 3, 14)),
    );

    await database.saveOrganic(
      id: id,
      name: 'Ficus updated',
      species: 'Ficus elastica',
      mtgTree: tree,
    );
    final updated = await database.watchOrganics(searchQuery: 'updated').first;
    expect(updated.single.name, 'Ficus updated');
    expect(updated.single.nodeCount, 2);

    await database.deleteOrganic(id);
    expect(await database.loadOrganicGraph(id), isNull);
  });
}
