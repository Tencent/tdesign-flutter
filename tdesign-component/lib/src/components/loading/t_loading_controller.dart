import 'package:flutter/material.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../toast/t_toast.dart';
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
    TOverlayConfig? overlay,
  }) {
    if (_isShowing) {
      debugPrint('warn: TLoading is showing!');
      return;
    }

    final overlayState = Overlay.maybeOf(context);
    if (overlayState == null) {
      debugPrint('warn: TLoading requires an Overlay ancestor.');
      return;
    }
    final captured = InheritedTheme.capture(
      from: context,
      to: overlayState.context,
    );
    final loadingText = text ?? context.resource.loading;

    final cfg = overlay ?? const TOverlayConfig();
    final showMask = cfg.showOverlay;
    final maskColor = showMask
        ? (cfg.color ?? Colors.black.withValues(alpha: cfg.opacity))
        : Colors.transparent;

    Widget content = Center(
      child: Builder(
        builder: (capturedContext) {
          final loadingWidget =
              child ?? TLoading(size: size, icon: icon, text: loadingText);
          if (theme == null) {
            return loadingWidget;
          }
          return Theme(
            data: Theme.of(capturedContext).mergeExtension(theme),
            child: loadingWidget,
          );
        },
      ),
    );
    // 全屏蒙层：showOverlay 显示可见蒙层，preventTap 拦截背景点击。
    if (cfg.preventTap || showMask) {
      content = Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              ignoring: !cfg.preventTap,
              child: Container(color: maskColor),
            ),
          ),
          content,
        ],
      );
    }

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) => captured.wrap(content),
    );

    final entry = _overlayEntry!;
    try {
      overlayState.insert(entry);
      _isShowing = true;
    } catch (_) {
      _overlayEntry = null;
      _isShowing = false;
      rethrow;
    }
  }

  // 消失
  static void dismiss() {
    if (_isShowing) {
      if (_overlayEntry != null) {
        _overlayEntry?.remove();
        _overlayEntry?.dispose();
        _overlayEntry = null;
      }
      _isShowing = false;
    }
  }
}
