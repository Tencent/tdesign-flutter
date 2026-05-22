part of 't_popup.dart';

/// center 面板外关闭控件：默认图标 → [TPopupTrigger.closeBtn]；自定义 → [TPopupTrigger.programmatic]。
Widget buildPopupCenterCloseControl({
  required BuildContext context,
  required TPopupOptions options,
  required VoidCallback onProgrammaticClose,
  required void Function(TPopupTrigger trigger) onCloseWithTrigger,
}) {
  if (_isPopupDefaultClose(options.closeBuilder)) {
    final theme = TTheme.of(context);
    return IconButton(
      tooltip: context.resource.close,
      icon: Icon(
        TIcons.close_circle,
        color: theme.fontWhColor1,
        size: 32,
      ),
      onPressed: () => onCloseWithTrigger(TPopupTrigger.closeBtn),
    );
  }
  return options.closeBuilder!(context, onProgrammaticClose);
}

/// center 布局：内容面板 + 外置关闭区。
class PopupCenterUnderClose extends StatelessWidget {
  const PopupCenterUnderClose({
    super.key,
    required this.options,
    required this.content,
    required this.onCloseWithTrigger,
  });

  final TPopupOptions options;
  final Widget content;
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

    void onProgrammaticClose() =>
        onCloseWithTrigger(TPopupTrigger.programmatic);

    final closeControl = buildPopupCenterCloseControl(
      context: context,
      options: options,
      onProgrammaticClose: onProgrammaticClose,
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
