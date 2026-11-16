import 'dart:io';

import 'package:backend_mtg/backend_mtg.dart';
import 'package:backend_mtg/src/models/attributes_organic.dart';

void main() => TerminalMtgApp().run();

class TerminalMtgApp {
  final MTGTree _tree = MTGTree(
    nodes: {},
    dateCreation: DateTime.now(),
    dateModification: DateTime.now(),
  );
  late final Organic _plant;
  final Map<MTGScale, String> _scaleNames = {};
  final List<MTGAttribute> _features = [];
  bool _closed = false;

  TerminalMtgApp() {
    final plantScale = _addScale('P', 1, 'Plante');
    final internodeScale = _addScale('I', 2, 'Internoeud');
    final leafScale = _addScale('F', 2, 'Feuille');
    _addRelation(plantScale, internodeScale, '>');
    _addRelation(internodeScale, internodeScale, '+');
    _addRelation(internodeScale, leafScale, '>');
    _addRelation(leafScale, leafScale, '+');

    final root = MTGNode(id: 'plante-1', scale: plantScale, attributes: {});
    _tree.attachNode(node: root);
    _plant = Organic('plante-1', null, null, [], [_tree], {});
  }

  void run() {
    stdout.writeln('=== Test du backend MTG — mode terminal ===');
    while (!_closed) {
      stdout.writeln('\n1. Gérer le format MTG (échelles et relations)');
      stdout.writeln('2. Gérer les nœuds');
      stdout.writeln('3. Visualiser l’arbre complet');
      stdout.writeln('4. Vues par échelle (plante / internœud / feuille)');
      stdout.writeln('5. Gérer les attributs généraux de la plante');
      stdout.writeln('6. Gérer les caractéristiques des nœuds');
      stdout.writeln('0. Quitter');
      final choice = _ask('Votre choix : ');
      switch (choice) {
        case '1':
          _formatMenu();
        case '2':
          _nodeMenu();
        case '3':
          _showTree();
        case '4':
          _scaleViewsMenu();
        case '5':
          _plantMenu();
        case '6':
          _featureMenu();
        case '0':
          _closed = true;
        case null:
          _closed = true;
        default:
          stdout.writeln('Choix invalide.');
      }
    }
    stdout.writeln('Fin de la session. Les modifications restent en mémoire.');
  }

  String? _ask(String prompt) {
    stdout.write(prompt);
    final answer = stdin.readLineSync();
    if (answer == null) _closed = true;
    return answer?.trim();
  }

  String? _required(String prompt) {
    while (!_closed) {
      final value = _ask(prompt);
      if (value == null) return null;
      if (value.isNotEmpty) return value;
      stdout.writeln('Cette valeur ne peut pas être vide.');
    }
    return null;
  }

  int? _chooseNumber(String prompt, int maximum) {
    while (!_closed) {
      final raw = _ask(prompt);
      if (raw == null || raw.isEmpty) return null;
      final value = int.tryParse(raw);
      if (value != null && value >= 1 && value <= maximum) return value - 1;
      stdout.writeln('Saisissez un nombre entre 1 et $maximum (ou Entrée pour annuler).');
    }
    return null;
  }

  bool _confirm(String prompt) {
    final answer = _ask('$prompt (o/N) ')?.toLowerCase();
    return answer == 'o' || answer == 'oui';
  }

  MTGScale _addScale(String symbol, int level, String name) {
    final scale = MTGScale(symbol: symbol, echelle: level);
    _tree.addScale(scale);
    _scaleNames[scale] = name;
    return scale;
  }

  void _addRelation(MTGScale parent, MTGScale child, String operation) {
    _tree.addDescription(
      MTGDescription(parents: [parent], enfants: [child], operation: operation),
    );
  }

  String _scaleName(MTGScale? scale) {
    if (scale == null) return 'non définie';
    return _scaleNames[scale] ?? 'Échelle ${scale.getSymbol() ?? '?'}';
  }

