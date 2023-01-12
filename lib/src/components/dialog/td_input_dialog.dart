/*
 * Created by haozhicao@tencent.com on 6/20/22.
 * td_input_dialog.dart
 * 
 */

import 'package:flutter/material.dart';

import '../../../td_export.dart';
import '../../util/auto_size.dart';
import 'td_dialog_widget.dart';

/// 带有输入框的弹窗
class TDInputDialog extends StatelessWidget {
  const TDInputDialog({
    Key? key,
    required this.textEditingController,
    this.backgroundColor = Colors.white,
    this.radius = 8.0,
    this.title,
    this.titleColor = Colors.black,
    this.content,
    this.hintText = '',
    this.contentColor,
    this.leftBtn,
    this.rightBtn,
    this.showCloseButton,
  })  : assert((title != null || content != null)),
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

  /// 输入提示
  final String? hintText;

  /// 内容颜色
  final Color? contentColor;

  /// 输入controller
  final TextEditingController textEditingController;

  /// 左侧按钮配置
  final TDDialogButtonOptions? leftBtn;

  /// 右侧按钮配置
  final TDDialogButtonOptions? rightBtn;

  /// 显示右上角关闭按钮
  final bool? showCloseButton;

  @override
  Widget build(BuildContext context) {
    return TDDialogScaffold(
      showCloseButton: showCloseButton,
      backgroundColor: backgroundColor,
      radius: radius,
      body: Material(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TDDialogInfoWidget(
            title: title,
            titleColor: titleColor,
            content: content,
            contentColor: contentColor,
          ),
          Container(
            color: Colors.white,
            height: 48,
            margin: const EdgeInsets.fromLTRB(0, 8, 0, 24),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              controller: textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide.none),
                hintText: hintText,
                fillColor: const Color(0xfff0f0f0),
                filled: true,
                // labelText: '左上角',
              ),
            ),
          ),
          _horizontalButtons(context),
        ]),
      ),
    );
  }

  Widget _horizontalButtons(BuildContext context) {
    final left = leftBtn ??
        TDDialogButtonOptions(title: '取消', action: () {}, height: 56);
    final right = rightBtn ??
        TDDialogButtonOptions(title: '确定', action: () {}, height: 56);
    return HorizontalTextButtons(
      leftBtn: left,
      rightBtn: right,
    );
  }
}
