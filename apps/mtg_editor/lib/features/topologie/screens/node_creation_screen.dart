import 'package:backend_mtg/backend_mtg.dart';
import 'package:material_ui/material_ui.dart';
import '../widgets/dropdown_button_type.dart';

class NodeCreationResult {
  final String id;
  final String connexion;
  final Map<MTGAttribute, dynamic>? attributes;

  const NodeCreationResult({
    required this.id,
    required this.connexion,
    this.attributes,
  });
}

class NodeCreationScreen extends StatefulWidget {
  final String parentId;
  final Set<String> existingIds;

  const NodeCreationScreen({
    super.key,
    required this.parentId,
    required this.existingIds,
  });

  @override
  State<NodeCreationScreen> createState() => _NodeCreationScreenState();
}

class _NodeCreationScreenState extends State<NodeCreationScreen> {
  final _idController = TextEditingController();
  final _attributeNameController = TextEditingController();
  String _connexion = '<';
  String _currentType = typeList.first;
  final Map<MTGAttribute, TextEditingController> _currentAttributes = {};

  final Map<String, String> _mapLabelText = {
    'Entier': "Exemple : 10",
    'String': "Exemple : Nouveau",
    'Decimal': "Exemple : 10.5",
    'Date': "01/01/2026",
    'Bool': "True",
  };
  String? get _idError {
    final id = _idController.text.trim();
    if (id.isEmpty) return 'Saisissez un identifiant.';
    if (widget.existingIds.contains(id)) return 'Cet identifiant existe déjà.';
    return null;
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
      appBar: AppBar(title: const Text('Ajouter un nœud')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Nouveau nœud depuis ${widget.parentId}'),
          const SizedBox(height: 24),
          TextField(
            controller: _idController,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Identifiant',
              border: OutlineInputBorder(),
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
                      hintText:
                          _mapLabelText[_currentAttributes.keys
                              .elementAt(index)
                              .typeLabel],
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Supprimer l’attribut',
                  onPressed: () {
                    setState(() {
                      final attribute = _currentAttributes.keys.elementAt(
                        index,
                      );
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
                  onChanged: (value) {
                    setState(() => _currentType = value);
                  },
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
            onPressed: _idError == null
                ? () {
                    final id = _idController.text.trim();
                    final Map<MTGAttribute, dynamic> attributs = {};
                    for (final entry in _currentAttributes.entries) {
                      attributs[MTGAttribute(
                        name: entry.key.getName(),
                        type: entry.key.getType(),
                      )] = entry.value.text
                          .trim();
                    }
                    Navigator.pop(
                      context,
                      NodeCreationResult(
                        id: id,
                        connexion: _connexion,
                        attributes: attributs,
                      ),
                    );
                  }
                : null,
            icon: const Icon(Icons.check),
            label: const Text('Créer le nœud'),
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
