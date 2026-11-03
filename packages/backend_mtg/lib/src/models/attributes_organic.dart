class AttributesOrganic {
  String? id;
  String? name;
  String? description;

  AttributesOrganic(String? id, String? name, String? description) {
    this.id = id;
    this.name = name;
    this.description = description;
  }

  String? getId() => id;
  void setId(String? id) => this.id = id;

  String? getName() => name;
  void setName(String? name) => this.name = name;

  String? getDescription() => description;
  void setDescription(String? description) => this.description = description;
}