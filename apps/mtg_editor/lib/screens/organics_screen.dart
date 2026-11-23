import 'package:backend_mtg/backend_mtg.dart';
import 'package:flutter/material.dart';

import '../database/app_database.dart';

class OrganicsScreen extends StatefulWidget {
  const OrganicsScreen({required this.database, super.key});

  final AppDatabase database;

  @override
  State<OrganicsScreen> createState() => _OrganicsScreenState();
}

class _OrganicsScreenState extends State<OrganicsScreen> {
  String _searchQuery = '';

  Future<void> _createOrganic() async {
    final draft = await showDialog<({String name, String? species})>(
      context: context,
      builder: (context) => const _OrganicCreationDialog(),
    );

    if (draft == null || !mounted) return;
    await widget.database.saveOrganic(
      name: draft.name,
      species: draft.species,
      mtgTree: MTGTree(),
    );
  }

  Future<void> _openOrganic(OrganicEntry organic) async {
    final tree = await widget.database.loadOrganicGraph(organic.id);
    if (!mounted || tree == null) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            OrganicDetailsScreen(organic: organic, tree: tree),
      ),
    );
  }

  Future<void> _deleteOrganic(OrganicEntry organic) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer cette plante ?'),
        content: Text('« ${organic.name} » sera supprimée de la bibliothèque.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.database.deleteOrganic(organic.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bibliothèque MTG')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher une plante',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<OrganicEntry>>(
              stream: widget.database.watchOrganics(searchQuery: _searchQuery),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erreur de lecture : ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final organics = snapshot.data!;
                if (organics.isEmpty) {
                  return const Center(
                    child: Text('Aucune plante. Ajoute ta première plante.'),
                  );
                }
                return ListView.builder(
                  itemCount: organics.length,
                  itemBuilder: (context, index) {
                    final organic = organics[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.park_outlined),
                      ),
                      title: Text(organic.name),
                      subtitle: Text(
                        [
                          ?organic.species,
                          '${organic.nodeCount} nœud${organic.nodeCount == 1 ? '' : 's'}',
                        ].join(' • '),
                      ),
                      onTap: () => _openOrganic(organic),
                      trailing: IconButton(
                        tooltip: 'Supprimer ${organic.name}',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteOrganic(organic),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createOrganic,
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle plante'),
      ),
    );
  }
}

class _OrganicCreationDialog extends StatefulWidget {
  const _OrganicCreationDialog();

  @override
  State<_OrganicCreationDialog> createState() => _OrganicCreationDialogState();
}

class _OrganicCreationDialogState extends State<_OrganicCreationDialog> {
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  String? _nameError;

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Le nom est obligatoire.');
      return;
    }
    Navigator.pop(context, (name: name, species: _speciesController.text));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouvelle plante'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            maxLength: 120,
            decoration: InputDecoration(
              labelText: 'Nom',
              errorText: _nameError,
            ),
            onChanged: (_) {
              if (_nameError != null) {
                setState(() => _nameError = null);
              }
            },
            onSubmitted: (_) => _save(),
          ),
          TextField(
            controller: _speciesController,
            decoration: const InputDecoration(labelText: 'Espèce'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(onPressed: _save, child: const Text('Créer')),
      ],
    );
  }
}

class OrganicDetailsScreen extends StatelessWidget {
  const OrganicDetailsScreen({
    required this.organic,
    required this.tree,
    super.key,
  });

  final OrganicEntry organic;
  final MTGTree tree;

  @override
  Widget build(BuildContext context) {
    final rootId = tree.getRoot()?.getId();
    return Scaffold(
      appBar: AppBar(title: Text(organic.name)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_tree_outlined, size: 56),
            const SizedBox(height: 16),
            Text(
              '${organic.nodeCount} nœud${organic.nodeCount == 1 ? '' : 's'}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (organic.species case final species?) ...[
              const SizedBox(height: 8),
              Text(species),
            ],
            const SizedBox(height: 16),
            const Text('Le graphe est chargé depuis la base locale.'),
            const SizedBox(height: 8),
            Text(rootId == null ? 'Arbre sans racine' : 'Racine : $rootId'),
          ],
        ),
      ),
    );
  }
}
