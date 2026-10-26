import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeProvider extends ChangeNotifier {
  /// 当前主题模式
  ThemeMode _themeMode = ThemeMode.system;
  int _themeModeRevision = 0;
  bool _disposed = false;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    _themeModeRevision++;
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
    final revision = _themeModeRevision;
    final prefs = await SharedPreferences.getInstance();
    if (_disposed || revision != _themeModeRevision) {
      return;
    }
    final themeModeIndex = prefs.getInt('setting:theme_mode');
    if (themeModeIndex != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (themeMode) => themeMode.index == themeModeIndex,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
