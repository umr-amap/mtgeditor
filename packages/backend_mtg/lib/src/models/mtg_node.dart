import './mtg_scale.dart' ;

class MTGNode {

  String? _id;
  MTGScale? _scale;
  String? _connexion;
  MTGNode? _parent;
  List<MTGNode>? _descendants;

  MTGNode({String? id, MTGScale? scale, String? connexion, MTGNode? parent, List<MTGNode>? descendants}){
    this._id = id;
    this._scale = scale;
    this._connexion = connexion;
    this._parent = parent;
    this._descendants = descendants;
  }

  String? getId() => this._id;
  setId(String? value) => this._id = value;

  MTGScale? getScale() => this._scale;
  setScale(MTGScale? value) => this._scale = value;

  String? getConnexion() => this._connexion;
  setConnexion(String? value) => this._connexion = value;

  MTGNode? getParent() => this._parent;
  setParent(MTGNode? value) => this._parent = value;

  List<MTGNode>? getDescendants() => this._descendants;
  setDescendants(List<MTGNode>? value) => this._descendants = value;

  bool isRoot() => this._parent == null;
  
  bool isLeaf() => this._descendants == null || this._descendants!.isEmpty;
 
  void addDescendant(MTGNode descendant) {
    this._descendants ??= [];
    this._descendants!.add(descendant);
  }

}
