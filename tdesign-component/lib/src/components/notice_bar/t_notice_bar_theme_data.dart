import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';

/// 公告栏语义色
enum TNoticeBarVariant {
  /// 信息（默认）
  info,

  /// 成功
  success,

  /// 警告
  warning,

  /// 错误
  error,
}

/// TNoticeBar 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认公告栏样式。
class TNoticeBarThemeData extends ThemeExtension<TNoticeBarThemeData> {
  /// 语义色变体
  final TNoticeBarVariant? variant;

  /// 文字高度
  final double? height;

  /// 公告栏背景色
  final Color? backgroundColor;

  /// 公告栏内容样式
  final TextStyle? textStyle;

  /// 公告栏左侧图标颜色
  final Color? leftIconColor;

  /// 公告栏右侧图标颜色
  final Color? rightIconColor;

  /// 公告栏内边距
  final EdgeInsetsGeometry? padding;

  const TNoticeBarThemeData({
    this.variant,
    this.height,
    this.backgroundColor,
    this.textStyle,
    this.leftIconColor,
    this.rightIconColor,
    this.padding,
  });

  /// 默认内边距
  static const EdgeInsets defaultPadding =
      EdgeInsets.only(top: 13, bottom: 13, left: 16, right: 12);

  /// 合并两个 ThemeExtension，[other] 优先于 this
  TNoticeBarThemeData merge(TNoticeBarThemeData? other) {
    if (other == null) {
      return this;
    }
    return TNoticeBarThemeData(
      variant: other.variant ?? variant,
      height: other.height ?? height,
      backgroundColor: other.backgroundColor ?? backgroundColor,
      textStyle: other.textStyle ?? textStyle,
      leftIconColor: other.leftIconColor ?? leftIconColor,
      rightIconColor: other.rightIconColor ?? rightIconColor,
      padding: other.padding ?? padding,
    );
  }

  /// 根据变体和上下文解析出完整的样式（颜色等）
  TNoticeBarThemeData resolve(BuildContext context) {
    final effectiveVariant = variant ?? TNoticeBarVariant.info;
    final t = context.tTheme;

    var resolvedBg = backgroundColor;
    var resolvedLeftIcon = leftIconColor;

    // 仅在未显式注入时才使用变体默认色，保证 TNoticeBarThemeData 注入生效
    switch (effectiveVariant) {
      case TNoticeBarVariant.warning:
        resolvedLeftIcon ??= t.warningNormalColor;
        resolvedBg ??= t.warningLightColor;
        break;
      case TNoticeBarVariant.error:
        resolvedLeftIcon ??= t.errorNormalColor;
        resolvedBg ??= t.errorLightColor;
        break;
      case TNoticeBarVariant.success:
        resolvedLeftIcon ??= t.successNormalColor;
        resolvedBg ??= t.successLightColor;
        break;
      case TNoticeBarVariant.info:
        resolvedLeftIcon ??= t.brandNormalColor;
        resolvedBg ??= t.brandLightColor;
        break;
    }

    return copyWith(
      backgroundColor: resolvedBg,
      leftIconColor: resolvedLeftIcon,
      rightIconColor: rightIconColor ?? t.textColorSecondary,
      textStyle: textStyle ??
          TextStyle(
            color: t.textColorPrimary,
            fontSize: t.fontBodyMedium?.size,
            height: t.fontBodyMedium?.height,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
          ),
    );
  }

  @override
  TNoticeBarThemeData copyWith({
    TNoticeBarVariant? variant,
    double? height,
    Color? backgroundColor,
    TextStyle? textStyle,
    Color? leftIconColor,
    Color? rightIconColor,
    EdgeInsetsGeometry? padding,
  }) {
    return TNoticeBarThemeData(
      variant: variant ?? this.variant,
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      leftIconColor: leftIconColor ?? this.leftIconColor,
      rightIconColor: rightIconColor ?? this.rightIconColor,
      padding: padding ?? this.padding,
    );
  }

  @override
  TNoticeBarThemeData lerp(
      ThemeExtension<TNoticeBarThemeData>? other, double t) {
    if (other is! TNoticeBarThemeData) {
      return this;
    }
    return TNoticeBarThemeData(
      variant: t < 0.5 ? variant : other.variant,
      height: lerpDouble(height, other.height, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      leftIconColor: Color.lerp(leftIconColor, other.leftIconColor, t),
      rightIconColor: Color.lerp(rightIconColor, other.rightIconColor, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
    );
  }

  static double? lerpDouble(
    /// 起始值。
    double? a,

    /// 目标值。
    double? b,

    /// 插值进度。
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0.0) * (1.0 - t) + (b ?? 0.0) * t;
  }
}
