import 'package:flutter/material.dart';

import '../../../td_export.dart';

enum TDButtonSize { large, medium, small, extraSmall }

enum TDButtonType { fill, stroke, text, ghost }

enum TDButtonShape { rectangle, round, square, circle, filled }

enum TDButtonTheme { defaultTheme, primary, danger, light }

enum TDButtonStatus { defaultState, active, disable }

typedef TDButtonEvent = void Function();

/// TD常规按钮
class TDButton extends StatefulWidget {
  const TDButton(
      {Key? key,
      this.content,
      this.size = TDButtonSize.medium,
      this.type = TDButtonType.fill,
      this.shape = TDButtonShape.rectangle,
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
      this.onLongPress,
      this.margin,
      this.padding})
      : super(key: key);

  /// 自控件
  final Widget? child;

  /// 文本内容
  final String? content;

  /// 禁止点击
  final bool disabled;

  /// 自定义宽度
  final double? width;

  /// 自定义高度
  final double? height;

  /// 尺寸
  final TDButtonSize size;

  /// 类型：填充，描边，文字
  final TDButtonType type;

  /// 形状：圆角，胶囊，方形，圆形，填充
  final TDButtonShape shape;

  /// 主题
  final TDButtonTheme? theme;

  /// 自定义样式，有则优先用它，没有则根据type和theme选取
  final TDButtonStyle? style;

  /// 自定义点击样式，有则优先用它，没有则根据type和theme选取
  final TDButtonStyle? activeStyle;

  /// 自定义禁用样式，有则优先用它，没有则根据type和theme选取
  final TDButtonStyle? disableStyle;

  /// 自定义可点击状态文本样式
  final TextStyle? textStyle;

  /// 自定义不可点击状态文本样式
  final TextStyle? disableTextStyle;

  /// 点击事件
  final TDButtonEvent? onTap;

  /// 长按事件
  final TDButtonEvent? onLongPress;

  /// 图标icon
  final IconData? icon;

  /// 自定义padding
  final EdgeInsetsGeometry? padding;

  /// 自定义margin
  final EdgeInsetsGeometry? margin;

  /// 是否为通栏按钮
  final bool isBlock;

  @override
  State<StatefulWidget> createState() => _TDButtonState();
}

class _TDButtonState extends State<TDButton> {
  TDButtonStatus _buttonStatus = TDButtonStatus.defaultState;
  TDButtonStyle? _innerDefaultStyle;
  TDButtonStyle? _innerActiveStyle;
  TDButtonStyle? _innerDisableStyle;

  TDButtonStyle get style {
    switch(_buttonStatus){
      case TDButtonStatus.defaultState:
        return _defaultStyle;
      case TDButtonStatus.active:
        return _activeStyle;
      case TDButtonStatus.disable:
        return _disableStyle;
    }
  }

