// Web 平台实现：使用 dart:html 监听 postMessage

import 'dart:html' as html;

import 'package:flutter/material.dart';

import '../provider/theme_mode_provider.dart';

// 静态变量，用于确保只设置一次监听器
bool _listenerSetup = false;

/// Web 平台的主题模式监听器实现
void setupThemeModeListener(ThemeModeProvider themeModeProvider) {
  // 只设置一次监听器
  if (_listenerSetup) return;
  _listenerSetup = true;

  // 监听来自父窗口的 postMessage
  html.window.onMessage.listen((event) {
    if (event.data is Map) {
      final data = event.data as Map;
      if (data['type'] == 'theme-mode-change') {
        final themeMode = data['themeMode'] as String?;
        if (themeMode == 'dark') {
          themeModeProvider.themeMode = ThemeMode.dark;
        } else if (themeMode == 'light') {
          themeModeProvider.themeMode = ThemeMode.light;
        }
      }
    }
  });
}

