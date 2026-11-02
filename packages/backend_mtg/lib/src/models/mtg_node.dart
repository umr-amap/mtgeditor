import './mtg_scale.dart' ;
import './mtg_attribute.dart';

class MTGNode {

  String? _id;
  MTGScale? _scale;
  String? _connexion;
  MTGNode? _parent;
  List<MTGNode>? _descendants;
  Map<MTGAttribute,dynamic>? _attributes;
  MTGNode({String? id, MTGScale? scale, String? connexion, MTGNode? parent, List<MTGNode>? descendants, Map<MTGAttribute,dynamic>? attributes}){
    this._id = id;
    this._scale = scale;
    this._connexion = connexion;
    this._parent = parent;
    this._descendants = descendants;
    this._attributes = attributes;
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
 
  void addDescendant(MTGNode descendant, {String? connexion}) {
    this._descendants ??= [];
    this._descendants!.add(descendant);

    descendant.setParent(this);
    if(connexion != null){
      descendant.setConnexion(connexion);
    }
  }

  void supDescendant(MTGNode desc){
    this._descendants?.removeWhere((descendant) => descendant.getId() == desc.getId());
  }

  Map<MTGAttribute,dynamic>? getAttributes() => this._attributes;
  setAttributes(Map<MTGAttribute,dynamic>? value) => this._attributes?.addAll(value!);

  void addAttribute(MTGAttribute attribute) {
      this._attributes?[attribute]=null;
  }

  void addvalue(MTGAttribute attribute,dynamic value){
    if(attribute.type!=value.runtimeType){
      throw FormatException("pas le bon type de valeur");
    }else{
      this._attributes?[attribute]=value;
    }
  }
  void supAttribute(MTGAttribute attribute) {
      this._attributes?.remove(attribute);
  }

}
