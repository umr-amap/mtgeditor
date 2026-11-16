import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mtg_editor/database/app_database.dart';
import 'package:mtg_editor/main.dart';

void main() {
  testWidgets('creates and opens a locally stored MTG entry', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(MyApp(database: database));
    await tester.pumpAndSettle();
    expect(
      find.text('Aucune plante. Ajoute ta première plante.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Nouvelle plante'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Créer'));
    await tester.pumpAndSettle();
    expect(find.text('Le nom est obligatoire.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(1), 'Ficus');
    await tester.enterText(find.byType(TextField).at(2), 'Ficus elastica');
    await tester.tap(find.text('Créer'));
    await tester.pumpAndSettle();

    expect(find.text('Ficus'), findsOneWidget);
    expect(find.textContaining('Ficus elastica'), findsOneWidget);

    await tester.tap(find.text('Ficus'));
    await tester.pumpAndSettle();
    expect(
      find.text('Le graphe est chargé depuis la base locale.'),
      findsOneWidget,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
}