  @override
  void initState() {
    super.initState();
    if(widget.disabled){
      _buttonStatus = TDButtonStatus.disable;
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget display = Container(
      width: _getWidth(),
      height: _getHeight(),
      alignment: widget.shape == TDButtonShape.filled || widget.isBlock ? Alignment.center : null,
      padding: _getPadding(),
      margin: _getMargin(),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        border: _getBorder(context),
        borderRadius: BorderRadius.all(_getRadius()),
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
      onTapDown: (TapDownDetails details){
        if(widget.disabled){
          return;
        }
        setState(() {
          _buttonStatus = TDButtonStatus.active;
        });
      },
      onTapUp: (TapUpDetails details){
        if(widget.disabled){
          return;
        }
        setState(() {
          _buttonStatus = TDButtonStatus.defaultState;
        });
      },
      onTapCancel: (){
        if(widget.disabled){
          return;
        }
        setState(() {
          _buttonStatus = TDButtonStatus.defaultState;
        });
      },

    );
  }

  Border? _getBorder(BuildContext context) {
    if (style.frameWidth != null && style.frameWidth != 0) {
      return Border.all(
          color:
              style.frameColor ?? TDTheme.of(context).grayColor3,
          width: style.frameWidth!);
    }
    return null;
  }

  Widget _getChild() {
    if (widget.content == null && widget.icon == null) {
      return Container();
    }
    var children = <Widget>[];
    // 系统Icon会导致不居中，因此自绘icon指定height
    if (widget.icon != null) {
      var icon = RichText(
        overflow: TextOverflow.visible,
        text: TextSpan(
          text: String.fromCharCode(widget.icon!.codePoint),
          style: TextStyle(
            inherit: false,
            color:
                style.textColor,
            height: 1,
            fontSize: _getIconSize(),
            fontFamily: widget.icon!.fontFamily,
            package: widget.icon!.fontPackage,
          ),
        ),
      );
      children.add(icon);
    }
    if (widget.content != null) {
      var text = TDText(
        widget.content!,
        font: _getTextFont(),
        textColor:
            style.textColor ?? TDTheme.of(context).fontGyColor1,
        style: widget.disabled ? widget.disableTextStyle : widget.textStyle,
        forceVerticalCenter: true,
      );
      children.add(text);
    }

    if (children.length == 2) {
      children.insert(
        1,
        const SizedBox(
          width: 8,
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Font _getTextFont() {
    switch (widget.size) {
      case TDButtonSize.large:
        return TDTheme.of(context).fontBodyLarge ??
            Font(size: 16, lineHeight: 24);
      case TDButtonSize.medium:
        return TDTheme.of(context).fontBodyLarge ??
            Font(size: 16, lineHeight: 24);
      case TDButtonSize.small:
        return TDTheme.of(context).fontBodyMedium ??
            Font(size: 14, lineHeight: 22);
      case TDButtonSize.extraSmall:
        return TDTheme.of(context).fontBodyMedium ??
            Font(size: 14, lineHeight: 22);
    }
  }

  double? _getWidth() {
    if (widget.width != null) {
      return widget.width;
    }
    if (!widget.isBlock
        && (widget.shape == TDButtonShape.square ||
        widget.shape == TDButtonShape.circle)) {
      switch (widget.size) {
        case TDButtonSize.large:
          return 48;
        case TDButtonSize.medium:
          return 40;
        case TDButtonSize.small:
          return 32;
        case TDButtonSize.extraSmall:
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
      case TDButtonSize.large:
        return 48;
      case TDButtonSize.medium:
        return 40;
      case TDButtonSize.small:
        return 32;
      case TDButtonSize.extraSmall:
        return 28;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case TDButtonSize.large:
        return 24;
      case TDButtonSize.medium:
        return 22;
      case TDButtonSize.small:
        return 20;
      case TDButtonSize.extraSmall:
        return 20;
    }
  }

  EdgeInsetsGeometry? _getMargin(){
    if(widget.margin != null){
      return widget.margin;
    }
    return widget.isBlock ? const EdgeInsets.only(left: 16, right: 16) : null;
  }

  EdgeInsetsGeometry? _getPadding() {
    if (widget.padding != null) {
      return widget.padding;
    }
    var equalSide = widget.shape == TDButtonShape.square || widget.shape == TDButtonShape.circle;

    double horizontalPadding;
    double verticalPadding;
    switch (widget.size) {
      case TDButtonSize.large:
        horizontalPadding = equalSide ? 12 : 20;
        verticalPadding = 12;
        break;
      case TDButtonSize.medium:
        horizontalPadding = equalSide ? 10 : 16;
        verticalPadding = equalSide ? 10 : 8;
        break;
      case TDButtonSize.small:
        horizontalPadding = equalSide ? 7 : 12;
        verticalPadding = equalSide ? 7 : 5;
        break;
      case TDButtonSize.extraSmall:
        horizontalPadding = equalSide ? 5 : 8;
        verticalPadding = equalSide ? 5 : 3;
        break;
    }
    return EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        bottom: verticalPadding,
        top: verticalPadding);

  }

  @override
  void didUpdateWidget(covariant TDButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _innerDefaultStyle = widget.style ?? _innerDefaultStyle;
    _innerActiveStyle = widget.activeStyle ?? _innerActiveStyle;
    _innerDisableStyle = widget.disableStyle ?? _innerDisableStyle;
  }

  TDButtonStyle _generateInnerStyle() {
    switch (widget.type) {
      case TDButtonType.fill:
        return TDButtonStyle.generateFillStyleByTheme(context, widget.theme, _buttonStatus);
      case TDButtonType.stroke:
        return TDButtonStyle.generateStrokeStyleByTheme(context, widget.theme, _buttonStatus);
      case TDButtonType.text:
        return TDButtonStyle.generateTextStyleByTheme(context, widget.theme, _buttonStatus);
      case TDButtonType.ghost:
        return TDButtonStyle.generateGhostStyleByTheme(context, widget.theme, _buttonStatus);
    }
  }

  Radius _getRadius() {
    switch (widget.shape) {
      case TDButtonShape.rectangle:
      case TDButtonShape.square:
        return Radius.circular(TDTheme.of(context).radiusDefault);
      case TDButtonShape.round:
      case TDButtonShape.circle:
        return Radius.circular(TDTheme.of(context).radiusRound);
      case TDButtonShape.filled:
        return Radius.zero;
    }
  }

  TDButtonStyle get _defaultStyle {
    if (_innerDefaultStyle != null) {
      return _innerDefaultStyle!;
    }
    _innerDefaultStyle = widget.style ?? _generateInnerStyle();
    return _innerDefaultStyle!;
  }

  TDButtonStyle get _activeStyle {
    if (_innerActiveStyle != null) {
      return _innerActiveStyle!;
    }
    _innerActiveStyle = widget.style ?? _generateInnerStyle();
    return _innerActiveStyle!;
  }

  TDButtonStyle get _disableStyle {
    if (_innerDisableStyle != null) {
      return _innerDisableStyle!;
    }
    _innerDisableStyle = widget.style ?? _generateInnerStyle();
    return _innerDisableStyle!;
  }

}