  List<MTGScale> get _scales => List<MTGScale>.from(_tree.getScales() ?? []);
  List<MTGNode> get _nodes =>
      List<MTGNode>.from(_tree.getNodes()?.values ?? const <MTGNode>[])
        ..sort((a, b) => (a.getId() ?? '').compareTo(b.getId() ?? ''));

  void _formatMenu() {
    while (!_closed) {
      stdout.writeln('\n--- Format MTG ---');
      _printScales();
      _printRelations();
      stdout.writeln('1. Ajouter une échelle');
      stdout.writeln('2. Modifier une échelle');
      stdout.writeln('3. Supprimer une échelle');
      stdout.writeln('4. Ajouter une relation');
      stdout.writeln('5. Supprimer une relation');
      stdout.writeln('0. Retour');
      switch (_ask('Votre choix : ')) {
        case '1':
          _createScale();
        case '2':
          _editScale();
        case '3':
          _deleteScale();
        case '4':
          _createRelation();
        case '5':
          _deleteRelation();
        case '0':
        case null:
          return;
        default:
          stdout.writeln('Choix invalide.');
      }
    }
  }

  void _printScales() {
    stdout.writeln('Échelles :');
    if (_scales.isEmpty) stdout.writeln('  (aucune)');
    for (var i = 0; i < _scales.length; i++) {
      final scale = _scales[i];
      stdout.writeln(
        '  ${i + 1}. ${_scaleName(scale)} [${scale.getSymbol()}], niveau ${scale.getEchelle()}',
      );
    }
  }

  void _printRelations() {
    stdout.writeln('Relations autorisées :');
    final descriptions = _tree.getDescriptions() ?? [];
    if (descriptions.isEmpty) stdout.writeln('  (aucune)');
    for (var i = 0; i < descriptions.length; i++) {
      final relation = descriptions[i];
      final parents =
          relation.getParents()?.map(_scaleName).join(', ') ?? 'aucune';
      final children =
          relation.getEnfants()?.map(_scaleName).join(', ') ?? 'aucune';
      stdout.writeln(
        '  ${i + 1}. $parents ${relation.getOperation()} $children',
      );
    }
  }

  void _createScale() {
    final name = _required('Nom de l’échelle : ');
    if (name == null) return;
    final symbol = _required('Symbole (unique) : ');
    if (symbol == null) return;
    if (_scales.any((scale) => scale.getSymbol() == symbol)) {
      stdout.writeln('Une échelle utilise déjà ce symbole.');
      return;
    }
    final rawLevel = _required('Niveau numérique : ');
    final level = int.tryParse(rawLevel ?? '');
    if (level == null) {
      stdout.writeln('Le niveau doit être un entier.');
      return;
    }
    final scale = _addScale(symbol, level, name);
    stdout.writeln('Échelle ${_scaleName(scale)} ajoutée.');
  }

  void _editScale() {
    final scale = _chooseScale();
    if (scale == null) return;
    final name = _ask('Nom [${_scaleName(scale)}] : ');
    if (_closed) return;
    if (name != null && name.isNotEmpty) _scaleNames[scale] = name;
    final symbol = _ask('Symbole [${scale.getSymbol()}] : ');
    if (_closed) return;
    if (symbol != null && symbol.isNotEmpty) {
      if (_scales.any((other) =>
          !identical(other, scale) && other.getSymbol() == symbol)) {
        stdout.writeln('Une échelle utilise déjà ce symbole.');
        return;
      }
      scale.setSymbol(symbol);
    }
    final level = _ask('Niveau [${scale.getEchelle()}] : ');
    if (_closed) return;
    if (level != null && level.isNotEmpty) {
      final parsedLevel = int.tryParse(level);
      if (parsedLevel == null) {
        stdout.writeln('Le niveau doit être un entier.');
        return;
      }
      scale.setEchelle(parsedLevel);
    }
    _touchTree();
    stdout.writeln('Échelle modifiée.');
  }

