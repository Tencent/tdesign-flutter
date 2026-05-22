import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import '_popup_center_close.dart';
import '_popup_header.dart';
import 't_popup_options.dart';
import 't_popup_types.dart';

/// 浮层内容外壳：圆角、Header（仅 bottom）、child；center 由 [PopupCenterUnderClose] 接管下方关闭区。
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
    final theme = TTheme.of(context);
    final radius = options.radius ?? theme.radiusExtraLarge;
    final backgroundColor = options.backgroundColor ?? theme.bgColorContainer;
    final borderRadius = _borderRadius(options.placement, radius);

    if (options.placement == TPopupPlacement.center) {
      return _buildCenter(context, radius, backgroundColor);
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
      width: options.width,
      height: options.height,
      child: panel,
    );
  }

  Widget _buildEdge(
    BuildContext context,
    BorderRadius? borderRadius,
    Color background,
  ) {
    final useExpanded = options.placement == TPopupPlacement.left ||
        options.placement == TPopupPlacement.right ||
        options.height != null;

    final body = options.placement == TPopupPlacement.bottom
        ? Column(
            mainAxisSize: useExpanded ? MainAxisSize.max : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PopupHeader(
                options: options,
                onCloseWithTrigger: onCloseWithTrigger,
              ),
              if (useExpanded) Expanded(child: options.child) else options.child,
            ],
          )
        : (useExpanded
            ? Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [Expanded(child: options.child)],
              )
            : options.child);

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: borderRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: body,
    );
  }

  BorderRadius? _borderRadius(TPopupPlacement placement, double radius) {
    switch (placement) {
      case TPopupPlacement.top:
        return BorderRadius.vertical(bottom: Radius.circular(radius));
      case TPopupPlacement.bottom:
        return BorderRadius.vertical(top: Radius.circular(radius));
      case TPopupPlacement.left:
        return BorderRadius.horizontal(right: Radius.circular(radius));
      case TPopupPlacement.right:
        return BorderRadius.horizontal(left: Radius.circular(radius));
      case TPopupPlacement.center:
        return BorderRadius.circular(radius);
    }
  }
}
