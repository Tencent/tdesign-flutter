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
///
/// {@category ComponentTheme}
class TUploadThemeData extends ThemeExtension<TUploadThemeData> {
  const TUploadThemeData({
    this.variant,
    this.itemSize,
    this.spacing,
    this.runSpacing,
    this.alignment,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.overlayColor,
    this.statusTextStyle,
    this.borderRadius,
    this.addIconSize,
    this.statusIconSize,
    this.removeButtonSize,
    this.removeButtonColor,
    this.removeIconSize,
    this.disabledMaskColor,
  });

  /// 上传项形状；null 时使用圆角方形。
  final TUploadVariant? variant;

  /// 网格上传项的宽高，单位为逻辑像素；null 时为 80。
  final double? itemSize;

  /// 网格项横向间距；null 时使用全局 spacer Token。
  final double? spacing;

  /// 网格项纵向间距；null 时使用全局 spacer Token。列表项间距由全局 spacer1 决定。
  final double? runSpacing;

  /// 网格 Wrap 对齐方式；null 时为 WrapAlignment.start。
  final WrapAlignment? alignment;

  /// 启用项背景色；null 时使用 bgColorSecondaryContainer Token。
  final Color? backgroundColor;

  /// 启用项前景色；null 时使用 textColorPlaceholder Token。
  final Color? foregroundColor;

  /// 禁用添加项背景色；null 时使用 bgColorComponentDisabled Token。
  final Color? disabledBackgroundColor;

  /// 禁用添加项前景色；null 时使用 textColorDisabled Token。
  final Color? disabledForegroundColor;

  /// 上传中/失败状态的遮罩色；null 时使用 fontGray3 Token。
  final Color? overlayColor;

  /// 状态文案样式；null 时使用反色前景色与 fontBodySmall，字号最终回退 12。
  final TextStyle? statusTextStyle;

  /// 方形上传项圆角，单位为逻辑像素；null 时使用 radiusDefault Token，圆形变体不使用该值。
  final double? borderRadius;

  /// 网格添加图标尺寸；null 时为 28 逻辑像素。
  final double? addIconSize;

  /// 上传状态图标尺寸；null 时为 24 逻辑像素。
  final double? statusIconSize;

  /// 移除按钮宽高；null 时为 20 逻辑像素。
  final double? removeButtonSize;

  /// 移除按钮背景色；null 时使用 textColorDisabled Token。
  final Color? removeButtonColor;

  /// 移除图标尺寸；null 时为 16 逻辑像素。
  final double? removeIconSize;

  /// 有图片预览且处于 ready/success 的禁用文件遮罩色；null 时亮色使用 textColorAnti、暗色使用 fontGray1，alpha 均为 0.6。
  final Color? disabledMaskColor;

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TUploadThemeData copyWith({
    TUploadVariant? variant,
    double? itemSize,
    double? spacing,
    double? runSpacing,
    WrapAlignment? alignment,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    Color? overlayColor,
    TextStyle? statusTextStyle,
    double? borderRadius,
    double? addIconSize,
    double? statusIconSize,
    double? removeButtonSize,
    Color? removeButtonColor,
    double? removeIconSize,
    Color? disabledMaskColor,
  }) {
    return TUploadThemeData(
      variant: variant ?? this.variant,
      itemSize: itemSize ?? this.itemSize,
      spacing: spacing ?? this.spacing,
      runSpacing: runSpacing ?? this.runSpacing,
      alignment: alignment ?? this.alignment,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      disabledBackgroundColor:
          disabledBackgroundColor ?? this.disabledBackgroundColor,
      disabledForegroundColor:
          disabledForegroundColor ?? this.disabledForegroundColor,
      overlayColor: overlayColor ?? this.overlayColor,
      statusTextStyle: statusTextStyle ?? this.statusTextStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      addIconSize: addIconSize ?? this.addIconSize,
      statusIconSize: statusIconSize ?? this.statusIconSize,
      removeButtonSize: removeButtonSize ?? this.removeButtonSize,
      removeButtonColor: removeButtonColor ?? this.removeButtonColor,
      removeIconSize: removeIconSize ?? this.removeIconSize,
      disabledMaskColor: disabledMaskColor ?? this.disabledMaskColor,
    );
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TUploadThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TUploadThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
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
      disabledBackgroundColor: Color.lerp(
        disabledBackgroundColor,
        other.disabledBackgroundColor,
        t,
      ),
      disabledForegroundColor: Color.lerp(
        disabledForegroundColor,
        other.disabledForegroundColor,
        t,
      ),
      overlayColor: Color.lerp(overlayColor, other.overlayColor, t),
      statusTextStyle: TextStyle.lerp(
        statusTextStyle,
        other.statusTextStyle,
        t,
      ),
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t),
      addIconSize: lerpDouble(addIconSize, other.addIconSize, t),
      statusIconSize: lerpDouble(statusIconSize, other.statusIconSize, t),
      removeButtonSize: lerpDouble(removeButtonSize, other.removeButtonSize, t),
      removeButtonColor: Color.lerp(
        removeButtonColor,
        other.removeButtonColor,
        t,
      ),
      removeIconSize: lerpDouble(removeIconSize, other.removeIconSize, t),
      disabledMaskColor: Color.lerp(
        disabledMaskColor,
        other.disabledMaskColor,
        t,
      ),
    );
  }
}