  void _deleteScale() {
    final scale = _chooseScale();
    if (scale == null) return;
    if (_nodes.any((node) => identical(node.getScale(), scale))) {
      stdout.writeln('Suppression impossible : des nœuds utilisent cette échelle.');
      return;
    }
    if (!_confirm('Supprimer ${_scaleName(scale)} et ses relations ?')) return;
    _tree.supScale(scale);
    _tree.getDescriptions()?.removeWhere((description) =>
        (description.getParents() ?? []).contains(scale) ||
        (description.getEnfants() ?? []).contains(scale));
    _scaleNames.remove(scale);
    _touchTree();
    stdout.writeln('Échelle et relations supprimées.');
  }

  void _createRelation() {
    final parent = _chooseScale(prompt: 'Échelle parente : ');
    if (parent == null) return;
    final child = _chooseScale(prompt: 'Échelle enfant : ');
    if (child == null) return;
    final operation = _chooseOperation();
    if (operation == null) return;
    if (_allowedOperations(parent, child).contains(operation)) {
      stdout.writeln('Cette relation existe déjà.');
      return;
    }
    _addRelation(parent, child, operation);
    _touchTree();
    stdout.writeln('Relation ajoutée.');
  }

  void _deleteRelation() {
    final relations = _tree.getDescriptions() ?? [];
    if (relations.isEmpty) {
      stdout.writeln('Aucune relation à supprimer.');
      return;
    }
    _printRelations();
    final index = _chooseNumber('Relation à supprimer : ', relations.length);
    if (index == null) return;
    relations.removeAt(index);
    _touchTree();
    stdout.writeln('Relation supprimée.');
  }

  MTGScale? _chooseScale({String prompt = 'Échelle : '}) {
    final scales = _scales;
    if (scales.isEmpty) {
      stdout.writeln('Aucune échelle définie. Configurez d’abord le format MTG.');
      return null;
    }
    _printScales();
    final index = _chooseNumber(prompt, scales.length);
    return index == null ? null : scales[index];
  }

  String? _chooseOperation({List<String> operations = const ['+', '>']}) {
    stdout.writeln('Relations :');
    for (var i = 0; i < operations.length; i++) {
      stdout.writeln('  ${i + 1}. ${operations[i]}');
    }
    final index = _chooseNumber('Relation : ', operations.length);
    return index == null ? null : operations[index];
  }

  List<String> _allowedOperations(MTGScale parent, MTGScale child) {
    final result = <String>{};
    for (final description in _tree.getDescriptions() ?? <MTGDescription>[]) {
      final matchingParent = (description.getParents() ?? [])
          .any((item) => item.getSymbol() == parent.getSymbol());
      final matchingChild = (description.getEnfants() ?? [])
          .any((item) => item.getSymbol() == child.getSymbol());
      final operation = description.getOperation();
      if (matchingParent &&
          matchingChild &&
          (operation == '+' || operation == '>')) {
        result.add(operation!);
      }
    }
    return result.toList()..sort();
  }

  void _nodeMenu() {
    while (!_closed) {
      stdout.writeln('\n--- Nœuds MTG ---');
      stdout.writeln('1. Lister les nœuds');
      stdout.writeln('2. Afficher les informations d’un nœud');
      stdout.writeln('3. Ajouter un nœud');
      stdout.writeln('4. Modifier un nœud');
      stdout.writeln('5. Supprimer un nœud et ses descendants');
      stdout.writeln('0. Retour');
      switch (_ask('Votre choix : ')) {
        case '1':
          _listNodes();
        case '2':
          final nodeForDetails = _chooseNode();
          if (nodeForDetails != null) _showNode(nodeForDetails);
        case '3':
          _createNode();
        case '4':
          final nodeForEdit = _chooseNode();
          if (nodeForEdit != null) _editNode(nodeForEdit);
        case '5':
          _deleteNode();
        case '0':
        case null:
          return;
        default:
          stdout.writeln('Choix invalide.');
      }
    }
  }

