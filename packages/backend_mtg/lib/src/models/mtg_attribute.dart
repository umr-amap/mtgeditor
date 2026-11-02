/// Types de valeurs pouvant être associés aux attributs d'un nœud MTG.
enum MTGAttributeType { Bool, Int, Date, String, double }

/// Décrit un attribut et le type de valeur qui lui est associé.
class MTGAttribute {
  String? name;
  MTGAttributeType? type;

  /// Crée un attribut avec un nom et un type éventuellement absents.
  MTGAttribute({String? name, MTGAttributeType? type}) {
    this.name = name;
    this.type = type;
  }

  /// Renvoie le nom de l'attribut.
  String? getName() => this.name;

  /// Définit le nom de l'attribut.
  setName(String? value) => this.name = value;

  /// Renvoie le type de l'attribut.
  MTGAttributeType? getType() => this.type;

  /// Définit le type de l'attribut.
  setType(MTGAttributeType? value) => this.type = value;
}
