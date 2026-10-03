import 'package:flutter/foundation.dart';

import 'basic.dart';
import 't_theme.dart';

/// 将小程序的 CSS 字体栈转换为当前 Flutter 平台可绘制的字体选择。
/// 保留 Token 原值；非 Apple 平台对默认栈使用 Roboto 作为主字体。
extension TResolvedFontFamily on FontFamily {
  String get flutterFontFamily {
    if (fontFamily == 'PingFang SC' &&
        package == null &&
        listEquals(fallback, const ['Microsoft YaHei', 'Arial Regular']) &&
        defaultTargetPlatform != TargetPlatform.iOS &&
        defaultTargetPlatform != TargetPlatform.macOS) {
      return 'Roboto';
    }
    return fontFamily;
  }

  List<String>? get flutterFontFamilyFallback {
    if (fontFamily != 'PingFang SC' ||
        (fallback?.contains('Roboto') ?? false)) {
      return fallback;
    }
    return [...?fallback, 'Roboto'];
  }
}

extension TFontFamilies on TThemeData {
  /// 小程序 `--td-font-family`；可用于 Flutter `TextStyle.fontFamily` 和
  /// `fontFamilyFallback`。`TText` 在非 Apple 平台会为默认字体栈选择
  /// Flutter 可用的主字体，不改变这里保存的小程序原始值。
  FontFamily? get fontFamily => fontFamilyMap['fontFamily'];

  /// 小程序 `--td-font-family-medium`。
  FontFamily? get fontFamilyMedium => fontFamilyMap['fontFamilyMedium'];
}