  void _listNodes() {
    if (_nodes.isEmpty) {
      stdout.writeln('Aucun nœud.');
      return;
    }
    for (final node in _nodes) {
      final parentId = node.getParent()?.getId();
      final relation =
          parentId == null ? 'racine' : '${node.getConnexion()} depuis $parentId';
      stdout.writeln(
        '- ${node.getId()} | ${_scaleName(node.getScale())} | $relation',
      );
    }
  }

  MTGNode? _chooseNode() {
    final nodes = _nodes;
    if (nodes.isEmpty) {
      stdout.writeln('Aucun nœud à sélectionner.');
      return null;
    }
    for (var i = 0; i < nodes.length; i++) {
      stdout.writeln('  ${i + 1}. ${nodes[i].getId()} (${_scaleName(nodes[i].getScale())})');
    }
    final index = _chooseNumber('Nœud : ', nodes.length);
    return index == null ? null : nodes[index];
  }

  void _createNode() {
    final scale = _chooseScale();
    if (scale == null) return;
    final id = _required('Identifiant du nœud (unique) : ');
    if (id == null) return;
    if (_tree.getNodeById(id) != null) {
      stdout.writeln('Cet identifiant existe déjà.');
      return;
    }

    final parent = _tree.getRoot() == null ? null : _chooseNode();
    if (_tree.getRoot() != null && parent == null) return;
    String? connection;
    if (parent != null) {
      final operations = _allowedOperations(parent.getScale()!, scale);
      if (operations.isEmpty) {
        stdout.writeln(
          'Aucune relation définie entre ${_scaleName(parent.getScale())} et ${_scaleName(scale)}. '
          'Ajoutez-la dans la gestion du format MTG.',
        );
        return;
      }
      connection = _chooseOperation(operations: operations);
      if (connection == null) return;
    }

    final node = MTGNode(id: id, scale: scale, attributes: {});
    _initializeNodeFeatures(node);
    _tree.attachNode(node: node, parent: parent, connexion: connection);
    if (parent == null) {
      _plant.setMtgTrees([_tree]);
      _plant.setTag(id);
    }
    _touchTree();
    stdout.writeln('Nœud $id ajouté.');
  }

  void _editNode(MTGNode node) {
    while (!_closed) {
      stdout.writeln('\n--- Modifier ${node.getId()} ---');
      stdout.writeln('1. Modifier l’identifiant');
      stdout.writeln('2. Modifier l’échelle');
      stdout.writeln('3. Modifier la relation avec le parent');
      stdout.writeln('4. Modifier les valeurs des caractéristiques');
      stdout.writeln('5. Afficher les informations');
      stdout.writeln('0. Retour');
      switch (_ask('Votre choix : ')) {
        case '1':
          _renameNode(node);
        case '2':
          _changeNodeScale(node);
        case '3':
          _changeNodeRelation(node);
        case '4':
          _editNodeFeatures(node);
        case '5':
          _showNode(node);
        case '0':
        case null:
          return;
        default:
          stdout.writeln('Choix invalide.');
      }
    }
  }

  void _renameNode(MTGNode node) {
    final oldId = node.getId();
    final newId = _required('Nouvel identifiant : ');
    if (newId == null || newId == oldId) return;
    if (_tree.getNodeById(newId) != null) {
      stdout.writeln('Cet identifiant existe déjà.');
      return;
    }
    _tree.getNodes()?.remove(oldId);
    node.setId(newId);
    _tree.addNode(node);
    if (identical(_plant.getMtgTree(0)?.getRoot(), node)) {
      _plant.setTag(newId);
    }
    _touchTree();
    stdout.writeln('Identifiant modifié.');
  }

  void _changeNodeScale(MTGNode node) {
    final scale = _chooseScale();
    if (scale == null) return;
    final parent = node.getParent();
    if (parent != null &&
        !_allowedOperations(parent.getScale()!, scale)
            .contains(node.getConnexion())) {
      stdout.writeln(
        'Cette échelle n’est pas compatible avec sa relation actuelle. '
        'Modifiez d’abord le format ou la relation du nœud.',
      );
      return;
    }
    node.setScale(scale);
    _initializeNodeFeatures(node);
    _touchTree();
    stdout.writeln('Échelle du nœud modifiée.');
  }

