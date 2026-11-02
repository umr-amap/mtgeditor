import 'package:test/test.dart';

import 'package:backend_mtg/src/models/mtg_scale.dart';

void main() {
  group('MTGScale', () {
    test('stores and updates its properties', () {
      final scale = MTGScale(echelle: 1, symbol: 'A');

      expect(scale.getEchelle(), 1);
      expect(scale.getSymbol(), 'A');

      scale
        ..setEchelle(2)
        ..setSymbol('B');

      expect(scale.getEchelle(), 2);
      expect(scale.getSymbol(), 'B');
    });

    test('properties are null by default', () {
      final scale = MTGScale();

      expect(scale.getEchelle(), isNull);
      expect(scale.getSymbol(), isNull);
    });
  });
}
