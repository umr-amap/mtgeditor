import './mtg_node.dart' ;
import './mtg_scale.dart' ;
import './mtg_description.dart' ;

/// Regroupe les échelles, descriptions et nœuds d'un modèle MTG.
class MTGTree {
  String? _id;
  List<MTGScale>? _scales;
  MTGNode? _root;
  Map<String, MTGNode>? _nodes;
  List<MTGDescription>? _descriptions;

  MTGTree({List<MTGScale>? scales, MTGNode? root, Map<String, MTGNode>? nodes, List<MTGDescription>? description, String?  id}){
    this._scales = scales;
    this._root = root;
    this._nodes = nodes;
    this._descriptions = description;
    this._id=id;
  }
  String? getId() => this._id;
  setId(String? value) => this._id = value;

  /// Renvoie les échelles de l'arbre.
  List<MTGScale>? getScales() => this._scales;

  /// Remplace la liste des échelles.
  setScale(List<MTGScale>? value) => this._scales = value;

  /// Renvoie le nœud racine de l'arbre.
  MTGNode? getRoot() => this._root;

  /// Définit le nœud racine de l'arbre.
  setRoot(MTGNode? value) => this._root = value;

  /// Renvoie l'index des nœuds, associant chaque identifiant à son nœud.
  Map<String, MTGNode>? getNodes() => this._nodes;

  /// Remplace l'index des nœuds.
  setNodes(Map<String, MTGNode>? value) => this._nodes = value;

  /// Renvoie les descriptions des relations entre échelles.
  List<MTGDescription>? getDescriptions() => this._descriptions;

  /// Remplace la liste des descriptions.
  setDescriptions(List<MTGDescription>? value) => this._descriptions = value;

  /// Ajoute une échelle à la liste, en créant celle-ci si besoin.
  addScale(MTGScale scale) {
    this._scales ??= [];
    this._scales!.add(scale);
  }

  /// Supprime les échelles ayant le même symbole que [scale].
  void supScale(MTGScale scale) {
    this._scales?.removeWhere((s) => s.getSymbol() == scale.getSymbol());
  }

  /// Ajoute une description à la liste, en créant celle-ci si besoin.
  void addDescription(MTGDescription description) {
    this._descriptions ??= [];
    this._descriptions!.add(description);
  }

  /// Supprime les descriptions ayant la même opération et les mêmes ensembles
  /// d'échelles parentes et enfants que [description].
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

  /// Ajoute [node] à l'index global s'il possède un identifiant.
  void addNode(MTGNode node) {
    final id = node.getId();
    if (id != null) {
      this._nodes ??= {};
      this._nodes![id] = node;
    }
  }

  /// Rattache [node] à [parent], ou en fait la racine si aucune racine n'existe,
  /// puis l'ajoute à l'index global.
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

  /// Supprime récursivement [node] et ses descendants de l'arbre et de l'index.
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

  /// Recherche puis supprime le nœud d'identifiant [id], s'il existe.
  void supNodeById(String id) {
    final node = getNodeById(id);
    if (node != null) {
      supNode(node);
    }
  }

  /// Renvoie le nœud associé à [id], ou `null` s'il est absent de l'index.
  MTGNode? getNodeById(String id) {
    return this._nodes?[id];
  }

  /// Recherche dans l'index le nœud ayant le même identifiant que [node].
  MTGNode? getNode(MTGNode node) {
    return this._nodes?[node.getId()!];
  }
}
