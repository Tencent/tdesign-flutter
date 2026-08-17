part of 't_popup.dart';

/// 浮层内容外壳：圆角、[PopupHeader]（仅 bottom）与主体内容；
/// center 由 [PopupCenterUnderClose] 接管面板外下方关闭区。
class PopupShell extends StatelessWidget {
  const PopupShell({
    super.key,
    required this.options,
    required this.onCloseWithTrigger,
  });

  final TPopupOptions options;
  final void Function(TPopupTrigger trigger) onCloseWithTrigger;

  @override
  Widget build(BuildContext context) {
    final theme = context.tTheme;
    // top/bottom/center 默认使用全局大圆角；
    // left/right 对齐官方为无圆角全高矩形，仅当显式设置
    // `options.radius`（或经 `TPopupThemeData.panelRadius` 注入）时应用圆角。
    final isEdgeDrawer =
        options.placement == TPopupPlacement.left ||
        options.placement == TPopupPlacement.right;
    final radius = isEdgeDrawer
        ? options.radius
        : (options.radius ?? theme.radiusExtraLarge);
    final backgroundColor = options.backgroundColor ?? theme.bgColorContainer;
    final borderRadius = _borderRadius(options.placement, radius);

    if (options.placement == TPopupPlacement.center) {
      return _buildCenter(context, radius ?? 0, backgroundColor);
    }

    return _buildEdge(context, borderRadius, backgroundColor);
  }

  Widget _buildCenter(BuildContext context, double radius, Color background) {
    final panel = Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: options.child,
    );

    if (options.closeBuilder != null) {
      return PopupCenterUnderClose(
        options: options,
        content: panel,
        onCloseWithTrigger: onCloseWithTrigger,
      );
    }
    return SizedBox(
      width: options.width ?? PopupLayout.defaultCenterWidth,
      height: options.height ?? PopupLayout.defaultCenterHeight,
      child: panel,
    );
  }

  Widget _buildEdge(
    BuildContext context,
    BorderRadius? borderRadius,
    Color background,
  ) {
    // 四个边缘方向现在都有固定的默认尺寸，主体始终填满剩余空间；
    // 显式尺寸与默认尺寸的内容布局保持一致。
    final body = options.placement == TPopupPlacement.bottom
        ? Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PopupHeader(
                options: options,
                onCloseWithTrigger: onCloseWithTrigger,
              ),
              Expanded(child: options.child),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [Expanded(child: options.child)],
          );

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: borderRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: body,
    );
  }

  BorderRadius? _borderRadius(TPopupPlacement placement, double? radius) {
    switch (placement) {
      case TPopupPlacement.top:
        return BorderRadius.vertical(bottom: Radius.circular(radius ?? 0));
      case TPopupPlacement.bottom:
        return BorderRadius.vertical(top: Radius.circular(radius ?? 0));
      case TPopupPlacement.left:
        // 未显式设置圆角时为无圆角（对齐官方全高矩形）。
        if (radius == null) {
          return null;
        }
        return BorderRadius.horizontal(right: Radius.circular(radius));
      case TPopupPlacement.right:
        // 未显式设置圆角时为无圆角（对齐官方全高矩形）。
        if (radius == null) {
          return null;
        }
        return BorderRadius.horizontal(left: Radius.circular(radius));
      case TPopupPlacement.center:
        return BorderRadius.circular(radius ?? 0);
    }
  }
}
