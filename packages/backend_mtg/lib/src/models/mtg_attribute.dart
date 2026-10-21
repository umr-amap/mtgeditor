enum MTGAttributeType { Bool, Int, Date, String }

class MTGAttribute {
  final String name;
  final MTGAttributeType type;

  MTGAttribute({required this.name, required this.type});
}
