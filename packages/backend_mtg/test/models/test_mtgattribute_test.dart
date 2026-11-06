import 'package:test/test.dart';

import 'package:backend_mtg/src/models/mtg_attribute.dart';

void main() {
  group('MTGAttribute', () {
    test('stores and updates its name and type', () {
      final attribute = MTGAttribute(
        name: 'height',
        type: MTGAttributeType.Int,
      );

      expect(attribute.getName(), 'height');
      expect(attribute.getType(), MTGAttributeType.Int);

      attribute.setName('diameter');
      attribute.setType(MTGAttributeType.Date);

      expect(attribute.getName(), 'diameter');
      expect(attribute.getType(), MTGAttributeType.Date);
    });

    test('allows nullable name and type', () {
      final attribute = MTGAttribute(
        name: 'height',
        type: MTGAttributeType.Int,
      );

      attribute.setName(null);
      attribute.setType(null);

      expect(attribute.getName(), isNull);
      expect(attribute.getType(), isNull);
    });
  });
}