  void _changeNodeRelation(MTGNode node) {
    final parent = node.getParent();
    if (parent == null) {
      stdout.writeln('La racine n’a pas de relation avec un parent.');
      return;
    }
    final operations = _allowedOperations(parent.getScale()!, node.getScale()!);
    if (operations.isEmpty) {
      stdout.writeln('Aucune relation n’est définie pour ces échelles.');
      return;
    }
    final relation = _chooseOperation(operations: operations);
    if (relation == null) return;
    node.setConnexion(relation);
    _touchTree();
    stdout.writeln('Relation modifiée.');
  }

  void _deleteNode() {
    final node = _chooseNode();
    if (node == null) return;
    if (!_confirm('Supprimer ${node.getId()} et toute sa branche ?')) return;
    _tree.supNode(node);
    _touchTree();
    stdout.writeln('Nœud et descendants supprimés.');
  }

  void _showNode(MTGNode node) {
    stdout.writeln('\n--- Informations du nœud ---');
    stdout.writeln('Identifiant : ${node.getId()}');
    stdout.writeln('Échelle : ${_scaleName(node.getScale())}');
    stdout.writeln('Niveau : ${node.getScale()?.getEchelle() ?? 'non défini'}');
    stdout.writeln('Parent : ${node.getParent()?.getId() ?? '(racine)'}');
    stdout.writeln('Relation : ${node.getConnexion() ?? '(aucune)'}');
    stdout.writeln('Descendants directs : ${(node.getDescendants() ?? []).length}');
    stdout.writeln('Caractéristiques :');
    final attributes = node.getAttributes() ?? {};
    if (attributes.isEmpty) stdout.writeln('  (aucune)');
    for (final entry in attributes.entries) {
      stdout.writeln('  ${entry.key.getName()}: ${entry.value ?? '(non renseignée)'}');
    }
  }

  void _showTree() {
    final root = _tree.getRoot();
    if (root == null) {
      stdout.writeln('Arbre vide.');
      return;
    }
    stdout.writeln('\n--- Arbre MTG ---');
    _printBranch(root, '', true);
  }

  void _printBranch(MTGNode node, String prefix, bool isLast) {
    final connector = node.isRoot() ? '' : (isLast ? '└── ' : '├── ');
    final relation =
        node.isRoot() ? '' : '[${node.getConnexion() ?? '?'}] ';
    stdout.writeln(
      '$prefix$connector$relation${node.getId()} (${_scaleName(node.getScale())})',
    );
    final children = node.getDescendants() ?? [];
    for (var i = 0; i < children.length; i++) {
      _printBranch(
        children[i],
        '$prefix${node.isRoot() ? '' : (isLast ? '    ' : '│   ')}',
        i == children.length - 1,
      );
    }
  }

  void _scaleViewsMenu() {
    while (!_closed) {
      stdout.writeln('\n--- Vues par échelle ---');
      stdout.writeln('1. Vue plante');
      stdout.writeln('2. Vue internœuds');
      stdout.writeln('3. Vue feuilles');
      stdout.writeln('0. Retour');
      switch (_ask('Votre choix : ')) {
        case '1':
          _showPlantView();
        case '2':
          _showInternodeView();
        case '3':
          _showLeafView();
        case '0':
        case null:
          return;
        default:
          stdout.writeln('Choix invalide.');
      }
    }
  }

  MTGScale? _scaleForKind(String kind) {
    for (final scale in _scales) {
      final name = _scaleName(scale).toLowerCase();
      final symbol = (scale.getSymbol() ?? '').toLowerCase();
      if (kind == 'plante' &&
          (name.contains('plant') || name.contains('plante') || symbol == 'p')) {
        return scale;
      }
      if (kind == 'internoeud' &&
          (name.contains('internoeud') ||
              name.contains('internode') ||
              symbol == 'i')) {
        return scale;
      }
      if (kind == 'feuille' &&
          (name.contains('feuille') || name.contains('leaf') || symbol == 'f')) {
        return scale;
      }
    }
    return null;
  }

