import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  bool _isDarkTheme = false;
  double _fontSize = 16.0;

  bool get isDarkTheme => _isDarkTheme;
  double get fontSize => _fontSize;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    _fontSize = (prefs.getDouble('fontSize') ?? 16.0).clamp(12.0, 24.0);
    notifyListeners();
  }

  Future<void> updateTheme(bool value) async {
    _isDarkTheme = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', value);
    notifyListeners();
  }

  Future<void> updateFontSize(double size) async {
    _fontSize = size.clamp(12.0, 24.0);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', _fontSize);
    notifyListeners();
  }
}
