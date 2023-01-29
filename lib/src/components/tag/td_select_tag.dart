import 'package:flutter/material.dart';

import '../../../td_export.dart';

/// 点击型标签组件，点击时内部更改自身状态
/// 支持样式：方形/圆角/半圆/带关闭图标
class TDSelectTag extends StatefulWidget {
  const TDSelectTag(this.text,
      {this.theme,
      this.icon,
      this.selectStyle,
      this.unSelectStyle,
      this.disableSelectStyle,
      this.onSelectChanged,
      this.isSelected = false,
      this.disableSelect = false,
      this.size = TDTagSize.medium,
      this.padding,
      this.forceVerticalCenter = true,
      this.isStroke = false,
      this.isCircle = false,
      this.isLight = false,
      this.needCloseIcon = false,
      this.onCloseTap,
      Key? key})
      : super(key: key);

  /// 标签内容
  final String text;

  /// 主题
  final TDTagTheme? theme;

  /// 图标内容
  final Widget? icon;

  /// 选中的标签样式
  final TDTagStyle? selectStyle;

  /// 未选中标签样式
  final TDTagStyle? unSelectStyle;

  /// 不可选标签样式
  final TDTagStyle? disableSelectStyle;

  /// 标签点击，选中状态改变时的回调
  final ValueChanged<bool>? onSelectChanged;

  /// 是否选中
  final bool isSelected;

  /// 是否禁用选择
  final bool disableSelect;

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
    if (!widget.disableSelect) {
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
    if (widget.disableSelect) {
      return _getDisableSelectStyle();
    }
    return _isSelected ? _getSelectStyle() : _getUnSelectStyle();
  }

  TDTagStyle _getDisableSelectStyle() {
    if (widget.disableSelectStyle != null) {
      return widget.disableSelectStyle!;
    }
    return TDTagStyle.generateDisableSelectStyle(context,widget.isStroke, widget.isCircle);
  }

  TDTagStyle _getSelectStyle() {
    if (widget.selectStyle != null) {
      return widget.selectStyle!;
    }
    return widget.isStroke
        ? TDTagStyle.generateStrokeStyleByTheme(
            context, widget.theme, widget.isLight, widget.isCircle)
        : TDTagStyle.generateFillStyleByTheme(
            context, widget.theme, widget.isLight, widget.isCircle);
  }

  TDTagStyle _getUnSelectStyle() {
    if (widget.unSelectStyle != null) {
      return widget.unSelectStyle!;
    }
    return widget.isStroke
        ? TDTagStyle.generateStrokeStyleByTheme(
        context, TDTagTheme.defaultTheme, widget.isLight, widget.isCircle)
        : TDTagStyle.generateFillStyleByTheme(
        context, TDTagTheme.defaultTheme, widget.isLight, widget.isCircle);
  }

  @override
  void didUpdateWidget(covariant TDSelectTag oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isSelected = widget.isSelected;
  }
}
