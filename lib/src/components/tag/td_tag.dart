import 'package:flutter/material.dart';
import '../../../td_export.dart';

/// 展示型标签组件，仅展示，内部不可更改自身状态
/// 支持样式：方形/圆角/半圆/带关闭图标
///
class TDTag extends StatelessWidget {
  const TDTag(this.text,
      {this.theme,
      this.icon,
      this.textColor,
      this.backgroundColor,
      this.font,
      this.fontWeight,
      this.style,
      this.size = TDTagSize.medium,
      this.padding,
      this.forceVerticalCenter = true,
      this.isOutline = false,
      this.isCircle = false,
      this.isLight = false,
      this.needCloseIcon = false,
      this.onCloseTap,
      this.overflow,
      Key? key})
      : super(key: key);

  /// 标签内容
  final String text;

  /// 主题
  final TDTagTheme? theme;

  /// 图标内容
  final Widget? icon;

  /// 文字颜色, 优先级高于style的textColor
  final Color? textColor;

  /// 背景颜色, 优先级高于style的backgroundColor
  final Color? backgroundColor;

  /// 字体尺寸, 优先级高于style的font
  final Font? font;

  /// 字体粗细, 优先级高于style的fontWeight
  final FontWeight? fontWeight;

  /// 标签样式
  final TDTagStyle? style;

  /// 标签大小
  final TDTagSize size;

  /// 自定义模式下的间距
  final EdgeInsets? padding;

  /// 是否强制中文文字居中
  final bool forceVerticalCenter;

  /// 是否为描边类型，默认不是
  final bool isOutline;

  /// 是否为圆角类型，默认不是
  final bool isCircle;

  /// 是否为浅色
  final bool isLight;

  /// 关闭图标
  final bool needCloseIcon;

  /// 文字溢出处理
  final TextOverflow? overflow;

  /// 关闭图标点击事件
  final GestureTapCallback? onCloseTap;

  @override
  Widget build(BuildContext context) {
    var innerStyle = _getInnerStyle(context);

    Widget child = TDText(
      text,
      overflow: overflow,
      forceVerticalCenter: forceVerticalCenter,
      textColor: textColor ?? innerStyle.getTextColor,
      font: font ?? innerStyle.font ?? _getFont(context),
      fontWeight: fontWeight ?? innerStyle.fontWeight,
    );

    if (icon != null || needCloseIcon) {
      var children = <Widget>[];
      if (icon != null) {
        children.add(Container(
          margin: const EdgeInsets.only(right: 4),
          width: 14,
          height: 14,
          child: icon!,
        ));
      }
      children.add(child);
      if (needCloseIcon) {
        children.add(GestureDetector(
          onTap: onCloseTap,
          child: Container(
            margin: const EdgeInsets.only(left: 4),
            child: Icon(
              TDIcons.close,
              color: TDTheme.of(context).fontGyColor3,
              size: 14,
            ),
          ),
        ));
      }
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }

    return Container(
      padding: padding ?? _getPadding(),
      decoration: BoxDecoration(
          color: backgroundColor ?? innerStyle.getBackgroundColor,
          border: Border.all(
              width: innerStyle.border, color: innerStyle.getBorderColor),
          borderRadius: innerStyle.getBorderRadius),
      child: child,
    );
  }

  TDTagStyle _getInnerStyle(BuildContext context) {
    if (style != null) {
      return style!;
    }
    return isOutline
        ? TDTagStyle.generateOutlineStyleByTheme(
            context, theme, isLight, isCircle)
        : TDTagStyle.generateFillStyleByTheme(
            context, theme, isLight, isCircle);
  }

  Font? _getFont(BuildContext context) {
    switch (size) {
      case TDTagSize.large:
        return TDTheme.of(context).fontBodyMedium;
      case TDTagSize.small:
        return TDTheme.of(context).fontBodyExtraSmall;
      default:
        return TDTheme.of(context).fontBodySmall;
    }
  }

  EdgeInsets _getPadding() {
    /// 为了文本居中，修改了padding的值
    switch (size) {
      case TDTagSize.extraLarge:
        return const EdgeInsets.only(left: 16, right: 16, top: 9, bottom: 9);
      case TDTagSize.large:
        return const EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3);
      case TDTagSize.medium:
        return const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2);
      case TDTagSize.small:
        return const EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2);
      default:
        return EdgeInsets.zero;
    }
  }
}

