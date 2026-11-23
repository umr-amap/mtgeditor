import 'package:flutter/material.dart';
import '../repositories/setting_repository.dart';
// View Model: Fait la connexion entre Model et Views (Repository)
class SettingViewModel extends ChangeNotifier {
  late bool _isDark;
  late SettingRepository _settingRepository;

  bool get isDark => _isDark;

  SettingViewModel() {
    _isDark = false;
    _settingRepository = SettingRepository();
    getSettings();
  }
  // change la couleur
  set isDark(bool value) {
    _isDark = value;
    _settingRepository.saveSettings(value);
    notifyListeners();
  }

  Future<void> getSettings() async {
    _isDark = await _settingRepository.getSettings();
    notifyListeners();
  }
}