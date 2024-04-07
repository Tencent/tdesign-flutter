/*
 * Created by haozhicao@tencent.com on 6/20/22.
 * td_input_dialog.dart
 * 
 */

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 'td_dialog_widget.dart';

/// 带有输入框的弹窗
class TDInputDialog extends StatelessWidget {
  const TDInputDialog({
    Key? key,
    required this.textEditingController,
    this.backgroundColor = Colors.white,
    this.radius = 12.0,
    this.title,
    this.titleColor = const Color(0xE6000000),
    this.titleAlignment,
    this.contentWidget,
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

  /// 标题对齐模式
  final AlignmentGeometry? titleAlignment;

  /// 内容Widget
  final Widget? contentWidget;

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
            titleAlignment: titleAlignment,
            contentWidget: contentWidget,
            content: content,
            contentColor: contentColor,
          ),
          Container(
            color: Colors.white,
            height: 48,
            margin: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: TextField(
              controller: textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none),
                hintText: hintText,
                hintStyle: const TextStyle(color: Color(0x66000000)),
                fillColor: const Color(0xFFF3F3F3),
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
        TDDialogButtonOptions(title: '取消', titleColor: const Color(0xE6000000), fontWeight: FontWeight.normal, action: () {}, height: 56);
    final right = rightBtn ??
        TDDialogButtonOptions(title: '确定', action: () {}, fontWeight: FontWeight.w600, height: 56);
    return HorizontalTextButtons(
      leftBtn: left,
      rightBtn: right,
    );
  }
}
