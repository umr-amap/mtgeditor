enum MTGAttributeType { Bool, Int, Date, String }

class MTGAttribute {
  String? name;
  MTGAttributeType? type;

  MTGAttribute({String? name, MTGAttributeType? type}) {
    this.name = name;
    this.type = type;
  }

  String? getName() => this.name;
  setName(String? value) => this.name = value;

  MTGAttributeType? getType() => this.type;
  setType(MTGAttributeType? value) => this.type = value;
}
