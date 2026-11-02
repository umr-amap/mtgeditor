import 'package:flutter/material.dart';
import 'package:backend_mtg/backend_mtg.dart';

import '../controllers/topology_controller.dart';
import '../widgets/node_details_sheet.dart';
import '../widgets/topology_canvas.dart';
import '../widgets/topology_toolbar.dart';
import 'node_creation_screen.dart';

class TopologyScreen extends StatefulWidget {
  final MTGTree tree;

  const TopologyScreen({super.key, required this.tree});

  @override
  State<TopologyScreen> createState() => _TopologyScreenState();
}

class _TopologyScreenState extends State<TopologyScreen> {
  late final TopologyController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TopologyController(tree: widget.tree);
    _seedPositions();
  }

  void _seedPositions() {
    _controller.layoutNodes();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openCreationPage() async {
    final parent = _controller.selectedNode;
    if (parent == null) return;
    final result = await Navigator.push<NodeCreationResult>(
      context,
      MaterialPageRoute(
        builder: (_) => NodeCreationScreen(
          parentId: parent.getId() ?? 'Nœud',
          existingIds: _controller.nodes
              .map((node) => node.getId())
              .whereType<String>()
              .toSet(),
        ),
      ),
    );
    if (!mounted || result == null) return;
    final node = MTGNode(id: result.id, scale: parent.getScale());
    final added = _controller.addNode(
      node: node,
      parent: parent,
      connexion: result.connexion,
    );
    if (!added) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cet identifiant existe déjà.')),
        );
      }
      return;
    }
    _controller.selectNode(node);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Topologie MTG')),
      body: Column(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final selected = _controller.selectedNode;
                return Column(
                  children: [
                    Expanded(
                      child: TopologyCanvas(
                        controller: _controller,
                        onNodeTap: _controller.selectNode,
                      ),
                    ),
                    if (selected != null)
                      NodeDetailsPanel(
                        key: ValueKey(selected.getId()),
                        node: selected,
                        onClose: () => _controller.selectNode(null),
                      ),
                    TopologyToolbar(
                      onAdd: _openCreationPage,
                      onDelete: selected == null
                          ? () {}
                          : () => _controller.removeNode(selected),
                      visible: selected != null,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
