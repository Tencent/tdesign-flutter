// Web 平台实现：使用 dart:html 监听 postMessage

import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../provider/theme_mode_provider.dart';

// 静态变量，用于确保只设置一次监听器
bool _listenerSetup = false;

// 主题更新回调
Function(TDThemeData)? _onThemeUpdate;

/// Web 平台的主题模式监听器实现
void setupThemeModeListener(ThemeModeProvider themeModeProvider, {Function(TDThemeData)? onThemeUpdate}) {
  // 保存回调
  _onThemeUpdate = onThemeUpdate;

  // 只设置一次监听器
  if (_listenerSetup) return;
  _listenerSetup = true;

  // 监听来自父窗口的 postMessage
  html.window.onMessage.listen((event) {
    if (event.data is Map) {
      final data = event.data as Map;
      final type = data['type'] as String?;

      // 处理主题模式变化 (亮色/暗色)
      if (type == 'theme-mode-change') {
        final themeMode = data['themeMode'] as String?;
        if (themeMode == 'dark') {
          themeModeProvider.themeMode = ThemeMode.dark;
        } else if (themeMode == 'light') {
          themeModeProvider.themeMode = ThemeMode.light;
        }
      }

      // 处理主题配置更新 (颜色等)
      if (type == 'flutter-theme-update') {
        _handleThemeUpdate(data['theme']);
      }
    }
  });
}

/// 处理主题配置更新
void _handleThemeUpdate(dynamic themeData) {
  if (themeData == null || _onThemeUpdate == null) return;

  try {
    // 构建 theme.json 格式
    // TDThemeData.fromJson 期望的格式:
    // {
    //   "custom": {
    //     "color": {...},
    //     "ref": {...},
    //     "font": {...},
    //     "radius": {...},
    //     "shadow": {...},
    //     "margin": {...}
    //   },
    //   "customDark": {
    //     "color": {...},
    //     "ref": {...},
    //     "font": {...},
    //     "radius": {...},
    //     "shadow": {...},
    //     "margin": {...}
    //   }
    // }
    final themeJson = {
      'custom': themeData['light'],
      'customDark': themeData['dark'],
    };

    final jsonString = jsonEncode(themeJson);
    
    // 调试输出
    print('🎨 Flutter: 收到主题更新消息');
    print('📊 Light主题颜色数量: ${themeData['light']?['color']?.length ?? 0}');
    print('📊 Dark主题颜色数量: ${themeData['dark']?['color']?.length ?? 0}');
    print('📊 Light主题引用数量: ${themeData['light']?['ref']?.length ?? 0}');
    print('📊 Dark主题引用数量: ${themeData['dark']?['ref']?.length ?? 0}');
    print('📊 Light主题字体数量: ${themeData['light']?['font']?.length ?? 0}');
    print('📊 Dark主题字体数量: ${themeData['dark']?['font']?.length ?? 0}');

    // 解析为 TDThemeData
    final newTheme = TDThemeData.fromJson('custom', jsonString);

    // 触发回调 (检查非空)
    if (newTheme != null) {
      _onThemeUpdate?.call(newTheme);
      print('✅ Flutter: 成功应用新主题配置');
      
      // 调试输出新主题信息
      print('🎯 新主题名称: ${newTheme.name}');
      print('🎯 Light主题颜色数量: ${newTheme.colorMap.length}');
      print('🎯 Dark主题颜色数量: ${newTheme.dark?.colorMap.length ?? 0}');
      print('🎯 引用映射数量: ${newTheme.refMap.length}');
    } else {
      print('⚠️ Flutter: 主题解析返回 null');
      print('❌ 请检查JSON格式是否正确，特别是颜色值格式');
    }
  } catch (e) {
    print('❌ Flutter: 主题解析失败: $e');
    print('❌ 错误详情: ${e.toString()}');
  }
}

