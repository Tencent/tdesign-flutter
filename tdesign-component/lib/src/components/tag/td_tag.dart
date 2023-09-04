import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

/// 展示型标签组件，仅展示，内部不可更改自身状态
/// 支持样式：方形/圆角/半圆/带关闭图标
///
class TDTag extends StatelessWidget {
  const TDTag(this.text,
      {this.theme,
      this.icon,
      this.iconWidget,
      this.textColor,
      this.backgroundColor,
      this.font,
      this.fontWeight,
      this.style,
      this.size = TDTagSize.medium,
      this.padding,
      this.forceVerticalCenter = true,
      this.isOutline = false,
      this.shape = TDTagShape.square,
      this.isLight = false,
      this.disable = false,
      this.needCloseIcon = false,
      this.onCloseTap,
      this.overflow,
      Key? key})
      : super(key: key);

  /// 标签内容
  final String text;

  /// 主题
  final TDTagTheme? theme;

  /// 图标内容，可随状态改变颜色
  final IconData? icon;

  /// 自定义图标内容，需自处理颜色
  final Widget? iconWidget;

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

  /// 标签形状
  final TDTagShape shape;

  /// 是否为浅色
  final bool isLight;

  /// 是否为禁用状态
  final bool disable;

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

    var innerIcon = getIcon(innerStyle);
    if (innerIcon != null || needCloseIcon) {
      var children = <Widget>[];
      if (innerIcon != null) {
        children.add(Container(
          margin: const EdgeInsets.only(right: 4),
          width: 14,
          height: 14,
          child: innerIcon,
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
      padding: padding ?? _getPadding(innerStyle.border),
      decoration: BoxDecoration(
          color: backgroundColor ?? innerStyle.getBackgroundColor,
          border: Border.all(
              width: innerStyle.border,
              color: innerStyle.getBorderColor),
          borderRadius: innerStyle.getBorderRadius),
      child: child,
    );
  }

  Widget? getIcon(TDTagStyle innerStyle){
    if(iconWidget != null){
      return iconWidget;
    }
    if(icon != null){
      return RichText(
        overflow: TextOverflow.visible,
        text: TextSpan(
          text: String.fromCharCode(icon!.codePoint),
          style: TextStyle(
            inherit: false,
            color:
            innerStyle.textColor,
            height: 1,
            fontSize: _getIconSize(),
            fontFamily: icon!.fontFamily,
            package: icon!.fontPackage,
          ),
        ),
      );
    }
    return null;
  }

  TDTagStyle _getInnerStyle(BuildContext context) {
    if (style != null) {
      return style!;
    }
    if(disable){
      return TDTagStyle.generateDisableSelectStyle(context, isOutline, shape);
    }
    return isOutline
        ? TDTagStyle.generateOutlineStyleByTheme(
            context, theme, isLight, shape)
        : TDTagStyle.generateFillStyleByTheme(
            context, theme, isLight, shape);
  }

  Font? _getFont(BuildContext context) {
    switch (size) {
      case TDTagSize.extraLarge:
        return TDTheme.of(context).fontBodyMedium;
      case TDTagSize.large:
        return TDTheme.of(context).fontBodyMedium;
      case TDTagSize.small:
        return TDTheme.of(context).fontBodyExtraSmall;
      default:
        return TDTheme.of(context).fontBodySmall;
    }
  }

  /// 计算padding，需去除描边的宽对，对内描边
  EdgeInsets _getPadding(double border) {
    var hPadding = 0.0;
    var vPadding = 0.0;
    switch (size) {
      case TDTagSize.extraLarge:
        hPadding = 16;
        vPadding = 9;
        break;
      case TDTagSize.large:
        hPadding = 8;
        vPadding = 3;
        break;
      case TDTagSize.medium:
        hPadding = 8;
        vPadding = 2;
        break;
      case TDTagSize.small:
        hPadding = 6;
        vPadding = 2;
        break;
      default:
        return EdgeInsets.zero;
    }
    if (hPadding >= border) {
      hPadding = hPadding - border;
    } else {
      hPadding = 0;
    }
    if (vPadding >= border) {
      vPadding = vPadding - border;
    } else {
      vPadding = 0;
    }
    return EdgeInsets.only(left: hPadding, right: hPadding, top: vPadding, bottom: vPadding);
  }

  double _getIconSize() {
    switch (size) {
      case TDTagSize.extraLarge:
        return 16;
      case TDTagSize.large:
        return 16;
      case TDTagSize.medium:
        return 14;
      case TDTagSize.small:
        return 12;
      default:
        return 14;
    }
  }
}

