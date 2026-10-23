import 'dart:ui';

import 'package:backend_mtg/src/models/mtg_tree.dart';
import 'package:backend_mtg/src/models/mtg_node.dart';
import 'package:backend_mtg/src/models/mtg_scale.dart';
import 'package:backend_mtg/src/models/mtg_attribute.dart';
import 'package:flutter/cupertino.dart';


class TopologyController extends ChangeNotifier{
  final MTGTree tree;
  String? selectedNode;
  Map<int, Offset> positions = {};

  TopologyController({required this.tree});

  void addNode({
    required MTGNode node,
    required Offset position,
    MTGNode? parent,
    String? connexion,
  }){

  }

}