  List<MTGNode> _nodesAtScale(MTGScale? scale) {
    if (scale == null) return [];
    return _nodes.where((node) => identical(node.getScale(), scale)).toList();
  }

  void _showPlantView() {
    final scale = _scaleForKind('plante');
    stdout.writeln('\n=== Vue plante ===');
    stdout.writeln('Tag : ${_plant.getTag() ?? '(non renseigné)'}');
    stdout.writeln('Position : ${_plant.getLatitude() ?? '-'}, ${_plant.getLongitude() ?? '-'}');
    if (scale == null) {
      stdout.writeln('Aucune échelle de plante n’est définie dans le format.');
      return;
    }
    final plants = _nodesAtScale(scale);
    if (plants.isEmpty) {
      stdout.writeln('Aucun nœud à l’échelle plante.');
      return;
    }
    for (final plant in plants) {
      stdout.writeln('\nPlante ${plant.getId()}');
      _printBranch(plant, '', true);
    }
  }

  void _showInternodeView() {
    final scale = _scaleForKind('internoeud');
    stdout.writeln('\n=== Vue internœuds ===');
    final internodes = _nodesAtScale(scale);
    if (internodes.isEmpty) {
      stdout.writeln('Aucun internœud (vérifiez le nom/symbole de l’échelle).');
      return;
    }
    for (final node in internodes) {
      final successor = (node.getDescendants() ?? [])
          .where((child) => identical(child.getScale(), scale))
          .map((child) => child.getId())
          .join(', ');
      stdout.writeln(
        'Internœud ${node.getId()} | parent: ${node.getParent()?.getId() ?? '-'} '
        '| relation: ${node.getConnexion() ?? '-'} | successeurs: ${successor.isEmpty ? '(aucun)' : successor}',
      );
      _printAttributesInline(node);
    }
  }

  void _showLeafView() {
    final scale = _scaleForKind('feuille');
    stdout.writeln('\n=== Vue feuilles ===');
    final leaves = _nodesAtScale(scale);
    if (leaves.isEmpty) {
      stdout.writeln('Aucune feuille (vérifiez le nom/symbole de l’échelle).');
      return;
    }
    for (final leaf in leaves) {
      stdout.writeln('+------------------------------');
      stdout.writeln('| Feuille ${leaf.getId()}');
      stdout.writeln('| Attachée à : ${leaf.getParent()?.getId() ?? '(racine)'}');
      stdout.writeln('| Relation : ${leaf.getConnexion() ?? '(aucune)'}');
      final attributes = leaf.getAttributes() ?? {};
      if (attributes.isEmpty) {
        stdout.writeln('| Caractéristiques : (aucune)');
      } else {
        for (final entry in attributes.entries) {
          stdout.writeln('| ${entry.key.getName()} : ${entry.value ?? '(non renseignée)'}');
        }
      }
      stdout.writeln('+------------------------------');
    }
  }

  void _printAttributesInline(MTGNode node) {
    final attributes = node.getAttributes() ?? {};
    if (attributes.isEmpty) {
      stdout.writeln('  Caractéristiques : (aucune)');
      return;
    }
    for (final entry in attributes.entries) {
      stdout.writeln('  ${entry.key.getName()} : ${entry.value ?? '(non renseignée)'}');
    }
  }

