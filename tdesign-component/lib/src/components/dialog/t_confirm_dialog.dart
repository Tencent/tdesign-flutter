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

  /// 标题文字，null 时不展示。
  final String? title;
  /// 正文文字，与 contentWidget 互斥。
  final String? content;
  /// 自定义正文，与 content 互斥。
  final Widget? contentWidget;
  /// 确认按钮文案，null 时使用当前语言默认文案。
  final String? buttonText;
  /// 确认按钮动作，在自动关闭前调用；null 不禁用按钮。
  final VoidCallback? onPressed;
  /// 确认按钮自动关闭时返回的结果，默认 true。
  final Object? result;
  /// 确认按钮是否自动关闭，默认 true。
  final bool closeOnPressed;
  /// 是否显示右上角关闭按钮，默认 false。
  final bool showCloseButton;

  /// 内置关闭按钮成功关闭时返回的值，默认 null；透传至 [TDialog.closeButtonResult]。
  final Object? closeButtonResult;
  /// 无障碍标签，null 时回退到标题。
  final String? semanticLabel;
  /// 确认按钮样式覆盖，null 时使用组件主题。
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
