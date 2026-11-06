import './mtg_node.dart' ;
import './mtg_scale.dart' ;
import './mtg_description.dart' ;

class MTGTree {
  List<MTGScale>? _scales;
  MTGNode? _root;
  Map<String, MTGNode>? _nodes;
  List<MTGDescription>? _descriptions;

  MTGTree({List<MTGScale>? scales, MTGNode? root, Map<String, MTGNode>? nodes, List<MTGDescription>? description}){
    this._scales = scales;
    this._root = root;
    this._nodes = nodes;
    this._descriptions = description;
  }

  List<MTGScale>? getScales() => this._scales;
  setScale(List<MTGScale>? value) => this._scales = value;

  MTGNode? getRoot() => this._root;
  setRoot(MTGNode? value) => this._root = value;

  Map<String, MTGNode>? getNodes() => this._nodes;
  setNodes(Map<String, MTGNode>? value) => this._nodes = value;

  List<MTGDescription>? getDescriptions() => this._descriptions;
  setDescriptions(List<MTGDescription>? value) => this._descriptions = value;

  addScale(MTGScale scale) {
    this._scales ??= [];
    this._scales!.add(scale);
  }

  void supScale(MTGScale scale) {
    this._scales?.removeWhere((s) => s.getSymbol() == scale.getSymbol());
  }

  void addDescription(MTGDescription description) {
    this._descriptions ??= [];
    this._descriptions!.add(description);
  }

  void supDescription(MTGDescription description) {
    _descriptions?.removeWhere((d) {
      if (d.getOperation() != description.getOperation()) return false;

      final parentsD = d.getParents()?.map((p) => p.getSymbol()).toSet() ?? {};
      final parentsCible = description.getParents()?.map((p) => p.getSymbol()).toSet() ?? {};
      if (!parentsD.containsAll(parentsCible) || parentsD.length != parentsCible.length) return false;

      final enfantsD = d.getEnfants()?.map((e) => e.getSymbol()).toSet() ?? {};
      final enfantsCible = description.getEnfants()?.map((e) => e.getSymbol()).toSet() ?? {};
      return enfantsD.containsAll(enfantsCible) && enfantsD.length == enfantsCible.length;
    });
  }

  void addNode(MTGNode node) {
    final id = node.getId();
    if (id != null) {
      this._nodes ??= {};
      this._nodes![id] = node;
    }
  }

  void attachNode({
    required MTGNode node,
    MTGNode? parent,
    String? connexion,
  }) {
    if (parent != null) {
      parent.addDescendant(node, connexion: connexion);
    } else if (_root == null) {
      _root = node;
    }

    addNode(node);
  }

  void supNode(MTGNode node) {
    // 1. Suppression récursive de tous les descendants (coupe de la branche)
    final descendants = List<MTGNode>.from(node.getDescendants() ?? []);
    for (final enfant in descendants) {
      supNode(enfant);
    }

    // 2. Nettoyage de la référence chez le parent
    node.getParent()?.supDescendant(node);

    // 3. Réinitialisation de la racine si le nœud supprimé était la base
    if (_root?.getId() == node.getId()) {
      _root = null;
    }

    // 4. Retrait de l'index global
    if (node.getId() != null) {
      _nodes?.remove(node.getId());
    }
  }

  void supNodeById(String id) {
    final node = getNodeById(id);
    if (node != null) {
      supNode(node);
    }
  }

  MTGNode? getNodeById(String id) {
    return this._nodes?[id];
  }

  MTGNode? getNode(MTGNode node) {
    return this._nodes?[node.getId()!];
  }
}
