import 'package:flutter/material.dart';

/// TSwipeCell 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认滑动单元格样式。
/// 遵循多层级主题控制方案：P0 实例参数 > P1 组件 Theme > P4 Token。
class TSwipeCellThemeData extends ThemeExtension<TSwipeCellThemeData> {
  /// 操作项默认背景色。
  final Color? actionBackgroundColor;

  /// 操作项图标默认色。
  final Color? actionIconColor;

  /// 操作项文字默认样式。
  final TextStyle? actionTextStyle;

  /// 操作项图标默认尺寸。
  final double? actionIconSize;

  /// 操作项图标与文字默认间距。
  final double? actionSpacing;

  /// 操作项左右内边距。
  final EdgeInsetsGeometry? actionPadding;

  const TSwipeCellThemeData({
    this.actionBackgroundColor,
    this.actionIconColor,
    this.actionTextStyle,
    this.actionIconSize,
    this.actionSpacing,
    this.actionPadding,
  });

  /// 合并两个 ThemeExtension，[other] 优先于 this
  TSwipeCellThemeData merge(TSwipeCellThemeData? other) {
    if (other == null) {
      return this;
    }
    return TSwipeCellThemeData(
      actionBackgroundColor:
          other.actionBackgroundColor ?? actionBackgroundColor,
      actionIconColor: other.actionIconColor ?? actionIconColor,
      actionTextStyle: other.actionTextStyle ?? actionTextStyle,
      actionIconSize: other.actionIconSize ?? actionIconSize,
      actionSpacing: other.actionSpacing ?? actionSpacing,
      actionPadding: other.actionPadding ?? actionPadding,
    );
  }

  @override
  TSwipeCellThemeData copyWith({
    Color? actionBackgroundColor,
    Color? actionIconColor,
    TextStyle? actionTextStyle,
    double? actionIconSize,
    double? actionSpacing,
    EdgeInsetsGeometry? actionPadding,
  }) {
    return TSwipeCellThemeData(
      actionBackgroundColor:
          actionBackgroundColor ?? this.actionBackgroundColor,
      actionIconColor: actionIconColor ?? this.actionIconColor,
      actionTextStyle: actionTextStyle ?? this.actionTextStyle,
      actionIconSize: actionIconSize ?? this.actionIconSize,
      actionSpacing: actionSpacing ?? this.actionSpacing,
      actionPadding: actionPadding ?? this.actionPadding,
    );
  }

  @override
  TSwipeCellThemeData lerp(
    ThemeExtension<TSwipeCellThemeData>? other,
    double t,
  ) {
    if (other is! TSwipeCellThemeData) {
      return this;
    }
    return TSwipeCellThemeData(
      actionBackgroundColor: Color.lerp(
        actionBackgroundColor,
        other.actionBackgroundColor,
        t,
      ),
      actionIconColor: Color.lerp(actionIconColor, other.actionIconColor, t),
      actionTextStyle: TextStyle.lerp(
        actionTextStyle,
        other.actionTextStyle,
        t,
      ),
      actionIconSize: _lerp(actionIconSize, other.actionIconSize, t),
      actionSpacing: _lerp(actionSpacing, other.actionSpacing, t),
      actionPadding: EdgeInsetsGeometry.lerp(
        actionPadding,
        other.actionPadding,
        t,
      ),
    );
  }

  double? _lerp(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0) + ((b ?? 0) - (a ?? 0)) * t;
  }
}
