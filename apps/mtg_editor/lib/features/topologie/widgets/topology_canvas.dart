import 'package:material_ui/material_ui.dart';
import 'package:backend_mtg/backend_mtg.dart';
import '../controllers/topology_controller.dart';
import '../painters/topology_painter.dart';
import 'node_widget.dart';

class TopologyCanvas extends StatelessWidget {
  final TopologyController controller;
  final ValueChanged<MTGNode> onNodeTap;

  const TopologyCanvas({
    super.key,
    required this.controller,
    required this.onNodeTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final nodes = controller.nodes;
        return InteractiveViewer(
          constrained: false,
          boundaryMargin: const EdgeInsets.all(500),
          minScale: 0.35,
          maxScale: 2.5,
          child: SizedBox(
            width: controller.canvasWidth,
            height: controller.canvasHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: TopologyPainter(
                      nodes: nodes,
                      positions: controller.positions,
                    ),
                  ),
                ),
                for (final node in nodes)
                  if (node.getId() != null)
                    if (controller.positions[node.getId()] case final position?)
                      Positioned(
                        left: position.dx,
                        top: position.dy,
                        child: NodeWidget(
                          node: node,
                          selected: controller.selectedNodeId == node.getId(),
                          onTap: () => onNodeTap(node),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
