
import 'package:flutter/material.dart';

import '../../../td_export.dart';

enum TDButtonSize { small, medium, large }

typedef TDButtonEvent = void Function();

/// TD常规按钮
class TDButton extends StatefulWidget {

  const TDButton(
      {Key? key,
        required this.content,
        this.size = TDButtonSize.medium,
        this.child,
        this.disabled = false,
        this.style,
        this.textStyle,
        this.disableTextStyle,
        this.width,
        this.height,
        this.onTap,
        this.icon,
        this.onLongPress,
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
  /// 样式，强按钮，弱按钮，警告按钮等
  final TDButtonStyle? style;
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

  @override
  State<StatefulWidget> createState() => _TDButtonState();
}

class _TDButtonState extends State<TDButton> {

  TDButtonStyle? _innerStyle;

  TDButtonStyle get style {
    if(_innerStyle != null){
      return _innerStyle!;
    }
    _innerStyle = widget.style ?? TDButtonStyle.primary(context: context);
    return _innerStyle!;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = widget.width ?? _getWidth();

    Widget  display = Container(
      width:  width,
      height:  widget.height ?? _getHeight(),
      alignment: style.isFullWidth ? Alignment.center : null,
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: style.getBackgroundColor(context:context, disable: widget.disabled),
        border: _getBorder(context),
        borderRadius: BorderRadius.all(style.radius ?? Radius.zero),
      ),
      child: widget.child ?? _getChild(),
    );

    if(widget.disabled){
      return display;
    }
    return GestureDetector(
      child: display,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
    );
  }

  Border? _getBorder(BuildContext context) {
    if( style.frameWidth != null && style.frameWidth != 0){
      return Border.all(color: style.getFrameColor(context:context, disable: widget.disabled), width: style.frameWidth!);
    }
  }

  Widget _getChild() {
    if(widget.content == null && widget.icon == null){
      return Container();
    }
    var children = <Widget>[];
    // 系统Icon会导致不居中，因此自绘icon指定height
    if (widget.icon != null) {
      var icon =  RichText(
        overflow: TextOverflow.visible,
        text: TextSpan(
          text: String.fromCharCode(widget.icon!.codePoint),
          style: TextStyle(
            inherit: false,
            color: style.getTextColor(context: context, disable: widget.disabled),
            height: 1,
            fontSize: _getIconSize(),
            fontFamily:widget.icon!.fontFamily,
            package: widget.icon!.fontPackage,
          ),
        ),
      );
      children.add(icon);
    }
    if(widget.content != null){
      var text = TDText(widget.content!,
        font: _getTextFont(),
        textColor: style.getTextColor(context: context, disable: widget.disabled),
        style: widget.disabled ? widget.disableTextStyle : widget.textStyle,
        forceVerticalCenter: true,
      );
      children.add(text);
    }

    if(children.length == 2){
      children.insert(1, const SizedBox(width: 8,),);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Font _getTextFont() {
    switch(widget.size){
      case TDButtonSize.large:
        return TDTheme.of(context).fontM ?? Font(size: 16, lineHeight: 24);
      case TDButtonSize.medium:
        return TDTheme.of(context).fontS ?? Font(size: 14, lineHeight: 22);
      case TDButtonSize.small:
        return TDTheme.of(context).fontS ?? Font(size: 14, lineHeight: 22);
    }
  }

  double? _getWidth() {
    if(!style.isFullWidth){
      switch(widget.size){
        case TDButtonSize.large:
          return 343;
        case TDButtonSize.medium:
          return 343;
        case TDButtonSize.small:
        default:
      }
    }
  }

  double _getHeight() {
    switch(widget.size){
      case TDButtonSize.large:
        return 44;
      case TDButtonSize.medium:
        return 40;
      case TDButtonSize.small:
        return 36;
    }
  }

  double _getIconSize() {
    switch(widget.size){
      case TDButtonSize.large:
        return 24;
      case TDButtonSize.medium:
        return 22;
      case TDButtonSize.small:
        return 20;
    }
  }


  EdgeInsetsGeometry? _getPadding() {
    if(widget.padding != null){
      return widget.padding;
    }
    double topBottomPadding;
    switch(widget.size){
      case TDButtonSize.large:
        topBottomPadding = 10;
        break;
      case TDButtonSize.medium:
        topBottomPadding = 9;
        break;
      case TDButtonSize.small:
        topBottomPadding = 7;
        break;
    }
    return EdgeInsets.only(left: 16,right: 16,bottom: topBottomPadding,top: topBottomPadding);
  }

  @override
  void didUpdateWidget(covariant TDButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _innerStyle = widget.style ?? _innerStyle ;
  }

}

/// TD文字按钮
class TDTextButton extends StatefulWidget {
  final TDButtonSize size;
  final String? content;
  final bool disabled;
  final double? width;
  final double? height;
  final TextStyle? style;
  final TextStyle? disableStyle;
  final TDButtonEvent? onTap;
  final TDButtonEvent? onLongPress;

  const TDTextButton(
  this.content,{
    Key? key,
    this.size = TDButtonSize.medium,
    this.disabled = false,
    this.style,
    this.disableStyle,
    this.width,
    this.height,
    this.onTap,
    this.onLongPress
}) : super(key: key);

  @override
  State<TDTextButton> createState() => _TDTextButtonState();
}

class _TDTextButtonState extends State<TDTextButton> {


  late TextStyle? style;
  late TextStyle? disableStyle;

  @override
  void initState() {
    super.initState();
    style = widget.style ?? TextStyle(color: TDTheme.of().brandNormalColor);
    disableStyle = widget.disableStyle ?? TextStyle(color: TDTheme.of().brandDisabledColor);
  }

  @override
  Widget build(BuildContext context) {

    Widget  display = SizedBox(
      width:  widget.width,
      height:  widget.height ,
      child: TDText(widget.content!,
        font: _getTextFont(),
        style: widget.disabled ? disableStyle : style,
        forceVerticalCenter: true,
      ),
    );

    if(widget.disabled){
      return display;
    }
    return GestureDetector(
      child: display,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
    );
  }

  Font _getTextFont() {
    switch(widget.size){
      case TDButtonSize.large:
        return TDTheme.of(context).fontM ?? Font(size: 16, lineHeight: 24);
      case TDButtonSize.medium:
        return TDTheme.of(context).fontS ?? Font(size: 14, lineHeight: 22);
      case TDButtonSize.small:
        return TDTheme.of(context).fontS ?? Font(size: 14, lineHeight: 22);
    }
  }
}

