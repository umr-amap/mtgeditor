import 'package:backend_mtg/backend_mtg.dart';
import 'package:material_ui/material_ui.dart';

class TopologyPainter extends CustomPainter {
  final List<MTGNode> nodes;
  final Map<String, Offset> positions;

  const TopologyPainter({required this.nodes, required this.positions});

  @override
  void paint(Canvas canvas, Size size) {
    final edgePaint = Paint()
      ..color = const Color(0xFF222222)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final labelPainter = TextPainter(textDirection: TextDirection.ltr);

    for (final node in nodes) {
      final parent = node.getParent();
      final id = node.getId();
      final parentId = parent?.getId();
      if (id == null || parentId == null) continue;

      final start = positions[parentId];
      final end = positions[id];
      if (start == null || end == null) continue;

      final startPoint = start + const Offset(38, 0);
      final endPoint = end + const Offset(38, 76);
      final middleY = (startPoint.dy + endPoint.dy) / 2;
      final path = Path()
        ..moveTo(startPoint.dx, startPoint.dy)
        ..cubicTo(
          startPoint.dx,
          middleY,
          endPoint.dx,
          middleY,
          endPoint.dx,
          endPoint.dy,
        );
      canvas.drawPath(path, edgePaint);

      final direction = (endPoint - startPoint);
      final length = direction.distance;
      if (length > 0) {
        final unit = direction / length;
        final arrowBase = endPoint - unit * 8;
        final perpendicular = Offset(-unit.dy, unit.dx) * 5;
        canvas.drawLine(arrowBase + perpendicular, endPoint, edgePaint);
        canvas.drawLine(arrowBase - perpendicular, endPoint, edgePaint);
      }

      final connexion = node.getConnexion();
      if (connexion != null && connexion.isNotEmpty) {
        labelPainter.text = TextSpan(
          text: connexion,
          style: const TextStyle(
            color: Color(0xFF475467),
            fontSize: 12,
            backgroundColor: Colors.white,
          ),
        );
        labelPainter.layout();
        labelPainter.paint(
          canvas,
          Offset(endPoint.dx + 16, middleY - labelPainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant TopologyPainter oldDelegate) =>
      oldDelegate.nodes != nodes || oldDelegate.positions != positions;
}
