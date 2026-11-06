import 'package:test/test.dart';

import 'package:backend_mtg/src/models/mtg_attribute.dart';
import 'package:backend_mtg/src/models/mtg_scale.dart';

void main() {
  group('MTGScale', () {
    test('stores and updates its properties', () {
      final attribute = MTGAttribute(name: 'height');
      final scale = MTGScale(echelle: 1, symbol: 'A', attributes: [attribute]);

      expect(scale.getEchelle(), 1);
      expect(scale.getSymbol(), 'A');
      expect(scale.getAttributes(), [attribute]);

      final newAttribute = MTGAttribute(name: 'diameter');
      scale
        ..setEchelle(2)
        ..setSymbol('B')
        ..setAttributes([newAttribute]);

      expect(scale.getEchelle(), 2);
      expect(scale.getSymbol(), 'B');
      expect(scale.getAttributes(), [newAttribute]);
    });

    test('adds attributes and removes all attributes with the same name', () {
      final scale = MTGScale();
      final attribute = MTGAttribute(name: 'height');
      scale.addAttribute(attribute);

      expect(scale.getAttributes(), [attribute]);

      scale.addAttribute(MTGAttribute(name: 'height'));
      scale.addAttribute(MTGAttribute(name: 'diameter'));
      scale.supAttribute(attribute);

      expect(scale.getAttributes()!.map((item) => item.getName()), [
        'diameter',
      ]);
    });

    test('removing an attribute is safe when the list is null', () {
      final scale = MTGScale();

      expect(
        () => scale.supAttribute(MTGAttribute(name: 'missing')),
        returnsNormally,
      );
      expect(scale.getAttributes(), isNull);
    });
  });
}
