import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeProvider extends ChangeNotifier {
  /// 当前主题模式
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    if (_themeMode != themeMode) {
      _themeMode = themeMode;
      notifyListeners();
      _saveThemeMode();
    }
  }

  /// 保存主题模式到SharedPreferences
  Future<void> _saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('setting:theme_mode', _themeMode.index);
  }

  /// 初始化主题模式
  Future<void> initThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt('setting:theme_mode');
    if (themeModeIndex != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (themeMode) => themeMode.index == themeModeIndex,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }
}
