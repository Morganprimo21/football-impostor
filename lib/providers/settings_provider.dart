import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const _soundKey = 'sounds_enabled';

  bool soundsEnabled = true;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    soundsEnabled = prefs.getBool(_soundKey) ?? true;
    notifyListeners();
  }

  Future<void> setSoundsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    soundsEnabled = value;
    await prefs.setBool(_soundKey, value);
    notifyListeners();
  }
}


