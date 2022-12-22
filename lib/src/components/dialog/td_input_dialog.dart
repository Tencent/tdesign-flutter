/*
 * Created by haozhicao@tencent.com on 6/20/22.
 * td_input_dialog.dart
 * 
 */

import 'package:flutter/material.dart';

import '../../../td_export.dart';
import '../../util/auto_size.dart';
import 'td_dialog_widget.dart';

/// 弹窗控件
class TDInputDialog extends StatelessWidget {
  const TDInputDialog({
    Key? key,
    required this.textEditingController,
    this.backgroundColor = Colors.white,
    this.radius = 8.0,
    this.title = '输入框标题',
    this.titleColor = Colors.black,
    this.content,
    this.hintText = '',
    this.contentColor,
    this.leftBtn,
    this.rightBtn,
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

  final TDDialogButton? leftBtn;
  final TDDialogButton? rightBtn;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
          width: 320.scale,
          decoration: BoxDecoration(
            color: backgroundColor, // 底色
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 31),
              child: Column(
                children: [
                  TDDialogInfoWidget(
                    title: title,
                    titleColor: titleColor,
                    content: content,
                    contentColor: contentColor,
                  ),
                  const TDDivider(height: 8, color: Colors.transparent),
                  Container(
                    color: Colors.white,
                    height: 48,
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
                ],
              ),
            ),
            const TDDivider(height: 1),
            _horizontalButtons(context),
          ])),
    );
  }

  Widget _horizontalButtons(BuildContext context) {
    final left =
        leftBtn ?? TDDialogButton(title: '取消', action: () {}, height: 56);
    final right =
        rightBtn ?? TDDialogButton(title: '好的', action: () {}, height: 56);
    return HorizontalTextButtons(
      leftBtn: left,
      rightBtn: right,
    );
  }
}
