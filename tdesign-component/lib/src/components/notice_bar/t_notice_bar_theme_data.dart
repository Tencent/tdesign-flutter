import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import 't_notice_bar_types.dart';

/// TNoticeBar 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认公告栏样式。
///
/// {@category ComponentTheme}
class TNoticeBarThemeData extends ThemeExtension<TNoticeBarThemeData> {
  /// 文字高度
  /// 未配置时为 22 逻辑像素，表示正文区域高度，外层内边距另计。
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
  /// 未配置时使用 defaultPadding，即上/下 13、左 16、右 12 逻辑像素。
  final EdgeInsetsGeometry? padding;

  const TNoticeBarThemeData({
    this.height,
    this.backgroundColor,
    this.textStyle,
    this.leftIconColor,
    this.rightIconColor,
    this.padding,
  });

  /// 默认内边距
  static const EdgeInsets defaultPadding = EdgeInsets.only(
    top: 13,
    bottom: 13,
    left: 16,
    right: 12,
  );

  /// 合并主题配置。
  ///
  /// ## 返回值
  /// other 的非空字段优先的合并主题；other 为 null 时返回当前主题。
  TNoticeBarThemeData merge(
    /// 要合并的目标主题；为空时保留当前配置。
    TNoticeBarThemeData? other,
  ) {
    if (other == null) {
      return this;
    }
    return TNoticeBarThemeData(
      height: other.height ?? height,
      backgroundColor: other.backgroundColor ?? backgroundColor,
      textStyle: other.textStyle ?? textStyle,
      leftIconColor: other.leftIconColor ?? leftIconColor,
      rightIconColor: other.rightIconColor ?? rightIconColor,
      padding: other.padding ?? padding,
    );
  }

  /// 根据状态和上下文解析出完整的样式（颜色等）
  ///
  /// ## 返回值
  /// 将状态预设与当前主题覆盖合并后的 NoticeBar 视觉配置。
  TNoticeBarThemeData resolve(
    /// 当前构建上下文，用于读取祖先配置。
    BuildContext context, {

    /// 公告栏语义状态，默认 info，用于解析状态对应的颜色。
    TNoticeBarStatus status = TNoticeBarStatus.info,
  }) {
    final t = context.tTheme;

    var resolvedBg = backgroundColor;
    var resolvedLeftIcon = leftIconColor;

    // 仅在未显式注入时才使用状态默认色，保证 TNoticeBarThemeData 注入生效
    switch (status) {
      case TNoticeBarStatus.warning:
        resolvedLeftIcon ??= t.warningColor;
        resolvedBg ??= t.warningColorLight;
        break;
      case TNoticeBarStatus.error:
        resolvedLeftIcon ??= t.errorColor;
        resolvedBg ??= t.errorColorLight;
        break;
      case TNoticeBarStatus.success:
        resolvedLeftIcon ??= t.successColor;
        resolvedBg ??= t.successColorLight;
        break;
      case TNoticeBarStatus.info:
        resolvedLeftIcon ??= t.brandColor;
        resolvedBg ??= t.brandColorLight;
        break;
    }

    return copyWith(
      backgroundColor: resolvedBg,
      leftIconColor: resolvedLeftIcon,
      rightIconColor: rightIconColor ?? t.textColorSecondary,
      textStyle:
          textStyle ??
          TextStyle(
            color: t.textColorPrimary,
            fontSize: t.fontBodyMedium?.size,
            height: t.fontBodyMedium?.height,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
          ),
    );
  }

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TNoticeBarThemeData copyWith({
    double? height,
    Color? backgroundColor,
    TextStyle? textStyle,
    Color? leftIconColor,
    Color? rightIconColor,
    EdgeInsetsGeometry? padding,
  }) {
    return TNoticeBarThemeData(
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      leftIconColor: leftIconColor ?? this.leftIconColor,
      rightIconColor: rightIconColor ?? this.rightIconColor,
      padding: padding ?? this.padding,
    );
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TNoticeBarThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TNoticeBarThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TNoticeBarThemeData) {
      return this;
    }
    return TNoticeBarThemeData(
      height: _lerpHeight(height, other.height, t),
      backgroundColor: _lerpColor(backgroundColor, other.backgroundColor, t),
      textStyle: _lerpTextStyle(textStyle, other.textStyle, t),
      leftIconColor: _lerpColor(leftIconColor, other.leftIconColor, t),
      rightIconColor: _lerpColor(rightIconColor, other.rightIconColor, t),
      padding: _lerpPadding(padding, other.padding, t),
    );
  }

  /// 在两个可选数值之间插值。
  ///
  /// 当仅一端有值时采用离散切换，避免把缺省值错误地当作 0。组件已知默认值
  /// 的字段会在 [lerp] 内使用其实际默认值平滑插值。
  ///
  /// ## 返回值
  /// 按 t 线性插值的数值；两端均为 null 时为 null，仅一端为 null 时将该端按 0 计算。
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
    if (a == null || b == null) {
      return t < 0.5 ? a : b;
    }
    return a * (1.0 - t) + b * t;
  }

  static double? _lerpHeight(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    const defaultHeight = 22.0;
    return (a ?? defaultHeight) * (1.0 - t) + (b ?? defaultHeight) * t;
  }

  static EdgeInsetsGeometry? _lerpPadding(
    EdgeInsetsGeometry? a,
    EdgeInsetsGeometry? b,
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }
    return EdgeInsetsGeometry.lerp(a ?? defaultPadding, b ?? defaultPadding, t);
  }

  static Color? _lerpColor(Color? a, Color? b, double t) {
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
}
