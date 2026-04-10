/*
 * Created by haozhicao@tencent.com on 6/20/22.
 * t_input_dialog.dart
 * 
 */

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import 't_dialog_widget.dart';

/// 带有输入框的弹窗
class TInputDialog extends StatelessWidget {
  const TInputDialog({
    Key? key,
    required this.textEditingController,
    this.backgroundColor,
    this.radius = 12.0,
    this.title,
    this.titleColor,
    this.titleAlignment,
    this.contentWidget,
    this.content,
    this.hintText = '',
    this.contentColor,
    this.leftBtn,
    this.rightBtn,
    this.showCloseButton,
    this.padding = const EdgeInsets.fromLTRB(24, 32, 24, 0),
    this.buttonWidget,
    this.customInputWidget,
  })  : assert((title != null || content != null || contentWidget != null)),
        super(key: key);

  /// 背景颜色
  final Color? backgroundColor;

  /// 圆角
  final double radius;

  /// 标题
  final String? title;

  /// 标题颜色
  final Color? titleColor;

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
  final TDialogButtonOptions? leftBtn;

  /// 右侧按钮配置
  final TDialogButtonOptions? rightBtn;

  /// 显示右上角关闭按钮
  final bool? showCloseButton;

  /// 内容内边距
  final EdgeInsets? padding;

  /// 自定义按钮
  final Widget? buttonWidget;

  /// 自定义输入框
  final Widget? customInputWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: TDialogScaffold(
          showCloseButton: showCloseButton,
          backgroundColor: backgroundColor,
          radius: radius,
          body: Column(mainAxisSize: MainAxisSize.min, children: [
            TDialogInfoWidget(
              title: title,
              titleColor: titleColor,
              titleAlignment: titleAlignment,
              contentWidget: contentWidget,
              content: content,
              contentColor: contentColor,
              padding: padding,
            ),
            customInputWidget != null
                ? customInputWidget!
                : Container(
                    margin: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: TextField(
                      controller: textEditingController,
                      autofocus: true,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                TTheme.of(context).radiusDefault),
                            borderSide: BorderSide.none),
                        hintText: hintText,
                        hintStyle: TextStyle(
                            color: TTheme.of(context).textColorPlaceholder),
                        fillColor: TTheme.of(context).bgColorComponent,
                        filled: true,
                        // labelText: '左上角',
                      ),
                    ),
                  ),
            _horizontalButtons(context),
          ])),
    );
  }

  Widget _horizontalButtons(BuildContext context) {
    if (buttonWidget != null) {
      return buttonWidget!;
    }
    final left = leftBtn ??
        TDialogButtonOptions(
            title: context.resource.cancel,
            titleColor: TTheme.of(context).textColorPrimary,
            fontWeight: FontWeight.normal,
            action: null,
            height: 56);
    final right = rightBtn ??
        TDialogButtonOptions(
            title: context.resource.confirm,
            action: null,
            fontWeight: FontWeight.w600,
            height: 56);
    return HorizontalTextButtons(
      leftBtn: left,
      rightBtn: right,
    );
  }
}
