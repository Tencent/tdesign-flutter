// Web 平台实现：使用 dart:html 监听 postMessage
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../provider/theme_mode_provider.dart';
import 'web_theme_message.dart';

bool _listenerSetup = false;
ValueChanged<TThemeData>? _onThemeUpdate;

/// Web 平台的主题模式与 Token 监听器实现。
void setupThemeModeListener(
  ThemeModeProvider themeModeProvider, {
  ValueChanged<TThemeData>? onThemeUpdate,
}) {
  _onThemeUpdate = onThemeUpdate;
  if (_listenerSetup) {
    return;
  }
  _listenerSetup = true;

  html.window.onMessage.listen((event) {
    if (event.origin != html.window.location.origin) {
      return;
    }
    final data = decodeWebThemeMessageData(event.data);
    if (data is! Map) {
      return;
    }
    final theme = parseWebThemeUpdateMessage(data);
    if (theme == null) {
      return;
    }
    final themeMode = parseWebThemeMode(data);
    if (themeMode != null) {
      themeModeProvider.themeMode = themeMode;
    }
    _onThemeUpdate?.call(theme);
  });
}
