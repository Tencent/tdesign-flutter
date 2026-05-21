import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import '../../util/t_toolbar_pressable.dart';
import '../icon/t_icons.dart';
import 't_popup_config.dart';
import 't_popup_types.dart';

/// 内置标题栏区域（仅 [TPopupPlacement.bottom]）。
class PopupHeader extends StatelessWidget {
  const PopupHeader({
    super.key,
    required this.config,
    required this.onCloseWithTrigger,
  });

  final TPopupConfig config;
  final void Function(TPopupTrigger trigger) onCloseWithTrigger;

  static const double headerHeight = 58;

  @override
  Widget build(BuildContext context) {
    if (config.placement != TPopupPlacement.bottom) {
      return const SizedBox.shrink();
    }

    if (config.headerBuilder != null) {
      return config.headerBuilder!(context);
    }

    if (config.useActionHeader) {
      return SizedBox(
        height: headerHeight,
        child: _ActionHeader(
          config: config,
          onCloseWithTrigger: onCloseWithTrigger,
        ),
      );
    }

    final title = config.titleWidget ??
        (config.title != null && config.title!.isNotEmpty
            ? TText(
                config.title!,
                textColor: TTheme.of(context).textColorPrimary,
                font: TTheme.of(context).fontTitleLarge,
                fontWeight: FontWeight.w700,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null);

    if (title == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: headerHeight,
      child: Container(
        alignment: config.titleAlignLeft
            ? Alignment.centerLeft
            : Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: title,
      ),
    );
  }
}

class _ActionHeader extends StatelessWidget {
  const _ActionHeader({
    required this.config,
    required this.onCloseWithTrigger,
  });

  final TPopupConfig config;
  final void Function(TPopupTrigger trigger) onCloseWithTrigger;

  @override
  Widget build(BuildContext context) {
    final theme = TTheme.of(context);
    final title = config.titleWidget ??
        TText(
          config.title ?? '',
          textColor: theme.textColorPrimary,
          font: theme.fontTitleLarge,
          fontWeight: FontWeight.w700,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );

    return Row(
      children: [
        if (config.showCancelSlot)
          Padding(
            padding: EdgeInsets.only(left: theme.spacer8),
            child: Semantics(
              button: true,
              label: _cancelSemanticsLabel(context, config),
              excludeSemantics: true,
              child: TToolbarPressable(
                onTap: () {
                  config.onCancel?.call();
                  if (config.autoCloseOnCancel) {
                    onCloseWithTrigger(TPopupTrigger.cancelBtn);
                  }
                },
                child: _buildCancel(context, theme),
              ),
            ),
          )
        else
          SizedBox(width: theme.spacer16),
        Expanded(child: Center(child: title)),
        if (config.showConfirmSlot)
          Padding(
            padding: EdgeInsets.only(right: theme.spacer8),
            child: Semantics(
              button: true,
              label: _confirmSemanticsLabel(context, config),
              excludeSemantics: true,
              child: TToolbarPressable(
                onTap: () {
                  config.onConfirm?.call();
                  if (config.autoCloseOnConfirm) {
                    onCloseWithTrigger(TPopupTrigger.confirmBtn);
                  }
                },
                child: _buildConfirm(context, theme),
              ),
            ),
          )
        else
          SizedBox(width: theme.spacer16),
      ],
    );
  }

  Widget _buildCancel(BuildContext context, TThemeData theme) {
    if (config.cancelBuilder != null) {
      return config.cancelBuilder!(context);
    }
    if (TPopupConfig.isActionDefault(config.cancel)) {
      return TText(
        config.cancelBtn ?? context.resource.cancel,
        textColor: theme.textColorSecondary,
        font: theme.fontBodyLarge,
      );
    }
    return config.cancel!;
  }

  Widget _buildConfirm(BuildContext context, TThemeData theme) {
    if (config.confirmBuilder != null) {
      return config.confirmBuilder!(context);
    }
    if (TPopupConfig.isActionDefault(config.confirm)) {
      return TText(
        config.confirmBtn ?? context.resource.confirm,
        textColor: theme.brandNormalColor,
        font: theme.fontTitleMedium,
        fontWeight: FontWeight.w600,
      );
    }
    return config.confirm!;
  }
}

String _cancelSemanticsLabel(BuildContext context, TPopupConfig config) {
  final btn = config.cancelBtn;
  if (btn != null && btn.isNotEmpty) {
    return btn;
  }
  return context.resource.cancel;
}

String _confirmSemanticsLabel(BuildContext context, TPopupConfig config) {
  final btn = config.confirmBtn;
  if (btn != null && btn.isNotEmpty) {
    return btn;
  }
  return context.resource.confirm;
}

/// 居中：关闭按钮在内容下方。
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
    final theme = TTheme.of(context);
    Widget panel = content;
    if (config.width != null || config.height != null) {
      panel = SizedBox(
        width: config.width,
        height: config.height,
        child: content,
      );
    }

    Widget closeControl;
    if (config.closeBuilder != null) {
      closeControl = config.closeBuilder!(context);
    } else if (config.close != null) {
      closeControl = config.close!;
    } else {
      closeControl = IconButton(
        tooltip: context.resource.close,
        icon: Icon(
          TIcons.close_circle,
          color: theme.fontWhColor1,
          size: 32,
        ),
        onPressed: () {
          config.onCloseBtn?.call();
          onCloseWithTrigger(TPopupTrigger.closeBtn);
        },
      );
    }

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
