import 'package:backend_mtg/backend_mtg.dart';
  import 'package:flutter/material.dart';
import 'package:mtg_editor/features/liste_plantes/screens/list_plantes_screen.dart';
import 'package:mtg_editor/features/topologie/screens/topology_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MTG Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: TopologyScreen(tree: _exampleTree()),
    );
  }
}

MTGTree _exampleTree() {
  final scale = MTGScale(symbol: 'M');
  final root = MTGNode(id: 'P', scale: scale);
  final trunk = MTGNode(id: 'Métamère 1', scale: scale, connexion: '<');
  final branch = MTGNode(id: 'Métamère 2', scale: scale, connexion: '+');
  root.addDescendant(trunk, connexion: '<');
  root.addDescendant(branch, connexion: '+');

  return MTGTree(
    root: root,
    nodes: {'P': root, 'Métamère 1': trunk, 'Métamère 2': branch},
  );
}
