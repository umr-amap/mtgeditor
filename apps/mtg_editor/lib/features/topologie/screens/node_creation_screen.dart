import 'package:flutter/material.dart';

class NodeCreationResult {
  final String id;
  final String connexion;

  const NodeCreationResult({required this.id, required this.connexion});
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
  String _connexion = '<';

  String? get _idError {
    final id = _idController.text.trim();
    if (id.isEmpty) return 'Saisissez un identifiant.';
    if (widget.existingIds.contains(id)) return 'Cet identifiant existe déjà.';
    return null;
  }

  @override
  void dispose() {
    _idController.dispose();
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
                    Navigator.pop(
                      context,
                      NodeCreationResult(id: id, connexion: _connexion),
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
}
