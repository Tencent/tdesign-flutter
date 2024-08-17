import 'package:flutter/material.dart';
import '../button/td_button_style.dart';

class TDProgressStyle {
  const TDProgressStyle({
    this.height,
    this.width,
    this.circleRadius,
    this.borderRadius,
    this.color,
    this.backgroundColor,
    this.labelPosition,
    this.labelType,
    this.animationConfig,
    this.buttonConfig,
  });

  final double? height;
  final double? width;
  final double? circleRadius;
  final double? borderRadius;
  final Color? color;
  final Color? backgroundColor;
  final TDProgressLabelPosition? labelPosition;
  final TDProgressLabelType? labelType;
  final TDProgressAnimationConfig? animationConfig;
  final TDProgressButtonConfig? buttonConfig;

  // 基础进度条样式
  static TDProgressStyle baseStyle(BuildContext context) {
    final theme = Theme.of(context);
    return TDProgressStyle(
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,
      animationConfig: const TDProgressAnimationConfig(
        enabled: true,
        type: TDProgressAnimationType.linear,
        speed: 1.0,
      ),
    );
  }

  // 线性进度条样式
  static TDProgressStyle lineStyle(BuildContext context) {
    return baseStyle(context).copyWith(
      height: 8,
      width: double.infinity,
      borderRadius: 4,
      labelPosition: TDProgressLabelPosition.right,
      labelType: TDProgressLabelType.text,
    );
  }

  // 圆形进度条样式
  static TDProgressStyle circleStyle(BuildContext context) {
    return baseStyle(context).copyWith(
      circleRadius: 50,
      labelPosition: TDProgressLabelPosition.inner,
      labelType: TDProgressLabelType.text,
      animationConfig: const TDProgressAnimationConfig(
        type: TDProgressAnimationType.easeInOut,
      ),
    );
  }

  // 微型进度条样式
  static TDProgressStyle microStyle(BuildContext context) {
    return baseStyle(context).copyWith(
      height: 4,
      width: 60,
      borderRadius: 2,
      labelType: TDProgressLabelType.none,
      animationConfig: const TDProgressAnimationConfig(
        speed: 1.5,
      ),
    );
  }

  // 带按钮的微型进度条样式
  static TDProgressStyle microButtonStyle(BuildContext context) {
    return microStyle(context).copyWith(
      labelType: TDProgressLabelType.icon,
      buttonConfig: const TDProgressButtonConfig(
        size: Size(20, 20),
        padding: EdgeInsets.all(4),
        // 其他微型按钮特定的配置
      ),
    );
  }

  // 带按钮的线性进度条样式
  static TDProgressStyle lineButtonStyle(BuildContext context) {
    return lineStyle(context).copyWith(
      height: 12,
      borderRadius: 6,
      labelType: TDProgressLabelType.custom,
      buttonConfig: const TDProgressButtonConfig(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        // 其他线性按钮特定的配置
      ),
    );
  }

  // 根据进度条类型获取默认样式
  static TDProgressStyle getDefaultStyle(BuildContext context, TDProgressType type) {
    switch (type) {
      case TDProgressType.line:
        return lineStyle(context);
      case TDProgressType.circle:
        return circleStyle(context);
      case TDProgressType.micro:
        return microStyle(context);
      case TDProgressType.microButton:
        return microButtonStyle(context);
      case TDProgressType.lineButton:
        return lineButtonStyle(context);
    }
  }

  // 复制并修改当前样式
  TDProgressStyle copyWith({
    double? height,
    double? width,
    double? circleRadius,
    double? borderRadius,
    Color? color,
    Color? backgroundColor,
    TDProgressLabelPosition? labelPosition,
    TDProgressLabelType? labelType,
    TDProgressAnimationConfig? animationConfig,
    TDProgressButtonConfig? buttonConfig,
  }) {
    return TDProgressStyle(
      height: height ?? this.height,
      width: width ?? this.width,
      circleRadius: circleRadius ?? this.circleRadius,
      borderRadius: borderRadius ?? this.borderRadius,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      labelPosition: labelPosition ?? this.labelPosition,
      labelType: labelType ?? this.labelType,
      animationConfig: animationConfig ?? this.animationConfig,
      buttonConfig: buttonConfig ?? this.buttonConfig,
    );
  }
}

// 新增：进度条按钮配置类
class TDProgressButtonConfig {
  const TDProgressButtonConfig({
    this.size,
    this.padding,
    this.style,
  });

  final Size? size;
  final EdgeInsetsGeometry? padding;
  final TDButtonStyle? style;

  TDProgressButtonConfig copyWith({
    Size? size,
    EdgeInsetsGeometry? padding,
    TDButtonStyle? style,
  }) {
    return TDProgressButtonConfig(
      size: size ?? this.size,
      padding: padding ?? this.padding,
      style: style ?? this.style,
    );
  }
}

// 其他枚举和类的定义
enum TDProgressType { line, circle, micro, microButton, lineButton }
enum TDProgressLabelPosition { left, right, inner }
enum TDProgressLabelType { none, text, icon, custom }

class TDProgressAnimationConfig {
  const TDProgressAnimationConfig({
    this.enabled = true,
    this.type = TDProgressAnimationType.linear,
    this.speed = 1.0,
  });

  final bool enabled;
  final TDProgressAnimationType type;
  final double speed;
}

enum TDProgressAnimationType { easeIn, easeOut, easeInOut, linear }