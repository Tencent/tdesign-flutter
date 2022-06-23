import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

/// 标签尺寸
enum TDTagSize { large, middle, small, custom }

/// 展示型标签组件，仅展示，内部不可更改自身状态
/// 支持样式：方形/圆角/半圆/带关闭图标
///
class TDTag extends StatelessWidget {
  /// 标签内容
  final String text;

  /// 标签样式
  final TDTagStyle? style;

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

  const TDTag(this.text,
      {
        this.style,
        this.size = TDTagSize.middle,
        this.padding,
        this.forceVerticalCenter = true,
        this.needCloseIcon = false,
        this.onCloseTap,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var innerStyle = style ?? RoundRectTagStyle(context: context);

    Widget child = TDText(
      text,
      forceVerticalCenter: forceVerticalCenter,
      textColor: innerStyle.getTextColor,
      font: innerStyle.font ?? _getFont(context),
      fontWeight: innerStyle.fontWeight,
    );

    if(needCloseIcon){
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
        child,
        GestureDetector(
          onTap: onCloseTap,
          child: Container(
            margin: const EdgeInsets.only(left: 2),
            child: Icon(TDIcons.close, color: innerStyle.getTextColor, size: 12,),
          ),
        ),
      ],);
    }

    return Container(
      padding: padding ?? _getPadding(),
      decoration: BoxDecoration(
          color: innerStyle.getBackgroundColor,
          border: Border.all(
              width: innerStyle.border,
              color: innerStyle.getWireFrameColor),
          borderRadius: innerStyle.getBorderRadius),
      child: child,
    );
  }

  Font? _getFont(BuildContext context) {
    switch (size) {
      case TDTagSize.large:
        return TDTheme.of(context).fontS;
      case TDTagSize.small:
        return TDTheme.of(context).fontXXS;
      default:
        return TDTheme.of(context).fontXS;
    }
  }

  EdgeInsets _getPadding() {
    /// 为了文本居中，修改了padding的值
    switch (size) {
      case TDTagSize.large:
        return const EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3);
      case TDTagSize.small:
        return const EdgeInsets.only(left: 7, right: 7, top: 1, bottom: 1);
      default:
        return const EdgeInsets.only(left: 11, right: 11, top: 1, bottom: 1);
    }
  }
}

/// 点击型标签组件，点击时内部更改自身状态
/// 支持样式：方形/圆角/半圆/带关闭图标
class TDSelectTag extends StatefulWidget {
  const TDSelectTag(this.text,{
    this.style,
    this.unSelectStyle,
    this.unEnableSelectStyle,
    this.onSelectChanged,
    this.isSelected = false,
    this.enableSelect = true,
    this.size = TDTagSize.middle,
    this.padding,
    this.forceVerticalCenter = true,
    this.needCloseIcon = false,
    this.onCloseTap,
    Key? key}) : super(key: key);


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
    Widget result = TDTag(widget.text,
      style: _getStyle(),
      size: widget.size,
      padding: widget.padding,
      forceVerticalCenter: widget.forceVerticalCenter,
      needCloseIcon: widget.needCloseIcon,
      onCloseTap: widget.onCloseTap,);
    if(widget.enableSelect){
      result = GestureDetector(
        onTap: (){
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
    if(!widget.enableSelect){
      return _getUnEnableSelectStyle();
    }
    return _isSelected ? widget.style : _getUnSelectStyle();
  }

  TDTagStyle _getUnEnableSelectStyle() {
    if(widget.unEnableSelectStyle != null){
      return widget.unEnableSelectStyle!;
    }
    return RoundRectTagStyle(
      context: context,
      textColor: TDTheme.of(context).fontGyColor4,
      backgroundColor: TDTheme.of(context).grayColor3,
    );
  }

  TDTagStyle _getUnSelectStyle() {
    if(widget.unSelectStyle != null){
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

