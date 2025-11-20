import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumProvider with ChangeNotifier {
  static const _key = 'is_premium';
  bool isPremium = false;

  Future<void> loadPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isPremium = prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  Future<void> setPremium({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
    isPremium = value;
    notifyListeners();
  }
}
