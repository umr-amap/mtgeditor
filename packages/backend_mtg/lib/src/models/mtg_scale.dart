import './mtg_attribute.dart';

class MTGScale {
    int? _echelle;
    String? _symbol;
    List<MTGAttribute>? _attributes;

    MTGScale({int? echelle, String? symbol, List<MTGAttribute>? attributes}){
        this._echelle = echelle;
        this._symbol = symbol;
        this._attributes = attributes;
    }

    int? getEchelle() => this._echelle;
    setEchelle(int? value) => this._echelle = value;

    String? getSymbol() => this._symbol;
    setSymbol(String? value) => this._symbol = value;

    List<MTGAttribute>? getAttributes() => this._attributes;
    setAttributes(List<MTGAttribute>? value) => this._attributes = value;
}
