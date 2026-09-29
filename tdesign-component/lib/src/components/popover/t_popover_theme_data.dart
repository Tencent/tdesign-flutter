import 'package:flutter/material.dart';

/// TPopover 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认气泡样式。
class TPopoverThemeData extends ThemeExtension<TPopoverThemeData> {
  /// 气泡背景色
  final Color? backgroundColor;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 最小宽度
  final double? minWidth;

  /// 文本内容的最大宽度
  final double? maxWidth;

  /// 最大高度
  final double? maxHeight;

  /// 气泡圆角；未设置时回退全局默认圆角。单个气泡可用局部 Theme 覆盖。
  final BorderRadius? borderRadius;

  /// 蒙层色；未设置时透明。单个气泡可用局部 Theme 覆盖。
  final Color? barrierColor;

  /// 箭头尺寸
  final double? arrowSize;

  /// 弹层与触发元素的间距
  final double? offset;

  /// 气泡阴影
  final List<BoxShadow>? boxShadow;

  const TPopoverThemeData({
    this.backgroundColor,
    this.padding,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.borderRadius,
    this.barrierColor,
    this.arrowSize,
    this.offset,
    this.boxShadow,
  });

  TPopoverThemeData merge(TPopoverThemeData? other) {
    if (other == null) {
      return this;
    }
    return TPopoverThemeData(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      padding: other.padding ?? padding,
      minWidth: other.minWidth ?? minWidth,
      maxWidth: other.maxWidth ?? maxWidth,
      maxHeight: other.maxHeight ?? maxHeight,
      borderRadius: other.borderRadius ?? borderRadius,
      barrierColor: other.barrierColor ?? barrierColor,
      arrowSize: other.arrowSize ?? arrowSize,
      offset: other.offset ?? offset,
      boxShadow: other.boxShadow ?? boxShadow,
    );
  }

  @override
  TPopoverThemeData copyWith({
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    double? minWidth,
    double? maxWidth,
    double? maxHeight,
    BorderRadius? borderRadius,
    Color? barrierColor,
    double? arrowSize,
    double? offset,
    List<BoxShadow>? boxShadow,
  }) {
    return TPopoverThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      borderRadius: borderRadius ?? this.borderRadius,
      barrierColor: barrierColor ?? this.barrierColor,
      arrowSize: arrowSize ?? this.arrowSize,
      offset: offset ?? this.offset,
      boxShadow: boxShadow ?? this.boxShadow,
    );
  }

  @override
  TPopoverThemeData lerp(ThemeExtension<TPopoverThemeData>? other, double t) {
    if (other is! TPopoverThemeData) {
      return this;
    }
    return TPopoverThemeData(
      backgroundColor: _lerpNullable(
        backgroundColor,
        other.backgroundColor,
        t,
        (a, b, value) => Color.lerp(a, b, value)!,
      ),
      padding: _lerpNullable(
        padding,
        other.padding,
        t,
        (a, b, value) => EdgeInsetsGeometry.lerp(a, b, value)!,
      ),
      minWidth: _lerpDouble(minWidth, other.minWidth, t),
      maxWidth: _lerpDouble(maxWidth, other.maxWidth, t),
      maxHeight: _lerpDouble(maxHeight, other.maxHeight, t),
      borderRadius: _lerpNullable(
        borderRadius,
        other.borderRadius,
        t,
        (a, b, value) => BorderRadius.lerp(a, b, value)!,
      ),
      barrierColor: _lerpNullable(
        barrierColor,
        other.barrierColor,
        t,
        (a, b, value) => Color.lerp(a, b, value)!,
      ),
      arrowSize: _lerpDouble(arrowSize, other.arrowSize, t),
      offset: _lerpDouble(offset, other.offset, t),
      boxShadow: t < 0.5 ? boxShadow : other.boxShadow,
    );
  }

  static double? _lerpDouble(
    /// 起始值。
    double? a,

    /// 目标值。
    double? b,

    /// 插值进度。
    double t,
  ) {
    return _lerpNullable(a, b, t, (a, b, value) {
      return a * (1.0 - value) + b * value;
    });
  }

  static T? _lerpNullable<T>(
    T? a,
    T? b,
    double t,
    T Function(T a, T b, double t) lerp,
  ) {
    if (a == null || b == null) {
      return t < 0.5 ? a : b;
    }
    return lerp(a, b, t);
  }
}
