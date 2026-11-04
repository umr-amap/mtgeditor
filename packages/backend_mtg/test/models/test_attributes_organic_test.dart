import 'package:test/test.dart';

import 'package:backend_mtg/src/models/attributes_organic.dart';

void main() {
  group('AttributesOrganic', () {
    test('stores and updates its properties', () {
      final attribute = AttributesOrganic('id', 'name', 'description');

      expect(attribute.getId(), 'id');
      expect(attribute.getName(), 'name');
      expect(attribute.getDescription(), 'description');

      attribute
        ..setId('updated-id')
        ..setName('updated name')
        ..setDescription('updated description');

      expect(attribute.getId(), 'updated-id');
      expect(attribute.getName(), 'updated name');
      expect(attribute.getDescription(), 'updated description');
    });

    test('allows nullable properties', () {
      final attribute = AttributesOrganic(null, null, null);

      expect(attribute.getId(), isNull);
      expect(attribute.getName(), isNull);
      expect(attribute.getDescription(), isNull);
    });
  });
}
