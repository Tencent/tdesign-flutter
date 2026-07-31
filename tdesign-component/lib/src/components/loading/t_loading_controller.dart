import 'package:flutter/material.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import 't_loading.dart';
import 't_loading_theme_data.dart';

/// 用于命令式显示和关闭加载状态的控制器。
class TLoadingController {
  static OverlayEntry? _overlayEntry;

  static bool _isShowing = false;

  // 展示
  static void show(
    BuildContext context, {
    Widget? child,
    TLoadingSize size = TLoadingSize.medium,
    TLoadingIcon? icon = TLoadingIcon.circle,
    String? text,
    TLoadingThemeData? theme,
  }) {
    if (_isShowing) {
      debugPrint('warn: TLoading is showing!');
      return;
    }

    final overlay = Overlay.of(context);
    final captured = InheritedTheme.capture(from: context, to: overlay.context);
    final loadingText = text ?? context.resource.loading;
    _overlayEntry = OverlayEntry(
      builder: (overlayContext) => captured.wrap(
        Builder(
          builder: (capturedContext) {
            final loadingWidget =
                child ?? TLoading(size: size, icon: icon, text: loadingText);
            if (theme == null) {
              return Center(child: loadingWidget);
            }
            return Center(
              child: Theme(
                data: Theme.of(capturedContext).mergeExtension(theme),
                child: loadingWidget,
              ),
            );
          },
        ),
      ),
    );

    _isShowing = true;
    overlay.insert(_overlayEntry!);
  }

  // 消失
  static void dismiss() {
    if (_isShowing) {
      if (_overlayEntry != null) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
      _isShowing = false;
    }
  }
}
