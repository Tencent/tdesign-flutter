import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../../util/t_toolbar_pressable.dart';
import '../text/t_text.dart';
import 't_popup_options.dart';
import 't_popup_types.dart';

/// 内置标题栏区域（仅 [TPopupPlacement.bottom]）。
class PopupHeader extends StatelessWidget {
  const PopupHeader({
    super.key,
    required this.options,
    required this.onCloseWithTrigger,
  });

  final TPopupOptions options;
  final void Function(TPopupTrigger trigger) onCloseWithTrigger;

  static const double headerHeight = 58;

  @override
  Widget build(BuildContext context) {
    if (options.placement != TPopupPlacement.bottom || options.hasNoHeader) {
      return const SizedBox.shrink();
    }

    if (options.useCustomHeader) {
      return options.headerBuilder!(
        context,
        _buildHeaderData(context),
      );
    }

    if (options.useActionHeader) {
      return SizedBox(
        height: headerHeight,
        child: _ActionHeader(
          options: options,
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
        alignment:
            options.titleAlignLeft ? Alignment.centerLeft : Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: title,
      ),
    );
  }

  TPopupHeaderData _buildHeaderData(BuildContext context) {
    final theme = TTheme.of(context);
    return TPopupHeaderData(
      title: _buildTitleWidget(context),
      cancel:
          options.showCancelSlot ? _buildCancelWidget(context, theme) : null,
      confirm:
          options.showConfirmSlot ? _buildConfirmWidget(context, theme) : null,
      onCancel: options.onCancel,
      onConfirm: options.onConfirm,
    );
  }

  Widget? _buildTitleWidget(BuildContext context) {
    if (options.titleWidget != null) {
      return options.titleWidget;
    }
    if (options.title != null && options.title!.isNotEmpty) {
      return TText(
        options.title!,
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
    if (options.cancelBuilder != null) {
      return options.cancelBuilder!(context);
    }
    if (TPopupOptions.isActionDefault(options.cancel)) {
      return TText(
        options.cancelBtn ?? context.resource.cancel,
        textColor: theme.textColorSecondary,
        font: theme.fontBodyLarge,
      );
    }
    return options.cancel!;
  }

  Widget _buildConfirmWidget(BuildContext context, TThemeData theme) {
    if (options.confirmBuilder != null) {
      return options.confirmBuilder!(context);
    }
    if (TPopupOptions.isActionDefault(options.confirm)) {
      return TText(
        options.confirmBtn ?? context.resource.confirm,
        textColor: theme.brandNormalColor,
        font: theme.fontTitleMedium,
        fontWeight: FontWeight.w600,
      );
    }
    return options.confirm!;
  }
}

class _ActionHeader extends StatelessWidget {
  const _ActionHeader({
    required this.options,
    required this.onCloseWithTrigger,
  });

  final TPopupOptions options;
  final void Function(TPopupTrigger trigger) onCloseWithTrigger;

  @override
  Widget build(BuildContext context) {
    final theme = TTheme.of(context);
    final title = options.titleWidget ??
        TText(
          options.title ?? '',
          textColor: theme.textColorPrimary,
          font: theme.fontTitleLarge,
          fontWeight: FontWeight.w700,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );

    return Row(
      children: [
        if (options.showCancelSlot)
          Padding(
            padding: EdgeInsets.only(left: theme.spacer8),
            child: Semantics(
              button: true,
              label: _cancelSemanticsLabel(context, options),
              excludeSemantics: true,
              child: TToolbarPressable(
                onTap: () {
                  options.onCancel?.call();
                  if (options.autoCloseOnCancel) {
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
        if (options.showConfirmSlot)
          Padding(
            padding: EdgeInsets.only(right: theme.spacer8),
            child: Semantics(
              button: true,
              label: _confirmSemanticsLabel(context, options),
              excludeSemantics: true,
              child: TToolbarPressable(
                onTap: () {
                  options.onConfirm?.call();
                  if (options.autoCloseOnConfirm) {
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
    if (options.cancelBuilder != null) {
      return options.cancelBuilder!(context);
    }
    if (TPopupOptions.isActionDefault(options.cancel)) {
      return TText(
        options.cancelBtn ?? context.resource.cancel,
        textColor: theme.textColorSecondary,
        font: theme.fontBodyLarge,
      );
    }
    return options.cancel!;
  }

  Widget _buildConfirm(BuildContext context, TThemeData theme) {
    if (options.confirmBuilder != null) {
      return options.confirmBuilder!(context);
    }
    if (TPopupOptions.isActionDefault(options.confirm)) {
      return TText(
        options.confirmBtn ?? context.resource.confirm,
        textColor: theme.brandNormalColor,
        font: theme.fontTitleMedium,
        fontWeight: FontWeight.w600,
      );
    }
    return options.confirm!;
  }
}

String _cancelSemanticsLabel(BuildContext context, TPopupOptions options) {
  final btn = options.cancelBtn;
  if (btn != null && btn.isNotEmpty) {
    return btn;
  }
  return context.resource.cancel;
}

String _confirmSemanticsLabel(BuildContext context, TPopupOptions options) {
  final btn = options.confirmBtn;
  if (btn != null && btn.isNotEmpty) {
    return btn;
  }
  return context.resource.confirm;
}
