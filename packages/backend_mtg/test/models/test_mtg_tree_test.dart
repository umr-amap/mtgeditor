import 'package:test/test.dart';

import 'package:backend_mtg/src/models/mtg_description.dart';
import 'package:backend_mtg/src/models/mtg_node.dart';
import 'package:backend_mtg/src/models/mtg_scale.dart';
import 'package:backend_mtg/src/models/mtg_tree.dart';

void main() {
  group('MTGTree', () {
    test('stores and updates its properties', () {
      final scale = MTGScale(symbol: 'A');
      final root = MTGNode(id: 'root');
      final node = MTGNode(id: 'node');
      final description = MTGDescription(operation: 'branching');
      final tree = MTGTree(
        scales: [scale],
        root: root,
        nodes: {'node': node},
        description: [description],
      );

      expect(tree.getScales(), [scale]);
      expect(tree.getRoot(), same(root));
      expect(tree.getNodes(), {'node': node});
      expect(tree.getDescriptions(), [description]);

      final newScale = MTGScale(symbol: 'B');
      final newRoot = MTGNode(id: 'new-root');
      final newNode = MTGNode(id: 'new-node');
      final newDescription = MTGDescription(operation: 'updated');
      tree
        ..setScale([newScale])
        ..setRoot(newRoot)
        ..setNodes({'new-node': newNode})
        ..setDescriptions([newDescription]);

      expect(tree.getScales(), [newScale]);
      expect(tree.getRoot(), same(newRoot));
      expect(tree.getNodes(), {'new-node': newNode});
      expect(tree.getDescriptions(), [newDescription]);
    });

    test('adds and removes scales by symbol', () {
      final tree = MTGTree();
      final scale = MTGScale(symbol: 'A');
      tree.addScale(scale);

      expect(tree.getScales(), [scale]);

      tree.addScale(MTGScale(symbol: 'A'));
      tree.addScale(MTGScale(symbol: 'B'));
      tree.supScale(scale);

      expect(tree.getScales()!.map((item) => item.getSymbol()), ['B']);
    });

    test('adds and removes descriptions by operation', () {
      final tree = MTGTree();
      final description = MTGDescription(operation: 'branching');
      tree.addDescription(description);

      expect(tree.getDescriptions(), [description]);

      tree.addDescription(MTGDescription(operation: 'branching'));
      tree.addDescription(MTGDescription(operation: 'successor'));
      tree.supDescription(description);

      expect(tree.getDescriptions()!.map((item) => item.getOperation()), [
        'successor',
      ]);
    });

    test('indexes nodes by id and removes them by id', () {
      final tree = MTGTree();
      final node = MTGNode(id: 'n1');
      tree.addNode(node);

      expect(tree.getNodeById('n1'), same(node));
      expect(tree.getNode(node), same(node));

      final replacement = MTGNode(id: 'n1');
      tree.addNode(replacement);
      expect(tree.getNodeById('n1'), same(replacement));

      tree.supNode(node);
      expect(tree.getNodeById('n1'), isNull);
    });

    test('returns null for an unknown node id', () {
      final tree = MTGTree(nodes: {});

      expect(tree.getNodeById('missing'), isNull);
      expect(tree.getNode(MTGNode(id: 'missing')), isNull);
    });

    test('removing an item is safe when its collection is null', () {
      final tree = MTGTree();

      expect(() => tree.supScale(MTGScale(symbol: 'missing')), returnsNormally);
      expect(
        () => tree.supDescription(MTGDescription(operation: 'missing')),
        returnsNormally,
      );
      expect(() => tree.supNode(MTGNode(id: 'missing')), returnsNormally);
      expect(tree.getScales(), isNull);
      expect(tree.getDescriptions(), isNull);
      expect(tree.getNodes(), isNull);
    });
  });
}
