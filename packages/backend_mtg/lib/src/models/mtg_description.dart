import './mtg_scale.dart' ;

/// Décrit une relation entre des échelles MTG et l'opération qui les relie.
class MTGDescription {
  List<MTGScale>? _parents;
  List<MTGScale>? _enfants;
  String? _operation;
  int? _limite;

  /// Crée une description avec ses échelles parentes, ses enfants, son
  /// opération et sa limite, tous facultatifs.
  MTGDescription({List<MTGScale>? parents, List<MTGScale>? enfants, String? operation, int? limite}){
    this._parents = parents;
    this._enfants = enfants;
    this._operation = operation;
    this._limite = limite;
  }

  /// Renvoie les échelles parentes de cette description.
  List<MTGScale>? getParents() => this._parents;

  /// Remplace la liste des échelles parentes.
  setParents(List<MTGScale>? value) => this._parents = value;

  /// Renvoie les échelles enfants de cette description.
  List<MTGScale>? getEnfants() => this._enfants;

  /// Remplace la liste des échelles enfants.
  setEnfants(List<MTGScale>? value) => this._enfants = value;

  /// Renvoie l'opération décrite.
  String? getOperation() => this._operation;

  /// Définit l'opération décrite.
  setOperation(String? value) => this._operation = value;

  /// Renvoie la limite associée à l'opération.
  int? getLimite() => this._limite;

  /// Définit la limite associée à l'opération.
  setLimite(int? value) => this._limite = value;

  /// Ajoute une échelle à la liste des parents, en créant la liste si besoin.
  void addParent(MTGScale parent) {
    this._parents ??= [];
    this._parents!.add(parent);
  }

  /// Supprime les parents ayant le même symbole que [parent].
  void supParent(MTGScale parent) {
    this._parents?.removeWhere((p) => p.getSymbol() == parent.getSymbol());
  }

  /// Ajoute une échelle à la liste des enfants, en créant la liste si besoin.
  void addEnfant(MTGScale enfant) {
    this._enfants ??= [];
    this._enfants!.add(enfant);
  }

  /// Supprime les enfants ayant le même symbole que [enfant].
  void supEnfant(MTGScale enfant) {
    this._enfants?.removeWhere((e) => e.getSymbol() == enfant.getSymbol());
  }
}
