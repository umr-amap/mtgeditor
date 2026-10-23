
class MTGScale {
    int? _echelle;
    String? _symbol;
    

    MTGScale({int? echelle, String? symbol}){
        this._echelle = echelle;
        this._symbol = symbol;
    }

    int? getEchelle() => this._echelle;
    setEchelle(int? value) => this._echelle = value;

    String? getSymbol() => this._symbol;
    setSymbol(String? value) => this._symbol = value;


}
