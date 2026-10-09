import 'package:flutter/material.dart';
import 't_theme.dart';

/// 全局外投影 Token，使用 Flutter [BoxShadow] 表达。
extension TBoxShadows on TThemeData {
  /// 基础投影。
  List<BoxShadow>? get shadow1 => shadowMap['shadow1'];

  /// 中层投影。
  List<BoxShadow>? get shadow2 => shadowMap['shadow2'];

  /// 上层投影。
  List<BoxShadow>? get shadow3 => shadowMap['shadow3'];

  /// 轻投影。
  List<BoxShadow>? get shadow4 => shadowMap['shadow4'];
}

/// 四个方向的内投影使用定向内侧边线表达。
/// 使用方应把对应 [BorderSide] 放入 [Border.top] / right / bottom / left。
extension TInsetShadows on TThemeData {
  /// 顶部内投影对应的边线 Token；未配置时返回 null。
  BorderSide? get shadowInsetTop => insetShadowMap['shadowInsetTop'];

  /// 右侧内投影对应的边线 Token；未配置时返回 null。
  BorderSide? get shadowInsetRight => insetShadowMap['shadowInsetRight'];

  /// 底部内投影对应的边线 Token；未配置时返回 null。
  BorderSide? get shadowInsetBottom => insetShadowMap['shadowInsetBottom'];

  /// 左侧内投影对应的边线 Token；未配置时返回 null。
  BorderSide? get shadowInsetLeft => insetShadowMap['shadowInsetLeft'];
}
