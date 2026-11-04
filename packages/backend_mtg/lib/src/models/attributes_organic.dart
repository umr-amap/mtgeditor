/// Regroupe les attributs associés à un matériau organique.
class AttributesOrganic {
  String? id;
  String? name;
  String? description;

  /// Crée un matériau organique avec son [id], son [name] et sa [description].
  AttributesOrganic(String? id, String? name, String? description) {
    this.id = id;
    this.name = name;
    this.description = description;
  }

  /// Renvoie l'identifiant de ce matériau organique.
  String? getId() => id;

  /// Définit l'identifiant de ce matériau organique à [id].
  void setId(String? id) => this.id = id;

  /// Renvoie le nom de ce matériau organique.
  String? getName() => name;

  /// Définit le nom de ce matériau organique à [name].
  void setName(String? name) => this.name = name;

  /// Renvoie la description de ce matériau organique.
  String? getDescription() => description;

  /// Définit la description de ce matériau organique à [description].
  void setDescription(String? description) => this.description = description;
}