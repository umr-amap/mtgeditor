import './mtg_scale.dart' ;
import './mtg_attribute.dart';

/// Représente un nœud d'un arbre MTG, avec sa relation hiérarchique et ses
/// attributs.
class MTGNode {

  String? _id;
  MTGScale? _scale;
  String? _connexion;
  MTGNode? _parent;
  List<MTGNode>? _descendants;
  Map<MTGAttribute,dynamic>? _attributes;

  /// Crée un nœud avec les informations et les relations éventuellement
  /// fournies.
  MTGNode({String? id, MTGScale? scale, String? connexion, MTGNode? parent, List<MTGNode>? descendants, Map<MTGAttribute,dynamic>? attributes}){
    this._id = id;
    this._scale = scale;
    this._connexion = connexion;
    this._parent = parent;
    this._descendants = descendants;
    this._attributes = attributes;
  }

  /// Renvoie l'identifiant du nœud.
  String? getId() => this._id;

  /// Définit l'identifiant du nœud.
  setId(String? value) => this._id = value;

  /// Renvoie l'échelle à laquelle appartient le nœud.
  MTGScale? getScale() => this._scale;

  /// Définit l'échelle du nœud.
  setScale(MTGScale? value) => this._scale = value;

  /// Renvoie le symbole de connexion avec le parent.
  String? getConnexion() => this._connexion;

  /// Définit le symbole de connexion avec le parent.
  setConnexion(String? value) => this._connexion = value;

  /// Renvoie le parent du nœud, ou `null` si le nœud n'en a pas.
  MTGNode? getParent() => this._parent;

  /// Définit le parent du nœud.
  setParent(MTGNode? value) => this._parent = value;

  /// Renvoie les descendants directs du nœud.
  List<MTGNode>? getDescendants() => this._descendants;

  /// Remplace la liste des descendants directs.
  setDescendants(List<MTGNode>? value) => this._descendants = value;

  /// Indique si le nœud n'a pas de parent(est la racine).
  bool isRoot() => this._parent == null;
  
  /// Indique si le nœud ne possède aucun descendant(est une feuille).
  bool isLeaf() => this._descendants == null || this._descendants!.isEmpty;
 
  /// Ajoute un descendant, définit son parent et, si fourni, sa connexion.
  void addDescendant(MTGNode descendant, {String? connexion}) {
    this._descendants ??= [];
    this._descendants!.add(descendant);

    descendant.setParent(this);
    if(connexion != null){
      descendant.setConnexion(connexion);
    }
  }

  /// Supprime les descendants ayant le même identifiant que [desc].
  void supDescendant(MTGNode desc){
    this._descendants?.removeWhere((descendant) => descendant.getId() == desc.getId());
  }

  /// Renvoie les attributs du nœud et leurs valeurs.
  Map<MTGAttribute,dynamic>? getAttributes() => this._attributes;

  /// Ajoute les entrées de [value] à la map d'attributs si elle existe déjà.
  setAttributes(Map<MTGAttribute,dynamic>? value) => this._attributes?.addAll(value!);

  /// Ajoute [attribute] à la map d'attributs avec une valeur nulle, si cette
  /// map a déjà été initialisée.
  void addAttribute(MTGAttribute attribute) {
      this._attributes?[attribute]=null;
  }

  /// Vérifie que le type déclaré de [attribute] correspond au type d'exécution
  /// de [value], puis associe cette valeur à l'attribut.
  ///
  /// Lève une [FormatException] lorsque les types comparés diffèrent.
  void addvalue(MTGAttribute attribute,dynamic value){
    if(attribute.type!=value.runtimeType){
      throw FormatException("pas le bon type de valeur");
    }else{
      this._attributes?[attribute]=value;
    }
  }

  /// Supprime [attribute] de la map d'attributs si elle existe.
  void supAttribute(MTGAttribute attribute) {
      this._attributes?.remove(attribute);
  }

}
