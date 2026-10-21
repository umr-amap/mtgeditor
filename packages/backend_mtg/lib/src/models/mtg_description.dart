import './mtg_scale.dart' ;

class MTGDescription {
  List<MTGScale>? _parents;
  List<MTGScale>? _enfants;
  String? _operation;
  int? _limite;

  MTGDescription({List<MTGScale>? parents, List<MTGScale>? enfants, String? operation, int? limite}){
    this._parents = parents;
    this._enfants = enfants;
    this._operation = operation;
    this._limite = limite;
  }

  List<MTGScale>? getParents() => this._parents;
  setParents(List<MTGScale>? value) => this._parents = value;

  List<MTGScale>? getEnfants() => this._enfants;
  setEnfants(List<MTGScale>? value) => this._enfants = value;

  String? getOperation() => this._operation;
  setOperation(String? value) => this._operation = value;

  int? getLimite() => this._limite;
  setLimite(int? value) => this._limite = value;

  addParent(MTGScale parent) {
    this._parents ??= [];
    this._parents!.add(parent);
  }

  supParent(MTGScale parent) {
    this._parents?.removeWhere((p) => p.getSymbol() == parent.getSymbol());
  }

  addEnfant(MTGScale enfant) {
    this._enfants ??= [];
    this._enfants!.add(enfant);
  }

  supEnfant(MTGScale enfant) {
    this._enfants?.removeWhere((e) => e.getSymbol() == enfant.getSymbol());
  }
}
