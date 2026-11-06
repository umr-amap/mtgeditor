import 'package:backend_mtg/src/models/mtg_attribute.dart';
import 'package:backend_mtg/src/models/mtg_description.dart';
import 'package:backend_mtg/src/models/mtg_node.dart';
import 'package:backend_mtg/src/models/mtg_scale.dart';
import 'package:backend_mtg/src/parser/mtg_file_reader.dart';
import 'package:test/test.dart';

void main() {
  late Map<String, dynamic> result;

  setUpAll(() async {
    result = await Reader(path: 'test/files/simple_plant.mtg').read();
  });

  group('Reader.read avec simple_plant.mtg', () {
    test('lit les classes avec leur symbole et leur niveau', () {
      final classes = result['classes'] as List<MTGScale>;

      expect(
        classes.map((scale) => scale.getSymbol()).toList(),
        [r"$", 'Individual', 'Axis', 'Internode', 'Leaf'],
      );
      expect(
        classes.map((scale) => scale.getEchelle()).toList(),
        [0, 1, 2, 3, 3],
      );
    });

    test('lit les descriptions avec les bonnes échelles et opérations', () {
      final descriptions = result['description'] as List<MTGDescription>;

      expect(descriptions, hasLength(2));
      expect(
        descriptions.map((description) => description.getOperation()).toList(),
        ['+', '<'],
      );
      expect(
        descriptions.first.getParents()!.map((scale) => scale.getSymbol()),
        ['Internode'],
      );
      expect(
        descriptions.first.getEnfants()!.map((scale) => scale.getSymbol()),
        ['Internode', 'Leaf'],
      );
      expect(descriptions.every((description) => description.getLimite() == null), isTrue);
    });

    test('lit les caractéristiques et leurs types MTG', () {
      final features = result['features'] as List<MTGAttribute>;

      expect(
        features.map((feature) => feature.getName()).toList(),
        ['Length', 'Width', 'XEuler', 'isAlive', 'dateDeath'],
      );
      expect(
        features.map((feature) => feature.getType()).toList(),
        [
          MTGAttributeType.String,
          MTGAttributeType.String,
          MTGAttributeType.double,
          MTGAttributeType.Bool,
          MTGAttributeType.Date,
        ],
      );
    });

    test('lit les sept entités MTG dans l’ordre du fichier', () {
      final nodes = result['nodes'] as List<MTGNode>;

      expect(nodes, hasLength(7));
      expect(
        nodes.map((node) => node.getId()).toList(),
        [
          'Scene0',
          'Individual0',
          'Axis0',
          'Internode0',
          'Leaf0',
          'Internode1',
          'Leaf0',
        ],
      );
      expect(
        nodes.map((node) => node.getConnexion()).toList(),
        ['/', '/', '/', '/', '+', '<', '+'],
      );
    });

    test('associe les valeurs de caractéristiques aux entités concernées', () {
      final nodes = result['nodes'] as List<MTGNode>;
      final attributes = nodes[3].getAttributes()!;

      expect(attributes.keys.map((attribute) => attribute.getName()), [
        'Length',
        'Width',
        'XEuler',
      ]);
      expect(attributes.values, ['0.1', '0.02', '1']);

      final leafAttributes = nodes[4].getAttributes()!;
      expect(leafAttributes.values, ['0.2', '0.1', '0', '24/08/2022']);
    });
  });
}
