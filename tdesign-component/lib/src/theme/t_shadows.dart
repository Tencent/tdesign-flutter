import 'package:flutter/material.dart';
import 't_theme.dart';

/// 小程序全局外投影 Token；CSS 内投影不能直接由 Flutter [BoxShadow] 表达。
extension TBoxShadows on TThemeData {
  /// `--td-shadow-1` 基础投影。
  List<BoxShadow>? get shadow1 => shadowMap['shadow1'];

  /// `--td-shadow-2` 中层投影。
  List<BoxShadow>? get shadow2 => shadowMap['shadow2'];

  /// `--td-shadow-3` 上层投影。
  List<BoxShadow>? get shadow3 => shadowMap['shadow3'];

  /// `--td-shadow-4` 轻投影。
  List<BoxShadow>? get shadow4 => shadowMap['shadow4'];
}

/// 小程序当前的四个 blur=0 的 inset 阴影在 Flutter 中用定向内侧边线表达。
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
