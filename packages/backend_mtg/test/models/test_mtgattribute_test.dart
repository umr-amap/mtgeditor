import 'package:test/test.dart';

import 'package:backend_mtg/src/models/mtg_attribute.dart';
import 'package:backend_mtg/src/models/mtg_scale.dart';

void main() {
  group('MTGAttribute', () {
    test('stores and updates its name, type, and scale', () {
      final scale = MTGScale(symbol: 'A');
      final attribute = MTGAttribute(
        name: 'height',
        type: MTGAttributeType.Int,
        scale: scale,
      );

      expect(attribute.getName(), 'height');
      expect(attribute.getType(), MTGAttributeType.Int);
      expect(attribute.getScale(), same(scale));

      final newScale = MTGScale(symbol: 'B');
      attribute.setName('diameter');
      attribute.setType(MTGAttributeType.Date);
      attribute.setScale(newScale);

      expect(attribute.getName(), 'diameter');
      expect(attribute.getType(), MTGAttributeType.Date);
      expect(attribute.getScale(), same(newScale));
    });

    test('allows nullable name, type, and scale', () {
      final attribute = MTGAttribute(
        name: 'height',
        type: MTGAttributeType.Int,
        scale: MTGScale(symbol: 'A'),
      );

      attribute.setName(null);
      attribute.setType(null);
      attribute.setScale(null);

      expect(attribute.getName(), isNull);
      expect(attribute.getType(), isNull);
      expect(attribute.getScale(), isNull);
    });
  });
}
