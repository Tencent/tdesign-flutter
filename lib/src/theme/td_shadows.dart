import 'package:flutter/material.dart';
import 'package:tdesign_flutter/src/theme/td_theme.dart';

/// 内置投影
extension TDBoxShadows on TDThemeData {
  /// 基础投影
  List<BoxShadow>? get baseShadows => shadows['baseShadows'];

  /// 中层投影
  List<BoxShadow>? get middleShadows => shadows['middleShadows'];

  /// 上层投影
  List<BoxShadow>? get topShadows => shadows['topShadows'];
}
