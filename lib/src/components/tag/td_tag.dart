import 'package:flutter/material.dart';
import '../../../td_export.dart';

/// Tag展示类型
enum TDTagTheme {
  /// 默认
  defaultTheme,

  /// 常规
  primary,

  /// 警告
  warning,

  /// 危险
  danger,

  /// 成功
  success,
}

/// 标签尺寸
enum TDTagSize { extraLarge, large, medium, small, custom }

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
      this.isStroke = false,
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
  final bool isStroke;

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
    return isStroke
        ? TDTagStyle.generateStrokeStyleByTheme(
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

/// 点击型标签组件，点击时内部更改自身状态
/// 支持样式：方形/圆角/半圆/带关闭图标
class TDSelectTag extends StatefulWidget {
  const TDSelectTag(this.text,
      {this.style,
      this.unSelectStyle,
      this.unEnableSelectStyle,
      this.onSelectChanged,
      this.isSelected = false,
      this.enableSelect = true,
      this.size = TDTagSize.medium,
      this.padding,
      this.forceVerticalCenter = true,
      this.needCloseIcon = false,
      this.onCloseTap,
      Key? key})
      : super(key: key);

  /// 标签内容
  final String text;

  /// 标签样式
  final TDTagStyle? style;

  /// 未选中标签样式
  final TDTagStyle? unSelectStyle;

  /// 不可选标签样式
  final TDTagStyle? unEnableSelectStyle;

  /// 标签点击，选中状态改变时的回调
  final ValueChanged<bool>? onSelectChanged;

  /// 是否选中
  final bool isSelected;

  /// 是否可点击选择
  final bool enableSelect;

  /// 标签大小
  final TDTagSize size;

  /// 自定义模式下的间距
  final EdgeInsets? padding;

  /// 是否强制中文文字居中
  final bool forceVerticalCenter;

  /// 关闭图标
  final bool needCloseIcon;

  /// 关闭图标点击事件
  final GestureTapCallback? onCloseTap;

  @override
  _TDClickTagState createState() => _TDClickTagState();
}

class _TDClickTagState extends State<TDSelectTag> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    Widget result = TDTag(
      widget.text,
      style: _getStyle(),
      size: widget.size,
      padding: widget.padding,
      forceVerticalCenter: widget.forceVerticalCenter,
      needCloseIcon: widget.needCloseIcon,
      onCloseTap: widget.onCloseTap,
    );
    if (widget.enableSelect) {
      result = GestureDetector(
        onTap: () {
          setState(() {
            _isSelected = !_isSelected;
            widget.onSelectChanged?.call(_isSelected);
          });
        },
        child: result,
      );
    }
    return result;
  }

  TDTagStyle? _getStyle() {
    if (!widget.enableSelect) {
      return _getUnEnableSelectStyle();
    }
    return _isSelected ? widget.style : _getUnSelectStyle();
  }

  TDTagStyle _getUnEnableSelectStyle() {
    if (widget.unEnableSelectStyle != null) {
      return widget.unEnableSelectStyle!;
    }
    return RoundRectTagStyle(
      context: context,
      textColor: TDTheme.of(context).fontGyColor4,
      backgroundColor: TDTheme.of(context).grayColor3,
    );
  }

  TDTagStyle _getUnSelectStyle() {
    if (widget.unSelectStyle != null) {
      return widget.unSelectStyle!;
    }
    return RoundRectTagStyle(
      context: context,
      textColor: TDTheme.of(context).fontGyColor1,
      backgroundColor: TDTheme.of(context).grayColor3,
    );
  }

  @override
  void didUpdateWidget(covariant TDSelectTag oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isSelected = widget.isSelected;
  }
}
