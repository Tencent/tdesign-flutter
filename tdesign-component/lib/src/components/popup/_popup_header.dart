import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../../util/t_toolbar_pressable.dart';
import '../text/t_text.dart';
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
    if (config.placement != TPopupPlacement.bottom || config.hasNoHeader) {
      return const SizedBox.shrink();
    }

    if (config.useCustomHeader) {
      return config.headerBuilder!(
        context,
        _buildHeaderData(context),
      );
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

    final title = _buildTitleWidget(context);
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

  TPopupHeaderData _buildHeaderData(BuildContext context) {
    final theme = TTheme.of(context);
    return TPopupHeaderData(
      title: _buildTitleWidget(context),
      cancel: config.showCancelSlot
          ? _buildCancelWidget(context, theme)
          : null,
      confirm: config.showConfirmSlot
          ? _buildConfirmWidget(context, theme)
          : null,
      onCancel: config.onCancel,
      onConfirm: config.onConfirm,
    );
  }

  Widget? _buildTitleWidget(BuildContext context) {
    if (config.titleWidget != null) {
      return config.titleWidget;
    }
    if (config.title != null && config.title!.isNotEmpty) {
      return TText(
        config.title!,
        textColor: TTheme.of(context).textColorPrimary,
        font: TTheme.of(context).fontTitleLarge,
        fontWeight: FontWeight.w700,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    return null;
  }

  Widget _buildCancelWidget(BuildContext context, TThemeData theme) {
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

  Widget _buildConfirmWidget(BuildContext context, TThemeData theme) {
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
