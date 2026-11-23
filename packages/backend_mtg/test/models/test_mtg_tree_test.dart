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
      final dateCreation = DateTime.utc(2025, 1, 1);
      final dateModification = DateTime.utc(2025, 1, 2);
      final tree = MTGTree(
        scales: [scale],
        root: root,
        nodes: {'node': node},
        description: [description],
        dateCreation: dateCreation,
        dateModification: dateModification,
      );

      expect(tree.getScales(), [scale]);
      expect(tree.getRoot(), same(root));
      expect(tree.getNodes(), {'node': node});
      expect(tree.getDescriptions(), [description]);
      expect(tree.getDateCreation(), dateCreation);
      expect(tree.getDateModification(), dateModification);

      final newScale = MTGScale(symbol: 'B');
      final newRoot = MTGNode(id: 'new-root');
      final newNode = MTGNode(id: 'new-node');
      final newDescription = MTGDescription(operation: 'updated');
      final newDateCreation = DateTime.utc(2025, 2, 1);
      final newDateModification = DateTime.utc(2025, 2, 2);
      tree
        ..setScale([newScale])
        ..setRoot(newRoot)
        ..setNodes({'new-node': newNode})
        ..setDescriptions([newDescription])
        ..setDateCreation(newDateCreation)
        ..setDateModification(newDateModification);

      expect(tree.getScales(), [newScale]);
      expect(tree.getRoot(), same(newRoot));
      expect(tree.getNodes(), {'new-node': newNode});
      expect(tree.getDescriptions(), [newDescription]);
      expect(tree.getDateCreation(), newDateCreation);
      expect(tree.getDateModification(), newDateModification);
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

    test('adds and removes matching descriptions', () {
      final tree = MTGTree();
      final parent = MTGScale(symbol: 'P');
      final child = MTGScale(symbol: 'C');
      final description = MTGDescription(
        parents: [parent],
        enfants: [child],
        operation: 'branching',
      );
      tree.addDescription(description);

      expect(tree.getDescriptions(), [description]);

      final duplicate = MTGDescription(
        parents: [MTGScale(symbol: 'P')],
        enfants: [MTGScale(symbol: 'C')],
        operation: 'branching',
      );
      final differentParent = MTGDescription(
        parents: [MTGScale(symbol: 'Q')],
        enfants: [child],
        operation: 'branching',
      );
      final differentOperation = MTGDescription(
        parents: [parent],
        enfants: [child],
        operation: 'successor',
      );
      tree
        ..addDescription(duplicate)
        ..addDescription(differentParent)
        ..addDescription(differentOperation)
        ..supDescription(description);

      expect(tree.getDescriptions(), [differentParent, differentOperation]);
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

    test('attaches nodes to the root and their parent', () {
      final tree = MTGTree();
      final root = MTGNode(id: 'root');
      final child = MTGNode(id: 'child');

      tree.attachNode(node: root);
      tree.attachNode(node: child, parent: root, connexion: '/');

      expect(tree.getRoot(), same(root));
      expect(tree.getNodeById('root'), same(root));
      expect(tree.getNodeById('child'), same(child));
      expect(root.getDescendants(), [child]);
      expect(child.getParent(), same(root));
      expect(child.getConnexion(), '/');
    });

    test('removes a node and its descendants by id', () {
      final root = MTGNode(id: 'root');
      final child = MTGNode(id: 'child');
      final grandchild = MTGNode(id: 'grandchild');
      final tree = MTGTree(root: root);
      root.addDescendant(child);
      child.addDescendant(grandchild);
      tree
        ..addNode(root)
        ..addNode(child)
        ..addNode(grandchild)
        ..supNodeById('child');

      expect(tree.getNodeById('root'), same(root));
      expect(tree.getNodeById('child'), isNull);
      expect(tree.getNodeById('grandchild'), isNull);
      expect(root.getDescendants(), isEmpty);
      expect(child.getDescendants(), isEmpty);
    });

    test('does not attach another root when one is already set', () {
      final root = MTGNode(id: 'root');
      final anotherRoot = MTGNode(id: 'another-root');
      final tree = MTGTree();

      tree
        ..attachNode(node: root)
        ..attachNode(node: anotherRoot);

      expect(tree.getRoot(), same(root));
      expect(tree.getNodeById('another-root'), same(anotherRoot));
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

      expect(() => tree.supNodeById('missing'), returnsNormally);
    });
  });
}
