part of 't_popup.dart';

/// bottom 头部渲染；行为由 [TPopupOptions.hasBuiltInHeader]、[TPopupOptions.useCustomHeader] 决定。
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
    if (!options.hasBuiltInHeader) {
      return const SizedBox.shrink();
    }

    if (options.useCustomHeader) {
      return options.headerBuilder!(context, _close);
    }

    return SizedBox(
      height: headerHeight,
      child: _DefaultHeader(
        options: options,
        onCloseWithTrigger: onCloseWithTrigger,
      ),
    );
  }
}

class _DefaultHeader extends StatelessWidget {
  const _DefaultHeader({
    required this.options,
    required this.onCloseWithTrigger,
  });

  final TPopupOptions options;

  /// 给「内置 sentinel cancel/confirm 按钮」用的 close 入口，
  /// 按钮自己传 [TPopupTrigger.cancelBtn] / [TPopupTrigger.confirmBtn]。
  final void Function(TPopupTrigger trigger) onCloseWithTrigger;

  @override
  Widget build(BuildContext context) {
    final theme = TTheme.of(context);
    final showCancel = options.cancelBuilder != null;
    final showConfirm = options.confirmBuilder != null;

    final title = options.titleWidget;

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
    // 标题内容由用户插槽决定样式，这里只做布局约束。
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
    if (_isPopupDefaultCancel(options.cancelBuilder)) {
      return TToolbarPressable(
        onTap: () => onCloseWithTrigger(TPopupTrigger.cancelBtn),
        child: TText(
          context.resource.cancel,
          textColor: theme.textColorSecondary,
          font: theme.fontBodyLarge,
        ),
      );
    }
    return options.cancelBuilder!(
      context,
      () => onCloseWithTrigger(TPopupTrigger.cancelBtn),
    );
  }

  Widget _buildConfirm(BuildContext context, TThemeData theme) {
    if (_isPopupDefaultConfirm(options.confirmBuilder)) {
      return TToolbarPressable(
        onTap: () => onCloseWithTrigger(TPopupTrigger.confirmBtn),
        child: TText(
          context.resource.confirm,
          textColor: theme.brandNormalColor,
          font: theme.fontTitleMedium,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    return options.confirmBuilder!(
      context,
      () => onCloseWithTrigger(TPopupTrigger.confirmBtn),
    );
  }
}

String _cancelSemanticsLabel(BuildContext context, TPopupOptions options) {
  return context.resource.cancel;
}

String _confirmSemanticsLabel(BuildContext context, TPopupOptions options) {
  return context.resource.confirm;
}
