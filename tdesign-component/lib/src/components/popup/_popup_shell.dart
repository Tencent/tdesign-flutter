import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import '_popup_center_close.dart';
import '_popup_header.dart';
import 't_popup_options.dart';
import 't_popup_types.dart';

/// 浮层内容外壳：圆角、Header（仅 bottom）、child。
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

    Widget content = options.child;

    if (options.placement == TPopupPlacement.center) {
      if (options.closeBuilder != null) {
        final panel = Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(radius),
          ),
          clipBehavior: Clip.antiAlias,
          child: content,
        );
        return PopupCenterUnderClose(
          options: options,
          content: panel,
          onCloseWithTrigger: onCloseWithTrigger,
        );
      }
      return Center(
        child: SizedBox(
          width: options.width,
          height: options.height,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(radius),
            ),
            clipBehavior: Clip.antiAlias,
            child: content,
          ),
        ),
      );
    }

    final useExpanded = options.placement == TPopupPlacement.left ||
        options.placement == TPopupPlacement.right ||
        options.height != null;

    Widget panel = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: options.placement == TPopupPlacement.bottom
          ? Column(
              mainAxisSize: useExpanded ? MainAxisSize.max : MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PopupHeader(
                  options: options,
                  onCloseWithTrigger: onCloseWithTrigger,
                ),
                if (useExpanded) Expanded(child: content) else content,
              ],
            )
          : (useExpanded
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [Expanded(child: content)],
                )
              : content),
    );

    return panel;
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
