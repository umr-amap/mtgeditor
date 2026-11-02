import 'dart:ui';

import 'package:backend_mtg/backend_mtg.dart';
import 'package:flutter/foundation.dart';

class TopologyController extends ChangeNotifier {
  static const double nodeWidth = 76;
  static const double nodeHeight = 76;
  static const double horizontalMargin = 100;
  static const double verticalMargin = 104;
  static const double canvasPadding = 140;
  static const double minimumCanvasWidth = 3000;
  static const double minimumCanvasHeight = 3000;

  final MTGTree tree;
  String? selectedNodeId;
  final Map<String, Offset> positions = {};

  TopologyController({required this.tree});

  List<MTGNode> get nodes {
    final result = <MTGNode>[];
    void visit(MTGNode node) {
      result.add(node);
      for (final child in node.getDescendants() ?? <MTGNode>[]) {
        visit(child);
      }
    }

    final root = tree.getRoot();
    if (root != null) visit(root);
    return result;
  }

  MTGNode? get selectedNode {
    final id = selectedNodeId;
    if (id == null) return null;

    for (final node in nodes) {
      if (node.getId() == id) return node;
    }
    return null;
  }

  double get canvasWidth {
    final root = tree.getRoot();
    if (root == null) return minimumCanvasWidth;
    return (_subtreeWidth(root) + canvasPadding * 2).clamp(
      minimumCanvasWidth,
      double.infinity,
    );
  }

  double get canvasHeight {
    final root = tree.getRoot();
    if (root == null) return minimumCanvasHeight;
    return (canvasPadding * 2 +
            (_maxDepth(root) + 1) * (nodeHeight + verticalMargin))
        .clamp(minimumCanvasHeight, double.infinity);
  }

  void layoutNodes({Offset? origin}) {
    positions.clear();
    final root = tree.getRoot();
    if (root == null) return;

    final verticalStep = nodeHeight + verticalMargin;
    final layoutOrigin =
        origin ??
        Offset(
          canvasPadding + _subtreeWidth(root) / 2,
          canvasPadding + _maxDepth(root) * verticalStep,
        );

    double place(MTGNode node, int depth, double left) {
      final children = node.getDescendants() ?? <MTGNode>[];
      final subtreeWidth = _subtreeWidth(node);
      final childrenWidth = children.isEmpty
          ? 0
          : children.fold<double>(
                  0,
                  (total, child) => total + _subtreeWidth(child),
                ) +
                horizontalMargin * (children.length - 1);
      final childrenLeft = left + (subtreeWidth - childrenWidth) / 2;

      var childLeft = childrenLeft;
      for (final child in children) {
        final childWidth = _subtreeWidth(child);
        place(child, depth + 1, childLeft);
        childLeft += childWidth + horizontalMargin;
      }

      final id = node.getId();
      if (id != null) {
        positions[id] = Offset(
          left + (subtreeWidth - nodeWidth) / 2,
          layoutOrigin.dy - depth * verticalStep,
        );
      }
      return subtreeWidth;
    }

    place(root, 0, layoutOrigin.dx - _subtreeWidth(root) / 2);
  }

  int _maxDepth(MTGNode node) {
    final children = node.getDescendants() ?? <MTGNode>[];
    if (children.isEmpty) return 0;
    return 1 + children.map(_maxDepth).reduce((a, b) => a > b ? a : b);
  }

  double _subtreeWidth(MTGNode node) {
    final children = node.getDescendants() ?? <MTGNode>[];
    if (children.isEmpty) return nodeWidth;

    final childrenWidth =
        children.fold<double>(
          0,
          (total, child) => total + _subtreeWidth(child),
        ) +
        horizontalMargin * (children.length - 1);
    return childrenWidth > nodeWidth ? childrenWidth : nodeWidth;
  }

  void selectNode(MTGNode? node) {
    selectedNodeId = node?.getId();
    notifyListeners();
  }

  void moveNode(MTGNode node, Offset position) {
    final id = node.getId();
    if (id == null) return;
    positions[id] = _keepInsideCanvas(position);
    _ensureNoCollisions();
    notifyListeners();
  }

  void _ensureNoCollisions() {
    final placed = <String, Offset>{};
    for (final node in nodes) {
      final id = node.getId();
      final current = id == null ? null : positions[id];
      if (id == null || current == null) continue;

      var candidate = current;
      for (final previous in placed.values) {
        final overlaps =
            candidate.dx < previous.dx + nodeWidth &&
            candidate.dx + nodeWidth > previous.dx &&
            candidate.dy < previous.dy + nodeHeight &&
            candidate.dy + nodeHeight > previous.dy;
        if (overlaps) {
          candidate = Offset(
            previous.dx + nodeWidth + horizontalMargin,
            candidate.dy,
          );
        }
      }
      positions[id] = _keepInsideCanvas(candidate);
      placed[id] = positions[id]!;
    }
  }

  Offset _keepInsideCanvas(Offset position) {
    return Offset(
      position.dx.clamp(canvasPadding, canvasWidth - canvasPadding - nodeWidth),
      position.dy.clamp(
        canvasPadding,
        canvasHeight - canvasPadding - nodeHeight,
      ),
    );
  }

  bool addNode({required MTGNode node, MTGNode? parent, String? connexion}) {
    final id = node.getId();
    if (id == null) {
      return false;
    }
    if (parent == null && tree.getRoot() != null) {
      return false;
    }
    if (nodes.any((existingNode) => existingNode.getId() == id)) {
      return false;
    }

    tree.attachNode(node: node, parent: parent, connexion: connexion);

    layoutNodes();
    notifyListeners();
    return true;
  }

  void removeNode(MTGNode node) {
    final id = node.getId();

    tree.supNode(node);

    if (id != null) {
      positions.remove(id);

      if (selectedNodeId == id) {
        selectedNodeId = null;
      }
    }

    layoutNodes();
    notifyListeners();
  }
}
