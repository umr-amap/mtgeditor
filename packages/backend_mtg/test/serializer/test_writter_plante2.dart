import 'dart:io';

import 'package:backend_mtg/src/models/mtg_attribute.dart';
import 'package:backend_mtg/src/models/mtg_description.dart';
import 'package:backend_mtg/src/models/mtg_node.dart';
import 'package:backend_mtg/src/models/mtg_scale.dart';
import 'package:backend_mtg/src/models/mtg_tree.dart';
import 'package:backend_mtg/src/serializer/mtg_writer.dart';
import 'package:test/test.dart';

void main() {
  test('2) génère un fichier MTG à inspecter manuellement', () async {
    final plantScale = MTGScale(symbol: 'Plant', echelle: 1);
    final internodeScale = MTGScale(symbol: 'Internode', echelle: 2);
    final leafScale = MTGScale(symbol: 'Leaf', echelle: 3);
    final length = MTGAttribute(
      name: 'Length',
      type: MTGAttributeType.double,
      scale: internodeScale,
    );
    final alive = MTGAttribute(
      name: 'isAlive',
      type: MTGAttributeType.Bool,
      scale: leafScale,
    );

    final root = MTGNode(
      id: 'Plant0',
      scale: plantScale,
      attributes: {length: 0.0, alive: true},
      descendants: [],
    );
    final internode = MTGNode(
      id: 'Internode0',
      scale: internodeScale,
      connexion: '+',
      attributes: {length: 1.0, alive: true},
      descendants: [],
    );
    final leaf1 = MTGNode(
      id: 'Leaf1',
      scale: leafScale,
      connexion: '<',
      attributes: {length: 0.8, alive: true},
      descendants: [],
    );
    final leaf0 = MTGNode(
      id: 'Leaf0',
      scale: leafScale,
      connexion: '<',
      attributes: {length: 0.5, alive: false},
      descendants: [],
    );

    root.addDescendant(internode, connexion: '+');
    internode
      ..addDescendant(leaf1, connexion: '<')
      ..addDescendant(leaf0, connexion: '<');

    final tree = MTGTree(
      scales: [plantScale, internodeScale, leafScale],
      root: root,
      nodes: {
        'Plant0': root,
        'Internode0': internode,
        'Leaf1': leaf1,
        'Leaf0': leaf0,
      },
      description: [
        MTGDescription(
          parents: [plantScale],
          enfants: [internodeScale],
          operation: '+',
          limite: 1,
        ),
        MTGDescription(
          parents: [internodeScale],
          enfants: [leafScale],
          operation: '<',
          limite: 1,
        ),
      ],
    );
    final output = File('test/files/generated_plant2.mtg');

    await write(tree, output.path);

    expect(await output.exists(), isTrue);
    expect(await output.length(), greaterThan(0));
    // Keep the generated file so it can be inspected after the test.
    // ignore: avoid_print
    print('Fichier MTG généré pour inspection : ${output.absolute.path}');
  });
}
