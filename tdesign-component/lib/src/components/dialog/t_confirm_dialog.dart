/*
 * Created by haozhicao@tencent.com on 6/20/22.
 * t_confirm_dialog.dart
 * 
 */

import 'package:flutter/material.dart';
import 'package:tdesign_icons/tdesign_icons.dart';

import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../button/t_button.dart';
import '../button/t_button_types.dart';
import '../divider/t_divider.dart';
import '../text/t_text.dart';
import 't_dialog.dart';
import 't_dialog_theme_data.dart';
import 't_dialog_widget.dart';

/// 只有一个按钮的弹窗控件
///
/// 按钮样式支持普通和文字
class TConfirmDialog extends StatelessWidget {
  const TConfirmDialog({
    Key? key,
    this.onPressed,
    this.backgroundColor,
    this.radius = 12.0,
    this.title,
    this.titleColor,
    this.titleAlignment,
    this.contentWidget,
    this.content,
    this.contentColor,
    this.contentMaxHeight = 0,
    this.buttonText,
    this.buttonTextColor,
    this.buttonStyle = TDialogButtonStyle.normal,
    this.showCloseButton,
    this.padding = const EdgeInsets.fromLTRB(24, 32, 24, 0),
    this.buttonWidget,
    this.width,
    this.buttonStyleCustom,
  }) : super(key: key);

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

  /// 内容颜色
  final Color? contentColor;

  /// 内容的最大高度，默认为0，也就是不限制高度
  final double contentMaxHeight;

  /// 按钮文字
  final String? buttonText;

  /// 按钮文字颜色
  final Color? buttonTextColor;

  /// 点击
  final VoidCallback? onPressed;

  /// 背景颜色
  final Color? backgroundColor;

  /// 按钮样式
  final TDialogButtonStyle buttonStyle;

  /// 圆角
  final double radius;

  /// 右上角关闭按钮
  final bool? showCloseButton;

  /// 内容内边距
  final EdgeInsets? padding;

  /// 自定义按钮
  final Widget? buttonWidget;

  /// 按钮自定义样式
  final ButtonStyle? buttonStyleCustom;

  /// 弹窗宽度。
  final double? width;

  Widget _buildButton(BuildContext context) {
    final theme = Theme.of(context).extension<TDialogThemeData>();
    final effectiveButtonStyle = buttonStyleCustom ?? theme?.actionButtonStyle;
    if (buttonWidget != null) {
      return buttonWidget!;
    }
    if (buttonStyle == TDialogButtonStyle.text) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 23),
          const TDivider(),
          TDialogButton(
            buttonText: buttonText ?? context.resource.knew,
            buttonTextColor: buttonTextColor,
            buttonVariant: TButtonVariant.text,
            buttonColorScheme: TButtonColorScheme.primary,
            height: 56,
            buttonStyle: effectiveButtonStyle,
            onPressed: () {
              if (onPressed != null) {
                onPressed!();
              } else {
                Navigator.pop(context);
              }
            },
          )
        ],
      );
    } else {
      return Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: TDialogButton(
          buttonText: buttonText ?? context.resource.knew,
          buttonTextColor: buttonTextColor,
          buttonColorScheme: TButtonColorScheme.primary,
          buttonStyle: effectiveButtonStyle,
          onPressed: () {
            if (onPressed != null) {
              onPressed!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 标题和内容不能同时为空
    assert((title != null || content != null || contentWidget != null));
    final theme = Theme.of(context).extension<TDialogThemeData>();
    final effectiveWidth = width ?? theme?.width;
    final effectiveBackgroundColor = backgroundColor ?? theme?.backgroundColor;
    final effectivePadding = padding == const EdgeInsets.fromLTRB(24, 32, 24, 0)
        ? theme?.contentPadding ?? padding
        : padding;
    final effectiveContentMaxHeight =
        contentMaxHeight > 0 ? contentMaxHeight : theme?.contentMaxHeight ?? 0;

    return TDialogScaffold(
        showCloseButton: showCloseButton,
        backgroundColor: effectiveBackgroundColor,
        width: effectiveWidth,
        radius: radius,
        body: LayoutBuilder(builder: (context, constraints) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            // 内容区域添加弹性约束 https://api.flutter.dev/flutter/widgets/Flexible-class.html
            Flexible(
              // 滚动支持
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: TDialogInfoWidget(
                  title: title,
                  titleColor: titleColor,
                  titleAlignment: titleAlignment,
                  contentWidget: contentWidget,
                  content: content,
                  contentColor: contentColor,
                  // 当contentMaxHeight未设置时，使用屏幕的60%作为最大高度，并允许滚动
                  contentMaxHeight: effectiveContentMaxHeight > 0
                      ? effectiveContentMaxHeight
                      : constraints.maxHeight * 0.6,
                  padding: effectivePadding,
                ),
              ),
            ),
            _buildButton(context),
          ]);
        }));
  }
}
