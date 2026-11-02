import 'package:flutter/material.dart';
import 'package:backend_mtg/backend_mtg.dart';

class NodeWidget extends StatelessWidget {
  final MTGNode node;
  final bool selected;
  final VoidCallback onTap;

  const NodeWidget({
    super.key,
    required this.node,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scale = node.getScale();
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFFEF2929) : const Color(0xFF222222),
            width: 5,
          ),
        ),
        child: Center(
          child: Text(
            node.getId() ?? scale?.getSymbol() ?? '•',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}