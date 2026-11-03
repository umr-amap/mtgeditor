import 'package:drift/drift.dart';

import 'organics.dart';
import '../mtg_tree_converter.dart';

class OrganicPayloads extends Table {
  IntColumn get organicId =>
      integer().references(Organics, #id, onDelete: KeyAction.cascade)();

  TextColumn get mtgData => text().map(const MtgTreeConverter())();

  @override
  Set<Column<Object>> get primaryKey => {organicId};
}
