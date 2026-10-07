import 'package:flutter/material.dart';

import '../../util/context_extension.dart';
import '../button/t_button_types.dart';
import 't_dialog.dart';

/// 单操作确认弹窗，是 [TDialog] 的便捷封装。
///
/// 内置操作使用 [TDialogActionRole.primary]，默认渲染为品牌色填充按钮。需要多个
/// 操作、文字按钮 Footer 或其他按钮变体时，使用 [TDialog] 和
/// [TDialog.actions] 组合 [TDialogAction]。
class TConfirmDialog extends StatelessWidget {
  const TConfirmDialog({
    super.key,
    this.title,
    this.content,
    this.contentWidget,
    this.buttonText,
    this.onPressed,
    this.result = true,
    this.closeOnPressed = true,
    this.showCloseButton = false,
    this.closeButtonResult,
    this.semanticLabel,
    this.buttonStyle,
  }) : assert(
         content == null || contentWidget == null,
         'content and contentWidget cannot be used together.',
       );

  /// 标题文案；为空时不显示标题。
  final String? title;

  /// 正文文案，与 [contentWidget] 互斥；为空时不显示文字正文。
  final String? content;

  /// 自定义正文组件，与 [content] 互斥。
  final Widget? contentWidget;

  /// 确认按钮文案；为空时使用资源代理的 knew 文案。
  final String? buttonText;

  /// 确认按钮点击回调；关闭行为由 [closeOnPressed] 决定。
  final VoidCallback? onPressed;

  /// 确认操作成功关闭弹窗时返回给路由的值，默认 true。
  final Object? result;

  /// 确认按钮点击后是否关闭弹窗，默认 true。
  final bool closeOnPressed;

  /// 是否显示内置关闭按钮，默认 false。
  final bool showCloseButton;

  /// 内置关闭按钮成功关闭时返回的值，默认 null；透传至 [TDialog.closeButtonResult]。
  final Object? closeButtonResult;

  /// 弹窗的无障碍语义标签；为空时使用 [title]。
  final String? semanticLabel;

  /// 内置确认按钮的显式 Material 样式；透传至 TDialogAction.style。
  final ButtonStyle? buttonStyle;

  @override
  Widget build(BuildContext context) {
    return TDialog(
      title: title == null ? null : Text(title!),
      content: contentWidget ?? (content == null ? null : Text(content!)),
      showCloseButton: showCloseButton,
      closeButtonResult: closeButtonResult,
      semanticLabel: semanticLabel ?? title,
      actions: [
        TDialogAction(
          role: TDialogActionRole.primary,
          result: result,
          closeOnPressed: closeOnPressed,
          onPressed: onPressed,
          style: buttonStyle,
          child: Text(buttonText ?? context.resource.knew),
        ),
      ],
    );
  }
}
