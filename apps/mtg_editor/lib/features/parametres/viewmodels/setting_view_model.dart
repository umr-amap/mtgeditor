import 'package:flutter/material.dart';
import '../repositories/setting_repository.dart';

class SettingViewModel extends ChangeNotifier {
  late bool _isDark;
  late SettingRepository _settingRepository;

  bool get isDark => _isDark;

  SettingViewModel() {
    _isDark = false;
    _settingRepository = SettingRepository();
    getSettings();
  }

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