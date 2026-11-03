import 'mtg_tree.dart';
import 'attributes_organic.dart';

/// Représente un élément organique avec sa localisation et ses données associées.
class Organic {

  String? tag;
  double? longitude;
  double? latitude;
  List<String>? imagesUrls = [];
  List<MTGTree>? mtgTrees = [];
  Map<String, AttributesOrganic>? attributes = {};

  /// Crée un élément organique avec son identifiant, sa position et ses données.
  Organic(String tag, double? longitude, double? latitude, List<String>? imagesUrls, List<MTGTree>? mtgTrees, Map<String, AttributesOrganic>? attributes) {
    this.tag = tag;
    this.longitude = longitude;
    this.latitude = latitude;
    this.imagesUrls = imagesUrls;
    this.mtgTrees = mtgTrees;
    this.attributes = attributes;
  }

  /// Renvoie l'identifiant de cet élément organique.
  String? getTag() => tag;

  /// Définit l'identifiant de cet élément organique à [tag].
  void setTag(String? tag) => this.tag = tag;

  /// Renvoie la longitude de cet élément organique.
  double? getLongitude() => longitude;

  /// Définit la longitude de cet élément organique à [longitude].
  void setLongitude(double? longitude) => this.longitude = longitude;

  /// Renvoie la latitude de cet élément organique.
  double? getLatitude() => latitude;

  /// Définit la latitude de cet élément organique à [latitude].
  void setLatitude(double? latitude) => this.latitude = latitude;

  /// Renvoie la liste des URL des images.
  List<String>? getImagesUrls() => imagesUrls;

  /// Renvoie l'URL de l'image à l'index [index], ou `null` si la liste est nulle.
  String? getImageUrl(int index) => this.imagesUrls?[index];

  /// Remplace la liste des URL des images par [imagesUrls].
  void setImagesUrls(List<String>? imagesUrls) => this.imagesUrls = imagesUrls;

  /// Renvoie la liste des arbres MTG associés.
  List<MTGTree>? getMtgTrees() => mtgTrees;

  /// Renvoie l'arbre MTG à l'index [index], ou `null` si la liste est nulle.
  MTGTree? getMtgTree(int index) => this.mtgTrees?[index];

  /// Remplace la liste des arbres MTG par [mtgTrees].
  void setMtgTrees(List<MTGTree>? mtgTrees) => this.mtgTrees = mtgTrees;

  /// Renvoie les attributs de cet élément organique.
  Map<String, AttributesOrganic>? getAttributes() => attributes;

  /// Renvoie l'attribut associé à [key], ou `null` s'il n'existe pas.
  AttributesOrganic? getAttribute(String key) => this.attributes?[key];

  /// Remplace les attributs par [attributes].
  void setAttributes(Map<String, AttributesOrganic>? attributes) => this.attributes = attributes;

  /// Ajoute [imageUrl] à la liste des URL d'images.
  void addImageUrl(String imageUrl) {
    this.imagesUrls ??= [];
    this.imagesUrls!.add(imageUrl);
  }

  /// Supprime de la liste toutes les occurrences de [imageUrl].
  void supImageUrl(String imageUrl) {
    this.imagesUrls?.removeWhere((url) => url == imageUrl);
  }

  /// Ajoute [mtgTree] à la liste des arbres MTG.
  void addMtgTree(MTGTree mtgTree) {
    this.mtgTrees ??= [];
    this.mtgTrees!.add(mtgTree);
  }

  /// Supprime l'arbre dont la racine a le même identifiant que celle de [mtgTree].
  void supMtgTree(MTGTree mtgTree) {
    this.mtgTrees?.removeWhere((tree) => tree.getRoot()?.getId() == mtgTree.getRoot()?.getId());
  }

  /// Crée ou remplace l'attribut [key] avec son [name] et sa [description].
  void addAttribute(String key, String? name, String? description) {
    this.attributes ??= {};
    this.attributes![key] = AttributesOrganic(key, name, description);
  }

  /// Supprime l'attribut associé à [key].
  void supAttribute(String key) {
    this.attributes?.remove(key);
  }
  
  
}