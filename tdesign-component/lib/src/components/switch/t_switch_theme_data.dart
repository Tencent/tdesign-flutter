import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_switch_types.dart';

/// TSwitch 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树默认样式。
class TSwitchThemeData extends ThemeExtension<TSwitchThemeData> {
  /// Widget 未指定尺寸时使用的默认尺寸。
  final TSwitchSize? defaultSize;

  /// Widget 未指定形态时使用的默认形态。
  final TSwitchVariant? defaultVariant;

  /// 开启时轨道颜色
  final Color? trackOnColor;

  /// 关闭时轨道颜色
  final Color? trackOffColor;

  /// 开启时ThumbView的颜色
  final Color? thumbContentOnColor;

  /// 关闭时ThumbView的颜色
  final Color? thumbContentOffColor;

  /// 开启时ThumbView的字体样式
  final TextStyle? thumbContentOnFont;

  /// 关闭时ThumbView的字体样式
  final TextStyle? thumbContentOffFont;

  /// 开启文案
  final String? openText;

  /// 关闭文案
  final String? closeText;

  const TSwitchThemeData({
    /// 默认尺寸。
    this.defaultSize,

    /// 默认内容形态。
    this.defaultVariant,

    /// 开启态轨道颜色。
    this.trackOnColor,

    /// 关闭态轨道颜色。
    this.trackOffColor,

    /// 开启态滑块内容颜色。
    this.thumbContentOnColor,

    /// 关闭态滑块内容颜色。
    this.thumbContentOffColor,

    /// 开启态滑块内容文本样式。
    this.thumbContentOnFont,

    /// 关闭态滑块内容文本样式。
    this.thumbContentOffFont,

    /// text 形态的默认开启文案。
    this.openText,

    /// text 形态的默认关闭文案。
    this.closeText,
  });

  @override
  TSwitchThemeData copyWith({
    TSwitchSize? defaultSize,
    TSwitchVariant? defaultVariant,
    Color? trackOnColor,
    Color? trackOffColor,
    Color? thumbContentOnColor,
    Color? thumbContentOffColor,
    TextStyle? thumbContentOnFont,
    TextStyle? thumbContentOffFont,
    String? openText,
    String? closeText,
  }) {
    return TSwitchThemeData(
      defaultSize: defaultSize ?? this.defaultSize,
      defaultVariant: defaultVariant ?? this.defaultVariant,
      trackOnColor: trackOnColor ?? this.trackOnColor,
      trackOffColor: trackOffColor ?? this.trackOffColor,
      thumbContentOnColor: thumbContentOnColor ?? this.thumbContentOnColor,
      thumbContentOffColor: thumbContentOffColor ?? this.thumbContentOffColor,
      thumbContentOnFont: thumbContentOnFont ?? this.thumbContentOnFont,
      thumbContentOffFont: thumbContentOffFont ?? this.thumbContentOffFont,
      openText: openText ?? this.openText,
      closeText: closeText ?? this.closeText,
    );
  }

  @override
  TSwitchThemeData lerp(ThemeExtension<TSwitchThemeData>? other, double t) {
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
      defaultSize: t <= 0.5 ? defaultSize : other.defaultSize,
      defaultVariant: t <= 0.5 ? defaultVariant : other.defaultVariant,
      trackOnColor: Color.lerp(trackOnColor, other.trackOnColor, t),
      trackOffColor: Color.lerp(trackOffColor, other.trackOffColor, t),
      thumbContentOnColor:
          Color.lerp(thumbContentOnColor, other.thumbContentOnColor, t),
      thumbContentOffColor:
          Color.lerp(thumbContentOffColor, other.thumbContentOffColor, t),
      thumbContentOnFont:
          TextStyle.lerp(thumbContentOnFont, other.thumbContentOnFont, t),
      thumbContentOffFont:
          TextStyle.lerp(thumbContentOffFont, other.thumbContentOffFont, t),
      openText: t <= 0.5 ? openText : other.openText,
      closeText: t <= 0.5 ? closeText : other.closeText,
    );
  }
}
