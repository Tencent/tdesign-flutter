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
    return IconButton(
      tooltip: context.resource.close,
      icon: Icon(
        TIcons.close_circle,
        color: theme.fontWhColor1,
        size: 32,
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
    var panel = content;
    if (options.width != null || options.height != null) {
      panel = SizedBox(
        width: options.width,
        height: options.height,
        child: content,
      );
    }

    void onCloseSlotTap() => onCloseWithTrigger(TPopupTrigger.close);

    final closeControl = buildPopupCenterCloseControl(
      context: context,
      options: options,
      onCloseSlotTap: onCloseSlotTap,
      onCloseWithTrigger: onCloseWithTrigger,
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
