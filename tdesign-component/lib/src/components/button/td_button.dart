import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

enum TButtonSize { large, medium, small, extraSmall }

enum TButtonType { fill, outline, text, ghost }

enum TButtonShape { rectangle, round, square, circle, filled }

enum TButtonTheme { defaultTheme, primary, danger, light }

enum TButtonStatus { defaultState, active, disable }

enum TButtonIconPosition { left, right }

typedef TButtonEvent = void Function();

/// TD常规按钮
class TButton extends StatefulWidget {
  const TButton({
    Key? key,
    this.text,
    this.size = TButtonSize.medium,
    this.type = TButtonType.fill,
    this.shape = TButtonShape.rectangle,
    this.theme,
    this.child,
    this.disabled = false,
    this.isBlock = false,
    this.style,
    this.activeStyle,
    this.disableStyle,
    this.textStyle,
    this.disableTextStyle,
    this.width,
    this.height,
    this.onTap,
    this.icon,
    this.iconWidget,
    this.iconTextSpacing,
    this.onLongPress,
    this.margin,
    this.padding,
    this.iconPosition = TButtonIconPosition.left,
    this.gradient,
  }) : super(key: key);

  /// 自控件
  final Widget? child;

  /// 文本内容
  final String? text;

  /// 禁止点击
  final bool disabled;

  /// 自定义宽度
  final double? width;

  /// 自定义高度
  final double? height;

  /// 尺寸
  final TButtonSize size;

  /// 类型：填充，描边，文字
  final TButtonType type;

  /// 形状：圆角，胶囊，方形，圆形，填充
  final TButtonShape shape;

  /// 主题
  final TButtonTheme? theme;

  /// 自定义样式，有则优先用它，没有则根据 type 和 theme 选取。如果设置了 style，则 activeStyle 和 disableStyle 也应该设置
  final TButtonStyle? style;

  /// 自定义点击样式，有则优先用它，没有则根据 type 和 theme 选取
  final TButtonStyle? activeStyle;

  /// 自定义禁用样式，有则优先用它，没有则根据 type 和 theme 选取
  final TButtonStyle? disableStyle;

  /// 自定义可点击状态文本样式
  final TextStyle? textStyle;

  /// 自定义不可点击状态文本样式
  final TextStyle? disableTextStyle;

  /// 点击事件
  final TButtonEvent? onTap;

  /// 长按事件
  final TButtonEvent? onLongPress;

  /// 图标icon
  final IconData? icon;

  /// 自定义图标 icon 控件
  final Widget? iconWidget;

  /// 自定义图标与文本之间距离
  final double? iconTextSpacing;

  /// 图标位置
  final TButtonIconPosition? iconPosition;

  /// 自定义 padding
  final EdgeInsetsGeometry? padding;

  /// 自定义 margin
  final EdgeInsetsGeometry? margin;

  /// 是否为通栏按钮
  final bool isBlock;

  /// 渐变背景色，优先级高于backgroundColor
  final Gradient? gradient;

  @override
  State<StatefulWidget> createState() => _TButtonState();
}

class _TButtonState extends State<TButton> {
  TButtonStatus _buttonStatus = TButtonStatus.defaultState;
  TButtonStyle? _innerDefaultStyle;
  TButtonStyle? _innerActiveStyle;
  TButtonStyle? _innerDisableStyle;
  double? _width;
  double? _height;
  EdgeInsetsGeometry? _margin;
  Alignment? _alignment;
  TextStyle? _textStyle;
  double? _iconSize;

  _updateParams() {
    _buttonStatus =
        widget.disabled ? TButtonStatus.disable : TButtonStatus.defaultState;
    _innerDefaultStyle = widget.style;
    _innerActiveStyle = widget.activeStyle;
    _innerDisableStyle = widget.disableStyle;
    _width = _getWidth();
    _height = _getHeight();
    _margin = _getMargin();
    _alignment = widget.shape == TButtonShape.filled || widget.isBlock
        ? Alignment.center
        : null;
    if (widget.text != null) {
      _textStyle = widget.disabled ? widget.disableTextStyle : widget.textStyle;
    }
    if (widget.icon != null) {
      _iconSize = _getIconSize();
    }
  }

