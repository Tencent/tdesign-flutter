import 'package:flutter/material.dart';

/// TSwipeCell 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认滑动单元格样式。
/// 遵循多层级主题控制方案：P0 实例参数 > P1 组件 Theme > P4 Token。
class TSwipeCellThemeData extends ThemeExtension<TSwipeCellThemeData> {
  /// 打开关闭动画时长
  final Duration? duration;

  /// 操作项默认背景色（P1，覆盖 `backgroundColor`）
  final Color? actionBackgroundColor;

  /// 操作项图标默认色（P1，覆盖 `iconColor`）
  final Color? actionIconColor;

  /// 操作项文字默认样式（P1，覆盖 `labelStyle`）
  final TextStyle? actionTextStyle;

  /// 操作项图标默认尺寸（P1，覆盖 `iconSize` 默认值）
  final double? actionIconSize;

  /// 操作项图标与文字默认间距（P1，覆盖 `spacing` 默认值）
  final double? actionSpacing;

  const TSwipeCellThemeData({
    this.duration,
    this.actionBackgroundColor,
    this.actionIconColor,
    this.actionTextStyle,
    this.actionIconSize,
    this.actionSpacing,
  });

  /// 合并两个 ThemeExtension，[other] 优先于 this
  TSwipeCellThemeData merge(TSwipeCellThemeData? other) {
    if (other == null) {
      return this;
    }
    return TSwipeCellThemeData(
      duration: other.duration ?? duration,
      actionBackgroundColor:
          other.actionBackgroundColor ?? actionBackgroundColor,
      actionIconColor: other.actionIconColor ?? actionIconColor,
      actionTextStyle: other.actionTextStyle ?? actionTextStyle,
      actionIconSize: other.actionIconSize ?? actionIconSize,
      actionSpacing: other.actionSpacing ?? actionSpacing,
    );
  }

  @override
  TSwipeCellThemeData copyWith({
    Duration? duration,
    Color? actionBackgroundColor,
    Color? actionIconColor,
    TextStyle? actionTextStyle,
    double? actionIconSize,
    double? actionSpacing,
  }) {
    return TSwipeCellThemeData(
      duration: duration ?? this.duration,
      actionBackgroundColor:
          actionBackgroundColor ?? this.actionBackgroundColor,
      actionIconColor: actionIconColor ?? this.actionIconColor,
      actionTextStyle: actionTextStyle ?? this.actionTextStyle,
      actionIconSize: actionIconSize ?? this.actionIconSize,
      actionSpacing: actionSpacing ?? this.actionSpacing,
    );
  }

  @override
  TSwipeCellThemeData lerp(ThemeExtension<TSwipeCellThemeData>? other, double t) {
    if (other is! TSwipeCellThemeData) {
      return this;
    }
    return TSwipeCellThemeData(
      duration: t < 0.5 ? duration : other.duration,
      actionBackgroundColor: Color.lerp(
        actionBackgroundColor,
        other.actionBackgroundColor,
        t,
      ),
      actionIconColor:
          Color.lerp(actionIconColor, other.actionIconColor, t),
      actionTextStyle: TextStyle.lerp(actionTextStyle, other.actionTextStyle, t),
      actionIconSize: _lerp(actionIconSize, other.actionIconSize, t),
      actionSpacing: _lerp(actionSpacing, other.actionSpacing, t),
    );
  }

  double? _lerp(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0) + ((b ?? 0) - (a ?? 0)) * t;
  }
}
