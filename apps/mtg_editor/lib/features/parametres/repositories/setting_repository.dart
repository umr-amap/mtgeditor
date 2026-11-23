import 'package:shared_preferences/shared_preferences.dart';

/// Repository Pattern: Pattern optimisant le front (évite de mettre des StatefulWidget sur toute les pages)
class SettingRepository{
  static const THEME_KEY = "darkMode";
  saveSettings(bool value) async {
    SharedPreferences sharedPreferences = await
    SharedPreferences.getInstance();
    sharedPreferences.setBool(THEME_KEY, value);
  }
  /// Récupère l'instance local de la page
  Future<bool> getSettings() async {
    SharedPreferences sharedPreferences = await
    SharedPreferences.getInstance();
    return sharedPreferences.getBool(THEME_KEY) ?? false;
  }
}