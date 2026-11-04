import 'package:backend_mtg/backend_mtg.dart';
import 'package:flutter/material.dart';

import '../widgets/dropdown_button_type.dart';

class NodeModificationResult {
  final String id;
  final String connexion;
  final Map<MTGAttribute, dynamic> attributes;

  const NodeModificationResult({
    required this.id,
    required this.connexion,
    required this.attributes,
  });
}

class NodeModificationScreen extends StatefulWidget {
  final MTGNode node;
  final Set<String> existingIds;

  const NodeModificationScreen({
    super.key,
    required this.node,
    required this.existingIds,
  });

  @override
  State<NodeModificationScreen> createState() => _NodeModificationScreenState();
}

class _NodeModificationScreenState extends State<NodeModificationScreen> {
  late final TextEditingController _idController;
  final _attributeNameController = TextEditingController();
  late String _connexion;
  String _currentType = typeList.first;
  final Map<MTGAttribute, TextEditingController> _currentAttributes = {};

  final Map<String, String> _mapLabelText = {
    'Entier': 'Exemple : 10',
    'String': 'Exemple : Nouveau',
    'Decimal': 'Exemple : 10.5',
    'Date': '01/01/2026',
    'Bool': 'True',
  };

  String? get _idError {
    final id = _idController.text.trim();
    if (id.isEmpty) return 'Saisissez un identifiant.';
    final originalId = widget.node.getId();
    if (widget.existingIds.contains(id) && id != originalId) {
      return 'Cet identifiant existe déjà.';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.node.getId() ?? '');
    _connexion = widget.node.getConnexion() == '+' ? '+' : '<';

    final attributes = widget.node.getAttributes()?.entries ??
        <MapEntry<MTGAttribute, dynamic>>[];
    for (final entry in attributes) {
      _currentAttributes[entry.key] = TextEditingController(
        text: entry.value?.toString() ?? '',
      );
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _attributeNameController.dispose();
    for (final controller in _currentAttributes.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier un nœud')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Modification du nœud ${widget.node.getId() ?? 'Nœud'}'),
          const SizedBox(height: 24),
          TextField(
            controller: _idController,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Identifiant',
              border: const OutlineInputBorder(),
              errorText: _idError,
            ),
          ),
          for (var index = 0; index < _currentAttributes.length; index++) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _currentAttributes.values.elementAt(index),
                    decoration: InputDecoration(
                      labelText: _currentAttributes.keys
                          .elementAt(index)
                          .getName(),
                      hintText: _mapLabelText[
                          _currentAttributes.keys.elementAt(index).typeLabel],
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Supprimer l’attribut',
                  onPressed: () {
                    setState(() {
                      final attribute = _currentAttributes.keys.elementAt(index);
                      _currentAttributes.remove(attribute)?.dispose();
                    });
                  },
                  icon: const Icon(Icons.delete_forever),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          TextField(
            controller: _attributeNameController,
            decoration: const InputDecoration(
              labelText: "Nom de l'attribut",
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _addAttribute(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              FilledButton.icon(
                onPressed: _addAttribute,
                icon: const Icon(Icons.add),
                label: const Text('Ajouter un attribut'),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: DropdownButtonType(
                  onChanged: (value) => setState(() => _currentType = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: '<', label: Text('Prolonger <')),
              ButtonSegment(value: '+', label: Text('Ramifier +')),
            ],
            selected: {_connexion},
            onSelectionChanged: (value) =>
                setState(() => _connexion = value.first),
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: _idError == null ? _save : null,
            icon: const Icon(Icons.check),
            label: const Text('Enregistrer les modifications'),
          ),
        ],
      ),
    );
  }

  void _addAttribute() {
    final attributeName = _attributeNameController.text.trim();
    if (attributeName.isEmpty) return;

    setState(() {
      final attribute = MTGAttribute(
        name: attributeName,
        type: _attributeTypeFromLabel(_currentType),
      );
      _currentAttributes[attribute] = TextEditingController();
      _attributeNameController.clear();
    });
  }

  void _save() {
    final attributes = <MTGAttribute, dynamic>{
      for (final entry in _currentAttributes.entries)
        MTGAttribute(name: entry.key.getName(), type: entry.key.getType()):
            entry.value.text.trim(),
    };
    Navigator.pop(
      context,
      NodeModificationResult(
        id: _idController.text.trim(),
        connexion: _connexion,
        attributes: attributes,
      ),
    );
  }

  MTGAttributeType _attributeTypeFromLabel(String label) {
    switch (label) {
      case 'Entier':
        return MTGAttributeType.Int;
      case 'Decimal':
        return MTGAttributeType.double;
      case 'Date':
        return MTGAttributeType.Date;
      case 'Bool':
        return MTGAttributeType.Bool;
      case 'String':
      default:
        return MTGAttributeType.String;
    }
  }
}

extension on MTGAttribute {
  String get typeLabel {
    switch (type) {
      case MTGAttributeType.Int:
        return 'Entier';
      case MTGAttributeType.double:
        return 'Decimal';
      case MTGAttributeType.Date:
        return 'Date';
      case MTGAttributeType.Bool:
        return 'Bool';
      case MTGAttributeType.String:
      case null:
        return 'String';
    }
  }
}
