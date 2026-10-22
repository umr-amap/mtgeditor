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
    this._descriptions?.removeWhere((d) => d.getOperation() == description.getOperation());
  }

  void addNode(MTGNode node) {
    this._nodes ??= {};
    this._nodes![node.getId()!] = node;
  }

  void supNode(MTGNode node) {
    this._nodes?.remove(node.getId()!);
  }

  MTGNode? getNodeById(String id) {
    return this._nodes?[id];
  }

  MTGNode? getNode(MTGNode node) {
    return this._nodes?[node.getId()!];
  }
}
