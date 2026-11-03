import 'package:test/test.dart';

import 'package:backend_mtg/src/models/mtg_description.dart';
import 'package:backend_mtg/src/models/mtg_scale.dart';

void main() {
  group('MTGDescription', () {
    test('stores and updates its properties', () {
      final parent = MTGScale(symbol: 'P');
      final child = MTGScale(symbol: 'C');
      final description = MTGDescription(
        parents: [parent],
        enfants: [child],
        operation: 'branching',
        limite: 3,
      );

      expect(description.getParents(), [parent]);
      expect(description.getEnfants(), [child]);
      expect(description.getOperation(), 'branching');
      expect(description.getLimite(), 3);

      final newParent = MTGScale(symbol: 'NP');
      final newChild = MTGScale(symbol: 'NC');
      description
        ..setParents([newParent])
        ..setEnfants([newChild])
        ..setOperation('updated')
        ..setLimite(5);

      expect(description.getParents(), [newParent]);
      expect(description.getEnfants(), [newChild]);
      expect(description.getOperation(), 'updated');
      expect(description.getLimite(), 5);
    });

    test('adds parents and removes all parents with the same symbol', () {
      final description = MTGDescription();
      final parent = MTGScale(symbol: 'P');
      description.addParent(parent);

      expect(description.getParents(), [parent]);

      description.addParent(MTGScale(symbol: 'P'));
      description.addParent(MTGScale(symbol: 'Q'));
      description.supParent(parent);

      expect(description.getParents()!.map((scale) => scale.getSymbol()), [
        'Q',
      ]);
    });

    test('adds children and removes all children with the same symbol', () {
      final description = MTGDescription();
      final child = MTGScale(symbol: 'C');
      description.addEnfant(child);

      expect(description.getEnfants(), [child]);

      description.addEnfant(MTGScale(symbol: 'C'));
      description.addEnfant(MTGScale(symbol: 'D'));
      description.supEnfant(child);

      expect(description.getEnfants()!.map((scale) => scale.getSymbol()), [
        'D',
      ]);
    });

    test('removal is safe when the lists are null', () {
      final description = MTGDescription();
      final scale = MTGScale(symbol: 'missing');

      expect(() => description.supParent(scale), returnsNormally);
      expect(() => description.supEnfant(scale), returnsNormally);
      expect(description.getParents(), isNull);
      expect(description.getEnfants(), isNull);
    });
  });
}
