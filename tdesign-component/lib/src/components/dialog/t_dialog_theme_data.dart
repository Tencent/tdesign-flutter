import 'package:flutter/material.dart';

/// TDialog 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认对话框样式。
/// 实例组件的对应字段优先于 Theme Extension。
class TDialogThemeData extends ThemeExtension<TDialogThemeData> {
  /// 背景色（对应 Material [DialogThemeData.backgroundColor]）
  final Color? backgroundColor;

  /// 形状（圆角；对应 Material [DialogThemeData.shape]）
  final ShapeBorder? shape;

  /// 阴影（对应 Material [DialogThemeData.elevation]）
  final double? elevation;

  /// 标题文案样式（对应 Material [DialogThemeData.titleTextStyle]）
  final TextStyle? titleTextStyle;

  /// 内容文案样式（对应 Material [DialogThemeData.contentTextStyle]）
  final TextStyle? contentTextStyle;

  /// 内容内边距（对应 Material [Dialog] 的 contentPadding；TDesign 扩展）
  final EdgeInsetsGeometry? contentPadding;

  /// 面板最大高度。
  final double? maxHeight;

  /// 按钮区样式（对应 Material [TextButtonThemeData]；TDesign 扩展）
  final ButtonStyle? actionButtonStyle;

  /// 弹窗宽度
  final double? width;

  const TDialogThemeData({
    this.backgroundColor,
    this.shape,
    this.elevation,
    this.titleTextStyle,
    this.contentTextStyle,
    this.contentPadding,
    this.maxHeight,
    this.actionButtonStyle,
    this.width,
  });

  /// 合并两个 ThemeExtension，[other] 优先于 this
  TDialogThemeData merge(TDialogThemeData? other) {
    if (other == null) {
      return this;
    }
    return TDialogThemeData(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      shape: other.shape ?? shape,
      elevation: other.elevation ?? elevation,
      titleTextStyle: other.titleTextStyle ?? titleTextStyle,
      contentTextStyle: other.contentTextStyle ?? contentTextStyle,
      contentPadding: other.contentPadding ?? contentPadding,
      maxHeight: other.maxHeight ?? maxHeight,
      actionButtonStyle: other.actionButtonStyle ?? actionButtonStyle,
      width: other.width ?? width,
    );
  }

  @override
  TDialogThemeData copyWith({
    Color? backgroundColor,
    ShapeBorder? shape,
    double? elevation,
    TextStyle? titleTextStyle,
    TextStyle? contentTextStyle,
    EdgeInsetsGeometry? contentPadding,
    double? maxHeight,
    ButtonStyle? actionButtonStyle,
    double? width,
  }) {
    return TDialogThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      shape: shape ?? this.shape,
      elevation: elevation ?? this.elevation,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      contentTextStyle: contentTextStyle ?? this.contentTextStyle,
      contentPadding: contentPadding ?? this.contentPadding,
      maxHeight: maxHeight ?? this.maxHeight,
      actionButtonStyle: actionButtonStyle ?? this.actionButtonStyle,
      width: width ?? this.width,
    );
  }

  @override
  TDialogThemeData lerp(ThemeExtension<TDialogThemeData>? other, double t) {
    if (other is! TDialogThemeData) {
      return this;
    }
    return TDialogThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      shape: ShapeBorder.lerp(shape, other.shape, t),
      elevation: lerpDouble(elevation, other.elevation, t),
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t),
      contentTextStyle:
          TextStyle.lerp(contentTextStyle, other.contentTextStyle, t),
      contentPadding:
          EdgeInsetsGeometry.lerp(contentPadding, other.contentPadding, t),
      maxHeight: lerpDouble(maxHeight, other.maxHeight, t),
      actionButtonStyle:
          ButtonStyle.lerp(actionButtonStyle, other.actionButtonStyle, t),
      width: lerpDouble(width, other.width, t),
    );
  }

  static double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0.0) * (1.0 - t) + (b ?? 0.0) * t;
  }
}
