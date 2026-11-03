import 'mtg_tree.dart';
import 'attributes_organic.dart';

class Organic {

  String? tag;
  double? longitude;
  double? latitude;
  List<String>? imagesUrls = [];
  List<MTGTree>? mtgTrees = [];
  Map<String, AttributesOrganic>? attributes = {};

  Organic(String tag, double? longitude, double? latitude, List<String>? imagesUrls, List<MTGTree>? mtgTrees, Map<String, AttributesOrganic>? attributes) {
    this.tag = tag;
    this.longitude = longitude;
    this.latitude = latitude;
    this.imagesUrls = imagesUrls;
    this.mtgTrees = mtgTrees;
    this.attributes = attributes;
  }

  String? getTag() => tag;
  void setTag(String? tag) => this.tag = tag;

  double? getLongitude() => longitude;
  void setLongitude(double? longitude) => this.longitude = longitude;

  double? getLatitude() => latitude;
  void setLatitude(double? latitude) => this.latitude = latitude;

  List<String>? getImagesUrls() => imagesUrls;
  String? getImageUrl(int index) => this.imagesUrls?[index];
  void setImagesUrls(List<String>? imagesUrls) => this.imagesUrls = imagesUrls;

  List<MTGTree>? getMtgTrees() => mtgTrees;
  MTGTree? getMtgTree(int index) => this.mtgTrees?[index];
  void setMtgTrees(List<MTGTree>? mtgTrees) => this.mtgTrees = mtgTrees;

  Map<String, AttributesOrganic>? getAttributes() => attributes;
  AttributesOrganic? getAttribute(String key) => this.attributes?[key];
  void setAttributes(Map<String, AttributesOrganic>? attributes) => this.attributes = attributes;

  void addImageUrl(String imageUrl) {
    this.imagesUrls ??= [];
    this.imagesUrls!.add(imageUrl);
  }

  void supImageUrl(String imageUrl) {
    this.imagesUrls?.removeWhere((url) => url == imageUrl);
  }

  void addMtgTree(MTGTree mtgTree) {
    this.mtgTrees ??= [];
    this.mtgTrees!.add(mtgTree);
  }

  void supMtgTree(MTGTree mtgTree) {
    this.mtgTrees?.removeWhere((tree) => tree.getRoot()?.getId() == mtgTree.getRoot()?.getId());
  }

  void addAttribute(String key, String? name, String? description) {
    this.attributes ??= {};
    this.attributes![key] = AttributesOrganic(key, name, description);
  }
  
  
}