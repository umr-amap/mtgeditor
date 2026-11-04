import 'package:backend_mtg/backend_mtg.dart';
import 'package:flutter/material.dart';

class NodeDetailsPanel extends StatefulWidget {
  final MTGNode node;
  final VoidCallback onClose;

  const NodeDetailsPanel({
    super.key,
    required this.node,
    required this.onClose,
  });

  @override
  State<NodeDetailsPanel> createState() => _NodeDetailsPanelState();
}

class _NodeDetailsPanelState extends State<NodeDetailsPanel> {
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = _createControllers();
  }

  @override
  void didUpdateWidget(covariant NodeDetailsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.node.getId() == widget.node.getId()) return;

    _disposeControllers();
    _controllers = _createControllers();
  }

  Map<String, TextEditingController> _createControllers() {
    final attributes = widget.node.getAttributes() ?? {};
    return {
      for (final entry in attributes.entries)
        if (entry.key.getName() != null)
          entry.key.getName()!: TextEditingController(
            text: entry.value?.toString() ?? '',
          ),
    };
  }

  void _disposeControllers() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attributes = widget.node.getAttributes()?.entries ?? [];
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.15,
      maxChildSize: 0.8,
      builder: (context, scrollController) => SafeArea(
        top: false,
        child: Material(
          color: const Color(0xFFF7F1FB),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.node.getId() ?? 'Nœud',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          'Échelle : ${widget.node.getScale()?.getSymbol() ?? 'non définie'}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Désélectionner',
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              for (final entry in attributes)
                if (entry.key.getName() != null)
                  Row(
                    children: [
                      Text('${entry.key.getName()!} : '),
                      Expanded(
                        child: TextField(
                          controller: _controllers[entry.key.getName()!],
                          keyboardType:
                              entry.key.getType() == MTGAttributeType.Int
                              ? TextInputType.number
                              : TextInputType.text,
                          decoration: InputDecoration(isDense: true),
                        ),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
