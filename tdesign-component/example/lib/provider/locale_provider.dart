import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  /// 当前语言设置
  Locale _locale = const Locale('zh');

  Locale get locale => _locale;

  set locale(Locale locale) {
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();
      _saveLocale();
    }
  }

  /// 保存语言设置到SharedPreferences
  Future<void> _saveLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('setting:locale', _locale.languageCode);
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
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('setting:locale');
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