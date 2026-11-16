import 'package:test/test.dart';

import 'package:backend_mtg/src/models/attributes_organic.dart';
import 'package:backend_mtg/src/models/mtg_node.dart';
import 'package:backend_mtg/src/models/mtg_tree.dart';
import 'package:backend_mtg/src/models/organic.dart';

void main() {
  group('Organic', () {
    test('stores and updates its properties', () {
      final tree = MTGTree(root: MTGNode(id: 'root'));
      final attribute = AttributesOrganic('id', 'name', 'description');
      final organic = Organic(
        'plant',
        1.5,
        2.5,
        ['before.jpg'],
        [tree],
        {'id': attribute},
      );

      expect(organic.getTag(), 'plant');
      expect(organic.getLongitude(), 1.5);
      expect(organic.getLatitude(), 2.5);
      expect(organic.getImagesUrls(), ['before.jpg']);
      expect(organic.getImageUrl(0), 'before.jpg');
      expect(organic.getMtgTrees(), [tree]);
      expect(organic.getMtgTree(0), same(tree));
      expect(organic.getAttributes(), {'id': attribute});
      expect(organic.getAttribute('id'), same(attribute));

      final newTree = MTGTree(root: MTGNode(id: 'new-root'));
      final newAttribute =
          AttributesOrganic('new', 'new name', 'new description');
      organic
        ..setTag('updated')
        ..setLongitude(3.5)
        ..setLatitude(4.5)
        ..setImagesUrls(['after.jpg'])
        ..setMtgTrees([newTree])
        ..setAttributes({'new': newAttribute});

      expect(organic.getTag(), 'updated');
      expect(organic.getLongitude(), 3.5);
      expect(organic.getLatitude(), 4.5);
      expect(organic.getImagesUrls(), ['after.jpg']);
      expect(organic.getMtgTrees(), [newTree]);
      expect(organic.getAttributes(), {'new': newAttribute});
    });

    test('adds and removes image URLs', () {
      final organic = Organic('plant', null, null, [], null, null);

      organic
        ..addImageUrl('leaf.jpg')
        ..addImageUrl('leaf.jpg')
        ..addImageUrl('stem.jpg')
        ..supImageUrl('leaf.jpg');

      expect(organic.getImagesUrls(), ['stem.jpg']);
    });

    test('adds and removes trees by root id', () {
      final organic = Organic('plant', null, null, null, null, null);
      final tree = MTGTree(root: MTGNode(id: 'root'));

      organic.addMtgTree(tree);
      expect(organic.getMtgTrees(), [tree]);

      organic
        ..addMtgTree(MTGTree(root: MTGNode(id: 'root')))
        ..addMtgTree(MTGTree(root: MTGNode(id: 'other-root')))
        ..supMtgTree(tree);

      expect(
        organic.getMtgTrees()!.map((item) => item.getRoot()?.getId()),
        ['other-root'],
      );
    });

    test('adds and removes attributes by key', () {
      final organic = Organic('plant', null, null, null, null, {});

      organic.addAttribute('height', 'Height', 'Plant height');
      expect(
        organic.getAttribute('height')!.getName(),
        'Height',
      );
      expect(
        organic.getAttribute('height')!.getDescription(),
        'Plant height',
      );

      organic.supAttribute('height');
      expect(organic.getAttribute('height'), isNull);
    });

    test('removal is safe when its collections are null', () {
      final organic = Organic('plant', null, null, null, null, null);

      expect(() => organic.supImageUrl('missing.jpg'), returnsNormally);
      expect(() => organic.supMtgTree(MTGTree()), returnsNormally);
      expect(() => organic.supAttribute('missing'), returnsNormally);
      expect(organic.getImagesUrls(), isNull);
      expect(organic.getMtgTrees(), isNull);
      expect(organic.getAttributes(), isNull);
    });
  });
}