  void _plantMenu() {
    while (!_closed) {
      stdout.writeln('\n--- Attributs généraux de la plante ---');
      stdout.writeln('Tag : ${_plant.getTag() ?? '-'}');
      stdout.writeln('Latitude : ${_plant.getLatitude() ?? '-'}');
      stdout.writeln('Longitude : ${_plant.getLongitude() ?? '-'}');
      stdout.writeln('Attributs définis : ${_plant.getAttributes()?.length ?? 0}');
      stdout.writeln('1. Modifier le tag');
      stdout.writeln('2. Modifier la latitude');
      stdout.writeln('3. Modifier la longitude');
      stdout.writeln('4. Lister les attributs');
      stdout.writeln('5. Ajouter/modifier la définition d’un attribut');
      stdout.writeln('6. Supprimer la définition d’un attribut');
      stdout.writeln('0. Retour');
      switch (_ask('Votre choix : ')) {
        case '1':
          final value = _required('Nouveau tag : ');
          if (value != null) _plant.setTag(value);
        case '2':
          _setPlantCoordinate(latitude: true);
        case '3':
          _setPlantCoordinate(latitude: false);
        case '4':
          _listPlantAttributes();
        case '5':
          _editPlantAttribute();
        case '6':
          _deletePlantAttribute();
        case '0':
        case null:
          return;
        default:
          stdout.writeln('Choix invalide.');
      }
    }
  }

  void _setPlantCoordinate({required bool latitude}) {
    final coordinateName = latitude ? 'latitude' : 'longitude';
    final raw = _ask('Nouvelle $coordinateName (vide pour effacer) : ');
    if (_closed) return;
    if (raw == null || raw.isEmpty) {
      if (latitude) {
        _plant.setLatitude(null);
      } else {
        _plant.setLongitude(null);
      }
      return;
    }
    final value = double.tryParse(raw);
    if (value == null) {
      stdout.writeln('Coordonnée invalide : saisissez un nombre décimal.');
      return;
    }
    if (latitude) {
      _plant.setLatitude(value);
    } else {
      _plant.setLongitude(value);
    }
  }

  void _listPlantAttributes() {
    final attributes = _plant.getAttributes() ?? {};
    if (attributes.isEmpty) {
      stdout.writeln('Aucun attribut général défini.');
      return;
    }
    for (final entry in attributes.entries) {
      stdout.writeln(
        '- ${entry.key}: ${entry.value.getName() ?? '(sans nom)'} — '
        '${entry.value.getDescription() ?? '(sans description)'}',
      );
    }
  }

  void _editPlantAttribute() {
    final id = _required('Clé de l’attribut : ');
    if (id == null) return;
    final name = _required('Nom : ');
    if (name == null) return;
    final description = _ask('Description (facultative) : ');
    if (description == null) return;
    _plant.addAttribute(id, name, description.isEmpty ? null : description);
    stdout.writeln('Définition de l’attribut enregistrée.');
  }

  void _deletePlantAttribute() {
    final attributes = _plant.getAttributes() ?? {};
    if (attributes.isEmpty) {
      stdout.writeln('Aucun attribut général à supprimer.');
      return;
    }
    _listPlantAttributes();
    final id = _required('Clé à supprimer : ');
    if (id == null) return;
    if (!attributes.containsKey(id)) {
      stdout.writeln('Attribut inconnu.');
      return;
    }
    _plant.supAttribute(id);
    stdout.writeln('Attribut supprimé.');
  }

  void _featureMenu() {
    while (!_closed) {
      stdout.writeln('\n--- Caractéristiques des nœuds ---');
      _printFeatures();
      stdout.writeln('1. Ajouter une caractéristique');
      stdout.writeln('2. Supprimer une caractéristique');
      stdout.writeln('0. Retour');
      switch (_ask('Votre choix : ')) {
        case '1':
          _createFeature();
        case '2':
          _deleteFeature();
        case '0':
        case null:
          return;
        default:
          stdout.writeln('Choix invalide.');
      }
    }
  }

  void _printFeatures() {
    if (_features.isEmpty) {
      stdout.writeln('Aucune caractéristique définie.');
      return;
    }
    for (var i = 0; i < _features.length; i++) {
      final feature = _features[i];
      stdout.writeln(
        '${i + 1}. ${feature.getName()} (${_typeName(feature.getType())}) '
        '— ${_scaleName(feature.getScale())}',
      );
    }
  }

