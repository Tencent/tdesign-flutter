import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeProvider extends ChangeNotifier {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  /// 当前主题模式
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    if (_themeMode != themeMode) {
      _themeMode = themeMode;
      notifyListeners(); // 通知监听者语言已改变
      asyncPrefs.setInt('setting:theme_mode', _themeMode.index);
    }
  }

  // 初始化主题模式
  Future<void> initThemeMode() async {
    final themeModeIndex = await asyncPrefs.getInt('setting:theme_mode');
    if (themeModeIndex != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (themeMode) => themeMode.index == themeModeIndex,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }
}
