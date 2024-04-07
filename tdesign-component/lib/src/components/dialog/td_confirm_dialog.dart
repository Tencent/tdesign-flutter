/*
 * Created by haozhicao@tencent.com on 6/20/22.
 * td_confirm_dialog.dart
 * 
 */

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 'td_dialog_widget.dart';

/// 只有一个按钮的弹窗控件
///
/// 按钮样式支持普通和文字
class TDConfirmDialog extends StatelessWidget {
  const TDConfirmDialog({
    Key? key,
    this.action,
    this.backgroundColor = Colors.white,
    this.radius = 12.0,
    this.title,
    this.titleColor = const Color(0xE6000000),
    this.titleAlignment,
    this.contentWidget,
    this.content,
    this.contentColor,
    this.contentMaxHeight = 0,
    this.buttonText = '知道了',
    this.buttonTextColor,
    this.buttonStyle = TDDialogButtonStyle.normal,
    this.showCloseButton,
  }) : super(key: key);

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

  /// 右上角关闭按钮
  final bool? showCloseButton;

  Widget _buildButton(BuildContext context) {
    if (buttonStyle == TDDialogButtonStyle.text) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TDDivider(height: 23, color: Colors.transparent),
          const TDDivider(height: 1),
          TDDialogButton(
            buttonText: buttonText,
            buttonTextColor: buttonTextColor,
            buttonType: TDButtonType.text,
            buttonTheme: TDButtonTheme.primary,
            height: 56,
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
          buttonTheme: TDButtonTheme.primary,
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
    return TDDialogScaffold(
        showCloseButton: showCloseButton,
        backgroundColor: backgroundColor,
        radius: radius,
        body: Column(mainAxisSize: MainAxisSize.min, children: [
          TDDialogInfoWidget(
            title: title,
            titleColor: titleColor,
            titleAlignment: titleAlignment,
            contentWidget: contentWidget,
            content: content,
            contentColor: contentColor,
            contentMaxHeight: contentMaxHeight,
          ),
          _buildButton(context),
        ]));
  }
}
