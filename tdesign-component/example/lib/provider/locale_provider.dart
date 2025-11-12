import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  /// 当前语言设置
  Locale _locale = const Locale('zh');

  Locale get locale => _locale;

  set locale(Locale locale) {
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();
      asyncPrefs.setString('setting:locale', locale.languageCode);
    }
  }

  /// 切换语言
  void toggleLocale() {
    locale = _locale.languageCode == 'zh' ? const Locale('en') : const Locale('zh');
  }

  /// 设置特定语言
  void setLocale(String languageCode) {
    locale = Locale(languageCode);
  }

  /// 初始化语言设置
  Future<void> initLocale() async {
    final languageCode = await asyncPrefs.getString('setting:locale');
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  /// 获取当前语言显示名称
  String get currentLanguageName {
    return _locale.languageCode == 'en' ? 'English' : '中文';
  }
}

/// SharedPreferences的异步封装
class SharedPreferencesAsync {
  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  Future<void> setString(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  Future<void> setInt(String key, int value) async {
    final prefs = await _prefs;
    await prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    final prefs = await _prefs;
    return prefs.getInt(key);
  }
}