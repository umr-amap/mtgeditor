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

  Map<String, TextEditingController> _createControllers() => {
    for (final attribute
        in widget.node.getScale()?.getAttributes() ?? <MTGAttribute>[])
      if (attribute.getName() != null)
        attribute.getName()!: TextEditingController(),
  };

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
    final attributes =
        widget.node.getScale()?.getAttributes() ?? <MTGAttribute>[];
    return Material(
      color: const Color(0xFFF7F1FB),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.node.getId() ?? 'Nœud',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Échelle : ${widget.node.getScale()?.getSymbol() ?? 'non définie'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    for (final attribute in attributes.take(2))
                      if (attribute.getName() != null)
                        TextField(
                          controller: _controllers[attribute.getName()],
                          keyboardType:
                              attribute.getType() == MTGAttributeType.Int
                              ? TextInputType.number
                              : TextInputType.text,
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: attribute.getName(),
                          ),
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
        ),
      ),
    );
  }
}
