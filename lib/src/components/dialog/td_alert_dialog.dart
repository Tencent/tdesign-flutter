/*
 * Created by haozhicao@tencent.com on 6/20/22.
 * td_alert_dialog.dart
 * 
 */

import 'package:flutter/material.dart';

import '../../../td_export.dart';
import '../../util/auto_size.dart';
import 'td_dialog_widget.dart';

/// 弹窗控件
class TDAlertDialog extends StatelessWidget {
  const TDAlertDialog({
    Key? key,
    this.backgroundColor = Colors.white,
    this.radius = 8.0,
    this.title,
    this.titleColor = Colors.black,
    this.content,
    this.contentColor,
    this.contentMaxHeight = 0,
    this.leftBtn,
    this.rightBtn,
    this.showCloseButton,
    TDDialogButtonStyle buttonStyle = TDDialogButtonStyle.normal,
  })  : assert((title != null || content != null)),
        _vertical = false,
        _buttons = null,
        _buttonStyle = buttonStyle,
        super(key: key);

  /// 背景颜色
  final Color backgroundColor;

  /// 圆角
  final double radius;

  /// 标题
  final String? title;

  /// 标题颜色
  final Color titleColor;

  /// 内容
  final String? content;

  /// 内容颜色
  final Color? contentColor;

  /// 内容的最大高度，默认为0，也就是不限制高度
  final double contentMaxHeight;

  /// 显示右上角关闭按钮
  final bool? showCloseButton;

  // 选项是否是垂直排布，默认是左右排布
  final bool _vertical;

  // 垂直排布的按钮列表
  final List<TDDialogButtonOptions>? _buttons;

  final TDDialogButtonOptions? leftBtn;
  final TDDialogButtonOptions? rightBtn;

  final TDDialogButtonStyle _buttonStyle;

  const TDAlertDialog.vertical({
    Key? key,
    required List<TDDialogButtonOptions> buttons,
    this.backgroundColor = Colors.white,
    this.radius = 8.0,
    this.title,
    this.titleColor = Colors.black,
    this.content,
    this.contentColor,
    this.contentMaxHeight = 0,
    this.showCloseButton,
  })  : _vertical = true,
        leftBtn = null,
        rightBtn = null,
        _buttons = buttons,
        _buttonStyle = TDDialogButtonStyle.normal,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // 标题和内容不能同时为空
    return TDDialogScaffold(
        showCloseButton: showCloseButton,
        backgroundColor: backgroundColor,
        radius: radius,
        body: Column(mainAxisSize: MainAxisSize.min, children: [
          TDDialogInfoWidget(
            title: title,
            titleColor: titleColor,
            content: content,
            contentColor: contentColor,
            contentMaxHeight: contentMaxHeight,
          ),
          TDDivider(height: 24.scale, color: Colors.transparent),
          _vertical ? _verticalButtons(context) : _horizontalButtons(context),
        ]));
  }

  Widget _horizontalButtons(BuildContext context) {
    final left = leftBtn ?? TDDialogButtonOptions(title: '取消', action: () {});
    final right = rightBtn ?? TDDialogButtonOptions(title: '好的', action: () {});
    return _buttonStyle == TDDialogButtonStyle.text
        ? HorizontalTextButtons(leftBtn: left, rightBtn: right)
        : HorizontalNormalButtons(
            leftBtn: left,
            rightBtn: right,
          );
  }

  Widget _verticalButtons(BuildContext context) {
    var widgets = <Widget>[];
    _buttons!.asMap().forEach((index, value) {
      Widget btn = TDDialogButton(
        buttonText: value.title,
        buttonTextColor: value.titleColor,
        height: value.height,
        buttonTextFontWeight: value.fontWeight,
        buttonStyle: value.style,
        onPressed: () {
          Navigator.pop(context);
          value.action();
        },
      );
      widgets.add(btn);
      if (index < _buttons!.length - 1) {
        widgets.add(TDDivider(height: 12.scale, color: Colors.transparent));
      }
    });

    return Container(
      padding:
          EdgeInsets.only(left: 24.scale, right: 24.scale, bottom: 24.scale),
      child: Column(
        children: widgets,
      ),
    );
  }
}
