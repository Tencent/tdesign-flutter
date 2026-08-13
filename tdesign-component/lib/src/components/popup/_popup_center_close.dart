part of 't_popup.dart';

/// center 面板外下方关闭控件：默认图标与自定义关闭槽位都上报 [TPopupTrigger.close]。
Widget buildPopupCenterCloseControl({
  required BuildContext context,
  required TPopupOptions options,
  required VoidCallback onCloseSlotTap,
  required void Function(TPopupTrigger trigger) onCloseWithTrigger,
}) {
  if (_isPopupDefaultClose(options.closeBuilder)) {
    final theme = context.tTheme;
    final popupTheme = Theme.of(context).extension<TPopupThemeData>();
    return IconButton(
      tooltip: context.resource.close,
      icon: Icon(
        TIcons.close_circle,
        color: popupTheme?.closeIconColor ?? theme.fontWhColor1,
        size: popupTheme?.closeIconSize ?? 32,
      ),
      onPressed: () => onCloseWithTrigger(TPopupTrigger.close),
    );
  }
  return options.closeBuilder!(context, onCloseSlotTap);
}

/// center 布局：内容面板 + 面板外下方关闭区。
class PopupCenterUnderClose extends StatelessWidget {
  const PopupCenterUnderClose({
    super.key,
    required this.options,
    required this.content,
    required this.onCloseWithTrigger,
  });

  /// 弹出层配置
  final TPopupOptions options;

  /// 内容组件
  final Widget content;

  /// 关闭回调（携带触发源）
  final void Function(TPopupTrigger trigger) onCloseWithTrigger;

  @override
  Widget build(BuildContext context) {
    final panel = SizedBox(
      width: options.width ?? PopupLayout.defaultCenterWidth,
      height: options.height ?? PopupLayout.defaultCenterHeight,
      child: content,
    );

    void onCloseSlotTap() => onCloseWithTrigger(TPopupTrigger.close);

    final closeControl = buildPopupCenterCloseControl(
      context: context,
      options: options,
      onCloseSlotTap: onCloseSlotTap,
      onCloseWithTrigger: onCloseWithTrigger,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final children = <Widget>[
          const SizedBox(height: 40),
          if (constraints.hasBoundedHeight)
            Flexible(fit: FlexFit.loose, child: panel)
          else
            panel,
          const SizedBox(height: 24),
          closeControl,
        ];
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        );
      },
    );
  }
}
