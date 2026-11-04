import 'package:test/test.dart';

import 'package:backend_mtg/src/models/mtg_attribute.dart';
import 'package:backend_mtg/src/models/mtg_node.dart';
import 'package:backend_mtg/src/models/mtg_scale.dart';

void main() {
  group('MTGNode', () {
    test('stores and updates its properties', () {
      final scale = MTGScale(symbol: 'A');
      final parent = MTGNode(id: 'parent');
      final descendant = MTGNode(id: 'child');
      final node = MTGNode(
        id: 'node',
        scale: scale,
        connexion: '/',
        parent: parent,
        descendants: [descendant],
      );

      expect(node.getId(), 'node');
      expect(node.getScale(), same(scale));
      expect(node.getConnexion(), '/');
      expect(node.getParent(), same(parent));
      expect(node.getDescendants(), [descendant]);

      final newScale = MTGScale(symbol: 'B');
      final newParent = MTGNode(id: 'new-parent');
      final newDescendant = MTGNode(id: 'new-child');
      node
        ..setId('updated')
        ..setScale(newScale)
        ..setConnexion('+')
        ..setParent(newParent)
        ..setDescendants([newDescendant]);

      expect(node.getId(), 'updated');
      expect(node.getScale(), same(newScale));
      expect(node.getConnexion(), '+');
      expect(node.getParent(), same(newParent));
      expect(node.getDescendants(), [newDescendant]);
    });

    test('identifies roots and leaves', () {
      final root = MTGNode();
      final child = MTGNode(parent: root);

      expect(root.isRoot(), isTrue);
      expect(child.isRoot(), isFalse);
      expect(root.isLeaf(), isTrue);

      root.setDescendants([]);
      expect(root.isLeaf(), isTrue);

      root.addDescendant(child);
      expect(root.isLeaf(), isFalse);
    });

    test('adds descendants and removes all descendants with the same id', () {
      final node = MTGNode();
      final child = MTGNode(id: 'child');
      node.addDescendant(child);

      expect(node.getDescendants(), [child]);

      node.addDescendant(MTGNode(id: 'child'));
      node.addDescendant(MTGNode(id: 'other'));
      node.supDescendant(child);

      expect(node.getDescendants()!.map((descendant) => descendant.getId()), [
        'other',
      ]);
    });

    test('removing a descendant is safe when the list is null', () {
      final node = MTGNode();

      expect(() => node.supDescendant(MTGNode(id: 'missing')), returnsNormally);
      expect(node.getDescendants(), isNull);
    });

    test('stores and updates its attributes', () {
      final height = MTGAttribute(name: 'height');
      final diameter = MTGAttribute(name: 'diameter');
      final node = MTGNode(attributes: {height: 180});

      expect(node.getAttributes(), {height: 180});

      node.setAttributes({diameter: 12.5});
      expect(node.getAttributes(), {height: 180, diameter: 12.5});
    });

    test('adds and removes attributes', () {
      final height = MTGAttribute(name: 'height');
      final diameter = MTGAttribute(name: 'diameter');
      final node = MTGNode(attributes: {});

      node.addAttribute(height);
      node.addAttribute(diameter);
      expect(node.getAttributes(), {height: null, diameter: null});

      node.supAttribute(height);
      expect(node.getAttributes(), {diameter: null});
    });

    test('removing an attribute is safe when the map is null', () {
      final node = MTGNode();

      expect(
        () => node.supAttribute(MTGAttribute(name: 'missing')),
        returnsNormally,
      );
      expect(node.getAttributes(), isNull);
    });
  });
}
