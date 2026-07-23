import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 上传项形状。
enum TUploadVariant {
  /// 圆角方形。
  square,

  /// 圆形。
  circle,
}

/// TUpload 组件级 ThemeExtension。
class TUploadThemeData extends ThemeExtension<TUploadThemeData> {
  const TUploadThemeData({
    /// 上传项形状。
    this.variant,

    /// 上传项尺寸。
    this.itemSize,

    /// 横向间距。
    this.spacing,

    /// 纵向间距。
    this.runSpacing,

    /// Wrap 对齐方式。
    this.alignment,

    /// 默认背景色。
    this.backgroundColor,

    /// 默认前景色。
    this.foregroundColor,

    /// 状态遮罩颜色。
    this.overlayColor,

    /// 状态文案样式。
    this.statusTextStyle,

    /// 方形上传项圆角。
    this.borderRadius,

    /// 添加图标尺寸。
    this.addIconSize,

    /// 状态图标尺寸。
    this.statusIconSize,

    /// 移除按钮尺寸。
    this.removeButtonSize,

    /// 移除按钮颜色。
    this.removeButtonColor,

    /// 移除图标尺寸。
    this.removeIconSize,
  });

  /// 上传项形状。
  final TUploadVariant? variant;

  /// 上传项尺寸。
  final double? itemSize;

  /// 横向间距。
  final double? spacing;

  /// 纵向间距。
  final double? runSpacing;

  /// Wrap 对齐方式。
  final WrapAlignment? alignment;

  /// 默认背景色。
  final Color? backgroundColor;

  /// 默认前景色。
  final Color? foregroundColor;

  /// 状态遮罩颜色。
  final Color? overlayColor;

  /// 状态文案样式。
  final TextStyle? statusTextStyle;

  /// 方形上传项圆角。
  final double? borderRadius;

  /// 添加图标尺寸。
  final double? addIconSize;

  /// 状态图标尺寸。
  final double? statusIconSize;

  /// 移除按钮尺寸。
  final double? removeButtonSize;

  /// 移除按钮颜色。
  final Color? removeButtonColor;

  /// 移除图标尺寸。
  final double? removeIconSize;

  @override
  TUploadThemeData copyWith({
    TUploadVariant? variant,
    double? itemSize,
    double? spacing,
    double? runSpacing,
    WrapAlignment? alignment,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? overlayColor,
    TextStyle? statusTextStyle,
    double? borderRadius,
    double? addIconSize,
    double? statusIconSize,
    double? removeButtonSize,
    Color? removeButtonColor,
    double? removeIconSize,
  }) {
    return TUploadThemeData(
      variant: variant ?? this.variant,
      itemSize: itemSize ?? this.itemSize,
      spacing: spacing ?? this.spacing,
      runSpacing: runSpacing ?? this.runSpacing,
      alignment: alignment ?? this.alignment,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      overlayColor: overlayColor ?? this.overlayColor,
      statusTextStyle: statusTextStyle ?? this.statusTextStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      addIconSize: addIconSize ?? this.addIconSize,
      statusIconSize: statusIconSize ?? this.statusIconSize,
      removeButtonSize: removeButtonSize ?? this.removeButtonSize,
      removeButtonColor: removeButtonColor ?? this.removeButtonColor,
      removeIconSize: removeIconSize ?? this.removeIconSize,
    );
  }

  @override
  TUploadThemeData lerp(ThemeExtension<TUploadThemeData>? other, double t) {
    if (other is! TUploadThemeData) {
      return this;
    }
    return TUploadThemeData(
      variant: t < 0.5 ? variant : other.variant,
      itemSize: lerpDouble(itemSize, other.itemSize, t),
      spacing: lerpDouble(spacing, other.spacing, t),
      runSpacing: lerpDouble(runSpacing, other.runSpacing, t),
      alignment: t < 0.5 ? alignment : other.alignment,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      foregroundColor: Color.lerp(foregroundColor, other.foregroundColor, t),
      overlayColor: Color.lerp(overlayColor, other.overlayColor, t),
      statusTextStyle:
          TextStyle.lerp(statusTextStyle, other.statusTextStyle, t),
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t),
      addIconSize: lerpDouble(addIconSize, other.addIconSize, t),
      statusIconSize: lerpDouble(statusIconSize, other.statusIconSize, t),
      removeButtonSize: lerpDouble(removeButtonSize, other.removeButtonSize, t),
      removeButtonColor:
          Color.lerp(removeButtonColor, other.removeButtonColor, t),
      removeIconSize: lerpDouble(removeIconSize, other.removeIconSize, t),
    );
  }
}
