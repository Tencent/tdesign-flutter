/*
 * Created by haozhicao@tencent.com on 6/20/22.
 * td_alert_dialog.dart
 * 
 */

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/src/util/auto_size.dart';
import '../../../td_export.dart';
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
  })  : assert((title != null || content != null)),
        _vertical = false,
        _buttons = null,
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

  // 选项是否是垂直排布，默认是左右排布
  final bool _vertical;
  // 垂直排布的按钮列表
  final List<TDDialogButton>? _buttons;

  final TDDialogButton? leftBtn;
  final TDDialogButton? rightBtn;

  const TDAlertDialog.vertical({
    Key? key,
    required List<TDDialogButton> buttons,
    this.backgroundColor = Colors.white,
    this.radius = 8.0,
    this.title,
    this.titleColor = Colors.black,
    this.content,
    this.contentColor,
    this.contentMaxHeight = 0,
  })  : _vertical = true,
        leftBtn = null,
        rightBtn = null,
        _buttons = buttons,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // 标题和内容不能同时为空
    return Center(
        child: Container(
            width: 320.scale,
            decoration: BoxDecoration(
              color: backgroundColor, // 底色
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TDInfoWidget(
                title: title,
                titleColor: titleColor,
                content: content,
                contentColor: contentColor,
                contentMaxHeight: contentMaxHeight,
              ),
              const TDDivider(
                height: 1,
              ),
              _vertical
                  ? _verticalButtons(context)
                  : _horizontalButtons(context),
            ])));
  }

  Widget _horizontalButtons(BuildContext context) {
    final left = leftBtn ?? TDDialogButton(title: '取消', action: () {});
    final right =
        rightBtn ?? TDDialogButton(title: '好的', action: () {});
    return HorizontalButtons(
      leftBtn: left,
      rightBtn: right,
    );
  }

  Widget _verticalButtons(BuildContext context) {
    List<Widget> widgets = [];
    _buttons!.asMap().forEach((index, value) {
      Widget btn = TDDialogTextButton(
        buttonText: value.title,
        buttonTextColor: value.titleColor,
        onPressed: (){
          Navigator.pop(context);
          value.action();
        },
      );
      widgets.add(btn);
      if (index != _buttons!.length - 1) {
        widgets.add(
          const TDDivider(
            height: 1,
          ),
        );
      }
    });
    return Column(
      children: widgets,
    );
  }
}

/// 弹窗按钮
class TDDialogButton {
  Color? titleColor;
  FontWeight? fontWeight;
  final String title;
  final Function() action;

  TDDialogButton({
    required this.title,
    required this.action,
    this.titleColor,
    this.fontWeight,
  });
}
