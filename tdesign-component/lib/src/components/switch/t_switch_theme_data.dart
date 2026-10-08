import 'package:flutter/material.dart';

/// TSwitch 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树默认样式。
class TSwitchThemeData extends ThemeExtension<TSwitchThemeData> {
  /// 开启态轨道颜色。
  /// 未配置时使用 brandColor Token。
  final Color? trackOnColor;

  /// 关闭态轨道颜色。
  /// 未配置时使用 bgColorSecondaryContainerActive Token。
  final Color? trackOffColor;

  /// 禁用时开启态轨道颜色；未设置时使用全局禁用品牌色。
  final Color? disabledTrackOnColor;

  /// 禁用时关闭态轨道颜色；未设置时使用全局禁用组件背景色。
  final Color? disabledTrackOffColor;

  /// 可交互时滑块填充色；未设置时使用全局反色文字 Token。
  /// 与滑块内图标或文字的颜色无关。
  final Color? thumbColor;

  /// 禁用或加载时滑块填充色；未设置时随明暗模式取白色层级。
  final Color? disabledThumbColor;

  /// 加载指示器颜色；未设置时浅色为品牌色、深色为最高层级白色。
  final Color? loadingColor;

  /// 开启态滑块内容颜色。
  /// 未配置时使用 brandColor Token。
  final Color? thumbContentOnColor;

  /// 关闭态滑块内容颜色。
  /// 未配置时使用 textColorDisabled Token。
  final Color? thumbContentOffColor;

  /// 开启态滑块内容文本样式。
  /// 未配置时使用 fontBodyMedium 字号 Token，Token 为空时回退为 14 逻辑像素。
  final TextStyle? thumbContentOnFont;

  /// 关闭态滑块内容文本样式。
  /// 未配置时使用 fontBodyMedium 字号 Token，Token 为空时回退为 14 逻辑像素。
  final TextStyle? thumbContentOffFont;

  static Color? _lerpColor(Color? a, Color? b, double t) {
    // null means a live Token fallback, not transparent black.
    if (a == null || b == null) {
      return t < 0.5 ? a : b;
    }
    return Color.lerp(a, b, t);
  }

  static TextStyle? _lerpTextStyle(TextStyle? a, TextStyle? b, double t) {
    if (a == null || b == null) {
      return t < 0.5 ? a : b;
    }
    return TextStyle.lerp(a, b, t);
  }

  const TSwitchThemeData({
    this.trackOnColor,
    this.trackOffColor,
    this.disabledTrackOnColor,
    this.disabledTrackOffColor,
    this.thumbColor,
    this.disabledThumbColor,
    this.loadingColor,
    this.thumbContentOnColor,
    this.thumbContentOffColor,
    this.thumbContentOnFont,
    this.thumbContentOffFont,
  });

  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TSwitchThemeData copyWith({
    Color? trackOnColor,
    Color? trackOffColor,
    Color? disabledTrackOnColor,
    Color? disabledTrackOffColor,
    Color? thumbColor,
    Color? disabledThumbColor,
    Color? loadingColor,
    Color? thumbContentOnColor,
    Color? thumbContentOffColor,
    TextStyle? thumbContentOnFont,
    TextStyle? thumbContentOffFont,
  }) {
    return TSwitchThemeData(
      trackOnColor: trackOnColor ?? this.trackOnColor,
      trackOffColor: trackOffColor ?? this.trackOffColor,
      disabledTrackOnColor: disabledTrackOnColor ?? this.disabledTrackOnColor,
      disabledTrackOffColor:
          disabledTrackOffColor ?? this.disabledTrackOffColor,
      thumbColor: thumbColor ?? this.thumbColor,
      disabledThumbColor: disabledThumbColor ?? this.disabledThumbColor,
      loadingColor: loadingColor ?? this.loadingColor,
      thumbContentOnColor: thumbContentOnColor ?? this.thumbContentOnColor,
      thumbContentOffColor: thumbContentOffColor ?? this.thumbContentOffColor,
      thumbContentOnFont: thumbContentOnFont ?? this.thumbContentOnFont,
      thumbContentOffFont: thumbContentOffFont ?? this.thumbContentOffFont,
    );
  }

  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TSwitchThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TSwitchThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TSwitchThemeData) {
      return this;
    }
    if (t == 0) {
      return this;
    }
    if (t == 1) {
      return other;
    }
    return TSwitchThemeData(
      trackOnColor: _lerpColor(trackOnColor, other.trackOnColor, t),
      trackOffColor: _lerpColor(trackOffColor, other.trackOffColor, t),
      disabledTrackOnColor: _lerpColor(
        disabledTrackOnColor,
        other.disabledTrackOnColor,
        t,
      ),
      disabledTrackOffColor: _lerpColor(
        disabledTrackOffColor,
        other.disabledTrackOffColor,
        t,
      ),
      thumbColor: _lerpColor(thumbColor, other.thumbColor, t),
      disabledThumbColor: _lerpColor(
        disabledThumbColor,
        other.disabledThumbColor,
        t,
      ),
      loadingColor: _lerpColor(loadingColor, other.loadingColor, t),
      thumbContentOnColor: _lerpColor(
        thumbContentOnColor,
        other.thumbContentOnColor,
        t,
      ),
      thumbContentOffColor: _lerpColor(
        thumbContentOffColor,
        other.thumbContentOffColor,
        t,
      ),
      thumbContentOnFont: _lerpTextStyle(
        thumbContentOnFont,
        other.thumbContentOnFont,
        t,
      ),
      thumbContentOffFont: _lerpTextStyle(
        thumbContentOffFont,
        other.thumbContentOffFont,
        t,
      ),
    );
  }
}
