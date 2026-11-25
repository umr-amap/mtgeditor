import 'package:material_ui/material_ui.dart';

class TopologyToolbar extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool visible;

  const TopologyToolbar({
    super.key,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Ajouter'),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit),
            label: const Text('Modifier'),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Supprimer le nœud sélectionné',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
