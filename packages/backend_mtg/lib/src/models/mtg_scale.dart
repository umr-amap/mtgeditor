
/// Représente une échelle MTG par son niveau et son symbole.
class MTGScale {
    int? _echelle;
    String? _symbol;
    

    /// Crée une échelle avec un niveau et un symbole éventuellement absents.
    MTGScale({int? echelle, String? symbol}){
        this._echelle = echelle;
        this._symbol = symbol;
    }

    /// Renvoie le niveau de l'échelle.
    int? getEchelle() => this._echelle;

    /// Définit le niveau de l'échelle.
    setEchelle(int? value) => this._echelle = value;

    /// Renvoie le symbole de l'échelle.
    String? getSymbol() => this._symbol;

    /// Définit le symbole de l'échelle.
    setSymbol(String? value) => this._symbol = value;


}
