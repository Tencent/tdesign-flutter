import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../icon/t_icons.dart';
import 't_popup_config.dart';
import 't_popup_types.dart';

/// 构建 center 面板下方关闭控件（默认图标或 [closeBuilder]）。
Widget buildPopupCenterCloseControl({
  required BuildContext context,
  required TPopupConfig config,
  required VoidCallback onClose,
}) {
  if (isPopupDefaultClose(config.closeBuilder)) {
    final theme = TTheme.of(context);
    return IconButton(
      tooltip: context.resource.close,
      icon: Icon(
        TIcons.close_circle,
        color: theme.fontWhColor1,
        size: 32,
      ),
      onPressed: onClose,
    );
  }
  return config.closeBuilder!(context, onClose);
}

/// 居中浮层：白底内容区 + 面板**外下方**关闭控件（center 内置布局）。
class PopupCenterUnderClose extends StatelessWidget {
  const PopupCenterUnderClose({
    super.key,
    required this.config,
    required this.content,
    required this.onCloseWithTrigger,
  });

  final TPopupConfig config;
  final Widget content;
  final void Function(TPopupTrigger trigger) onCloseWithTrigger;

  @override
  Widget build(BuildContext context) {
    Widget panel = content;
    if (config.width != null || config.height != null) {
      panel = SizedBox(
        width: config.width,
        height: config.height,
        child: content,
      );
    }

    void close() {
      config.onCloseBtn?.call();
      onCloseWithTrigger(TPopupTrigger.closeBtn);
    }

    final closeControl = buildPopupCenterCloseControl(
      context: context,
      config: config,
      onClose: close,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        panel,
        const SizedBox(height: 24),
        closeControl,
      ],
    );
  }
}
