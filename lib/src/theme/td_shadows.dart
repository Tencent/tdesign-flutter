import 'package:flutter/material.dart';
import 'td_theme.dart';

/// 内置投影
extension TDBoxShadows on TDThemeData {
  /// 基础投影
  List<BoxShadow>? get baseShadows => shadowMap['baseShadows'];

  /// 中层投影
  List<BoxShadow>? get middleShadows => shadowMap['middleShadows'];

  /// 上层投影
  List<BoxShadow>? get topShadows => shadowMap['topShadows'];
}
