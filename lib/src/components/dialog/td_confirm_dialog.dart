/*
 * Created by haozhicao@tencent.com on 6/20/22.
 * td_confirm_dialog.dart
 * 
 */

import 'package:flutter/material.dart';

import '../../../td_export.dart';
import '../../util/auto_size.dart';
import 'td_dialog_widget.dart';

/// 弹窗控件
class TDConfirmDialog extends StatelessWidget {
  const TDConfirmDialog({
    Key? key,
    this.action,
    this.backgroundColor = Colors.white,
    this.radius = 8.0,
    this.title,
    this.titleColor = Colors.black,
    this.content,
    this.contentColor,
    this.contentMaxHeight = 0,
    this.buttonText = '知道了',
    this.buttonTextColor,
    this.buttonStyle = TDDialogButtonStyle.normal,
  }) : super(key: key);

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

  /// 按钮文字
  final String? buttonText;

  /// 按钮文字颜色
  final Color? buttonTextColor;

  /// 点击
  final Function()? action;

  /// 背景颜色
  final Color backgroundColor;

  /// 按钮样式
  final TDDialogButtonStyle buttonStyle;

  /// 圆角
  final double radius;

  Widget _buildButton(BuildContext context) {
    if (buttonStyle == TDDialogButtonStyle.text) {
      return Column(
        children: [
          TDDivider(height: 23.scale, color: Colors.transparent),
          const TDDivider(height: 1),
          TDDialogButton(
            buttonText: buttonText,
            buttonTextColor: buttonTextColor,
            buttonStyle: TDButtonStyle.text(),
            height: 56.scale,
            onPressed: () {
              Navigator.pop(context);
              if (action != null) {
                action!();
              }
            },
          )
        ],
      );
    } else {
      return Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: TDDialogButton(
          buttonText: buttonText,
          buttonTextColor: buttonTextColor,
          onPressed: () {
            Navigator.pop(context);
            if (action != null) {
              action!();
            }
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 标题和内容不能同时为空
    assert((title != null || content != null));
    return Center(
        child: Container(
            width: 320.scale,
            decoration: BoxDecoration(
              color: backgroundColor, // 底色
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TDDialogInfoWidget(
                title: title,
                titleColor: titleColor,
                content: content,
                contentColor: contentColor,
                contentMaxHeight: contentMaxHeight,
              ),
              _buildButton(context),
            ])));
  }
}
