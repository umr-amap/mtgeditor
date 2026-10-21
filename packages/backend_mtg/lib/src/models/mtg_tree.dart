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
}
