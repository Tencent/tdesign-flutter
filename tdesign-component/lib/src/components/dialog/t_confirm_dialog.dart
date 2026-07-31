import 'package:flutter/material.dart';

import '../../util/context_extension.dart';
import '../button/t_button_types.dart';
import 't_dialog.dart';

/// 单操作确认弹窗，是 [TDialog] 的便捷封装。
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
    this.semanticLabel,
    this.backgroundColor,
    this.shape,
    this.elevation,
    this.width,
    this.maxHeight,
    this.contentPadding,
    this.buttonStyle,
  }) : assert(content == null || contentWidget == null,
            'content and contentWidget cannot be used together.');

  final String? title;
  final String? content;
  final Widget? contentWidget;
  final String? buttonText;
  final VoidCallback? onPressed;
  final Object? result;
  final bool closeOnPressed;
  final bool showCloseButton;
  final String? semanticLabel;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final double? elevation;
  final double? width;
  final double? maxHeight;
  final EdgeInsetsGeometry? contentPadding;
  final ButtonStyle? buttonStyle;

  @override
  Widget build(BuildContext context) {
    return TDialog(
      title: title == null ? null : Text(title!),
      content: contentWidget ?? (content == null ? null : Text(content!)),
      showCloseButton: showCloseButton,
      semanticLabel: semanticLabel ?? title,
      backgroundColor: backgroundColor,
      shape: shape,
      elevation: elevation,
      width: width,
      maxHeight: maxHeight,
      contentPadding: contentPadding,
      actions: [
        TDialogAction(
          role: TDialogActionRole.primary,
          result: result,
          closeOnPressed: closeOnPressed,
          onPressed: onPressed,
          style: buttonStyle,
          colorScheme: TButtonColorScheme.primary,
          child: Text(buttonText ?? context.resource.knew),
        ),
      ],
    );
  }
}