  TButtonStyle get style {
    switch (_buttonStatus) {
      case TButtonStatus.defaultState:
        return _defaultStyle;
      case TButtonStatus.active:
        return _activeStyle;
      case TButtonStatus.disable:
        return _disableStyle;
    }
  }

  @override
  void initState() {
    super.initState();
    _updateParams();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateParams();
  }


  @override
  Widget build(BuildContext context) {
    Widget display = Container(
      width: _width,
      height: _height,
      alignment: _alignment,
      padding: _getPadding(),
      margin: _margin,
      decoration: BoxDecoration(
        color: widget.gradient != null ? null : style.backgroundColor,
        gradient: widget.gradient,
        border: _getBorder(context),
        borderRadius: style.radius ?? BorderRadius.all(_getRadius()),
      ),
      child: widget.child ?? _getChild(),
    );

    if (widget.disabled) {
      return display;
    }
    return GestureDetector(
      child: display,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: (TapDownDetails details) {
        if (widget.disabled) {
          return;
        }
        setState(() {
          _buttonStatus = TButtonStatus.active;
        });
      },
      onTapUp: (TapUpDetails details) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && !widget.disabled) {
            setState(() {
              _buttonStatus = TButtonStatus.defaultState;
            });
          }
        });
      },
      onTapCancel: () {
        if (widget.disabled) {
          return;
        }
        setState(() {
          _buttonStatus = TButtonStatus.defaultState;
        });
      },
    );
  }

  Border? _getBorder(BuildContext context) {
    if (style.frameWidth != null && style.frameWidth != 0) {
      return Border.all(
        color: style.frameColor ?? TTheme.of(context).componentStrokeColor,
        width: style.frameWidth!,
      );
    }
    return null;
  }

  Widget _getChild() {
    var icon = _getIcon();
    if (widget.text == null && icon == null) {
      return Container();
    }
    var children = <Widget>[];
    // 系统Icon会导致不居中，因此自绘icon指定height
    if (icon != null && widget.iconPosition == TButtonIconPosition.left) {
      children.add(icon);
    }
    if (widget.text != null) {
      var text = TText(
        widget.text!,
        font: _getTextFont(),
        textColor: style.textColor ?? TTheme.of(context).textColorPrimary,
        style: _textStyle,
        forceVerticalCenter: true,
        overflow: TextOverflow.ellipsis,
      );
      children.add(Flexible(child: text));
    }
    if (icon != null && widget.iconPosition == TButtonIconPosition.right) {
      children.add(icon);
    }

    if (children.length == 2) {
      children.insert(
        1,
        SizedBox(width: widget.iconTextSpacing ?? 8),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget? _getIcon() {
    if (widget.iconWidget != null) {
      return widget.iconWidget;
    }
    if (widget.icon != null) {
      return Icon(
        widget.icon,
        size: _iconSize,
        color: style.textColor,
      );
      return RichText(
        overflow: TextOverflow.visible,
        text: TextSpan(
          text: String.fromCharCode(widget.icon!.codePoint),
          style: TextStyle(
            inherit: false,
            color: style.textColor,
            height: 1,
            fontSize: _iconSize,
            fontFamily: widget.icon!.fontFamily,
            package: widget.icon!.fontPackage,
          ),
        ),
      );
    }

    return null;
  }

  Font _getTextFont() {
    switch (widget.size) {
      case TButtonSize.large:
        return TTheme.of(context).fontMarkLarge ??
            Font(size: 16, lineHeight: 24);
      case TButtonSize.medium:
        return TTheme.of(context).fontMarkLarge ??
            Font(size: 16, lineHeight: 24);
      case TButtonSize.small:
        return TTheme.of(context).fontMarkMedium ??
            Font(size: 14, lineHeight: 22);
      case TButtonSize.extraSmall:
        return TTheme.of(context).fontMarkMedium ??
            Font(size: 14, lineHeight: 22);
    }
  }

  double? _getWidth() {
    if (widget.width != null) {
      return widget.width;
    }
    if (!widget.isBlock &&
        (widget.shape == TButtonShape.square ||
            widget.shape == TButtonShape.circle)) {
      switch (widget.size) {
        case TButtonSize.large:
          return 48;
        case TButtonSize.medium:
          return 40;
        case TButtonSize.small:
          return 32;
        case TButtonSize.extraSmall:
          return 28;
      }
    }
    return null;
  }

  double _getHeight() {
    if (widget.height != null) {
      return widget.height!;
    }
    switch (widget.size) {
      case TButtonSize.large:
        return 48;
      case TButtonSize.medium:
        return 40;
      case TButtonSize.small:
        return 32;
      case TButtonSize.extraSmall:
        return 28;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case TButtonSize.large:
        return 24;
      case TButtonSize.medium:
        return 20;
      case TButtonSize.small:
        return 18;
      case TButtonSize.extraSmall:
        return 14;
    }
  }

  EdgeInsetsGeometry? _getMargin() {
    if (widget.margin != null) {
      return widget.margin;
    }
    return widget.isBlock ? const EdgeInsets.symmetric(horizontal: 16) : null;
  }

  EdgeInsetsGeometry? _getPadding() {
    if (widget.padding != null) {
      return widget.padding;
    }
    var equalSide = widget.shape == TButtonShape.square ||
        widget.shape == TButtonShape.circle;

    double horizontalPadding;
    double verticalPadding;
    switch (widget.size) {
      case TButtonSize.large:
        horizontalPadding = equalSide ? 12 : 20;
        verticalPadding = 12;
        break;
      case TButtonSize.medium:
        horizontalPadding = equalSide ? 10 : 16;
        verticalPadding = equalSide ? 10 : 8;
        break;
      case TButtonSize.small:
        horizontalPadding = equalSide ? 7 : 12;
        verticalPadding = equalSide ? 7 : 5;
        break;
      case TButtonSize.extraSmall:
        horizontalPadding = equalSide ? 5 : 8;
        verticalPadding = equalSide ? 5 : 3;
        break;
    }
    if (style.frameWidth != null && style.frameWidth != 0) {
      horizontalPadding = horizontalPadding - style.frameWidth!;
      verticalPadding = verticalPadding - style.frameWidth!;
      if (horizontalPadding < 0) {
        horizontalPadding = 0;
      }
      if (verticalPadding < 0) {
        verticalPadding = 0;
      }
    }
    return EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        bottom: verticalPadding,
        top: verticalPadding);
  }

  @override
  void didUpdateWidget(covariant TButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateParams();
  }

  TButtonStyle _generateInnerStyle() {
    switch (widget.type) {
      case TButtonType.fill:
        return TButtonStyle.generateFillStyleByTheme(
            context, widget.theme, _buttonStatus);
      case TButtonType.outline:
        return TButtonStyle.generateOutlineStyleByTheme(
            context, widget.theme, _buttonStatus);
      case TButtonType.text:
        return TButtonStyle.generateTextStyleByTheme(
            context, widget.theme, _buttonStatus);
      case TButtonType.ghost:
        return TButtonStyle.generateGhostStyleByTheme(
            context, widget.theme, _buttonStatus);
    }
  }

  Radius _getRadius() {
    switch (widget.shape) {
      case TButtonShape.rectangle:
      case TButtonShape.square:
        return Radius.circular(TTheme.of(context).radiusDefault);
      case TButtonShape.round:
      case TButtonShape.circle:
        return Radius.circular(TTheme.of(context).radiusRound);
      case TButtonShape.filled:
        return Radius.zero;
    }
  }

  TButtonStyle get _defaultStyle {
    if (_innerDefaultStyle != null) {
      return _innerDefaultStyle!;
    }
    _innerDefaultStyle = widget.style ?? _generateInnerStyle();
    return _innerDefaultStyle!;
  }

  TButtonStyle get _activeStyle {
    if (_innerActiveStyle != null) {
      return _innerActiveStyle!;
    }
    _innerActiveStyle = widget.style ?? _generateInnerStyle();
    return _innerActiveStyle!;
  }

  TButtonStyle get _disableStyle {
    if (_innerDisableStyle != null) {
      return _innerDisableStyle!;
    }
    _innerDisableStyle = widget.style ?? _generateInnerStyle();
    return _innerDisableStyle!;
  }
}