  String _typeName(MTGAttributeType? type) => switch (type) {
        MTGAttributeType.Bool => 'booléen',
        MTGAttributeType.Int => 'entier',
        MTGAttributeType.Date => 'date ISO (AAAA-MM-JJ)',
        MTGAttributeType.String => 'texte',
        MTGAttributeType.double => 'réel',
        null => 'non défini',
      };

  void _createFeature() {
    final name = _required('Nom de la caractéristique : ');
    if (name == null) return;
    if (_features.any((feature) => feature.getName() == name)) {
      stdout.writeln('Ce nom de caractéristique existe déjà.');
      return;
    }
    final scale = _chooseScale();
    if (scale == null) return;
    stdout.writeln('Types : 1 booléen, 2 entier, 3 réel, 4 texte, 5 date');
    final typeIndex = _chooseNumber('Type : ', 5);
    if (typeIndex == null) return;
    final type = switch (typeIndex) {
      0 => MTGAttributeType.Bool,
      1 => MTGAttributeType.Int,
      2 => MTGAttributeType.double,
      3 => MTGAttributeType.String,
      _ => MTGAttributeType.Date,
    };
    final feature = MTGAttribute(name: name, type: type, scale: scale);
    _features.add(feature);
    for (final node in _nodesAtScale(scale)) {
      node.getAttributes()?[feature] = null;
    }
    _touchTree();
    stdout.writeln('Caractéristique ajoutée.');
  }

  void _deleteFeature() {
    if (_features.isEmpty) {
      stdout.writeln('Aucune caractéristique à supprimer.');
      return;
    }
    _printFeatures();
    final index = _chooseNumber('Caractéristique à supprimer : ', _features.length);
    if (index == null) return;
    final feature = _features.removeAt(index);
    for (final node in _nodes) {
      node.supAttribute(feature);
    }
    _touchTree();
    stdout.writeln('Caractéristique supprimée des nœuds.');
  }

  void _initializeNodeFeatures(MTGNode node) {
    final attributes = node.getAttributes();
    if (attributes == null) return;
    for (final feature in _features) {
      if (identical(feature.getScale(), node.getScale())) {
        attributes.putIfAbsent(feature, () => null);
      }
    }
  }

  void _editNodeFeatures(MTGNode node) {
    final available = _features
        .where((feature) => identical(feature.getScale(), node.getScale()))
        .toList();
    if (available.isEmpty) {
      stdout.writeln(
        'Aucune caractéristique définie pour ${_scaleName(node.getScale())}.',
      );
      return;
    }
    for (var i = 0; i < available.length; i++) {
      final value = node.getAttributes()?[available[i]];
      stdout.writeln(
        '${i + 1}. ${available[i].getName()} = ${value ?? '(non renseignée)'}',
      );
    }
    final index = _chooseNumber('Caractéristique à modifier : ', available.length);
    if (index == null) return;
    final feature = available[index];
    final raw = _required('Nouvelle valeur (${_typeName(feature.getType())}) : ');
    if (raw == null) return;
    final value = _parseFeatureValue(feature.getType(), raw);
    if (value == null) {
      stdout.writeln('Valeur invalide pour le type ${_typeName(feature.getType())}.');
      return;
    }
    node.getAttributes()?[feature] = value;
    _touchTree();
    stdout.writeln('Valeur enregistrée.');
  }

  Object? _parseFeatureValue(MTGAttributeType? type, String value) {
    switch (type) {
      case MTGAttributeType.Bool:
        if (value.toLowerCase() == 'true' || value.toLowerCase() == 'vrai') {
          return true;
        }
        if (value.toLowerCase() == 'false' || value.toLowerCase() == 'faux') {
          return false;
        }
        return null;
      case MTGAttributeType.Int:
        return int.tryParse(value);
      case MTGAttributeType.double:
        return double.tryParse(value);
      case MTGAttributeType.String:
        return value;
      case MTGAttributeType.Date:
        try {
          return DateTime.parse(value);
        } on FormatException {
          return null;
        }
      case null:
        return null;
    }
  }

  void _touchTree() {
    _tree.setDateModification(DateTime.now());
  }
}
