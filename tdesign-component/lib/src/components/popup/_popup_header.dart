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
///
/// - `headerBuilder` 为 sentinel [kPopupDefaultHeader] → 内置三段式（cancel | title | confirm）。
/// - `headerBuilder` 为自定义 → 整行替换，库内不再插入任何子 Widget。
/// - `headerBuilder` 为 null → 不渲染头部。
class PopupHeader extends StatelessWidget {
  const PopupHeader({
    super.key,
    required this.options,
    required this.onCloseWithTrigger,
  });

  final TPopupOptions options;
  final void Function(TPopupTrigger trigger) onCloseWithTrigger;

  static const double headerHeight = 58;

  void _close() {
    onCloseWithTrigger(TPopupTrigger.programmatic);
  }

  @override
  Widget build(BuildContext context) {
    if (options.placement != TPopupPlacement.bottom ||
        options.headerBuilder == null) {
      return const SizedBox.shrink();
    }

    if (options.useCustomHeader) {
      return options.headerBuilder!(context, _close);
    }

    // 走内置三段式
    return SizedBox(
      height: headerHeight,
      child: _DefaultHeader(
        options: options,
        close: _close,
      ),
    );
  }
}

class _DefaultHeader extends StatelessWidget {
  const _DefaultHeader({
    required this.options,
    required this.close,
  });

  final TPopupOptions options;
  final VoidCallback close;

  @override
  Widget build(BuildContext context) {
    final theme = TTheme.of(context);
    final showCancel = options.cancelBuilder != null;
    final showConfirm = options.confirmBuilder != null;

    final title = options.titleBuilder?.call(context);

    return Row(
      children: [
        if (showCancel)
          Padding(
            padding: EdgeInsets.only(left: theme.spacer8),
            child: Semantics(
              button: true,
              label: _cancelSemanticsLabel(context, options),
              excludeSemantics: true,
              child: _buildCancel(context, theme),
            ),
          )
        else
          SizedBox(width: theme.spacer16),
        Expanded(
          child: title == null
              ? const SizedBox.shrink()
              : Center(child: _titleWrap(context, theme, title)),
        ),
        if (showConfirm)
          Padding(
            padding: EdgeInsets.only(right: theme.spacer8),
            child: Semantics(
              button: true,
              label: _confirmSemanticsLabel(context, options),
              excludeSemantics: true,
              child: _buildConfirm(context, theme),
            ),
          )
        else
          SizedBox(width: theme.spacer16),
      ],
    );
  }

  Widget _titleWrap(BuildContext context, TThemeData theme, Widget child) {
    // 标题由用户 builder 决定样式，这里只做布局约束。
    return DefaultTextStyle.merge(
      style: TextStyle(
        color: theme.textColorPrimary,
        fontSize: theme.fontTitleLarge?.size,
        fontWeight: FontWeight.w700,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: child,
    );
  }

  Widget _buildCancel(BuildContext context, TThemeData theme) {
    if (isPopupDefaultCancel(options.cancelBuilder)) {
      return TToolbarPressable(
        onTap: close,
        child: TText(
          context.resource.cancel,
          textColor: theme.textColorSecondary,
          font: theme.fontBodyLarge,
        ),
      );
    }
    return options.cancelBuilder!(context, close);
  }

  Widget _buildConfirm(BuildContext context, TThemeData theme) {
    if (isPopupDefaultConfirm(options.confirmBuilder)) {
      return TToolbarPressable(
        onTap: close,
        child: TText(
          context.resource.confirm,
          textColor: theme.brandNormalColor,
          font: theme.fontTitleMedium,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    return options.confirmBuilder!(context, close);
  }
}

String _cancelSemanticsLabel(BuildContext context, TPopupOptions options) {
  return context.resource.cancel;
}

String _confirmSemanticsLabel(BuildContext context, TPopupOptions options) {
  return context.resource.confirm;
}
