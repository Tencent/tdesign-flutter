import 'package:flutter/material.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import 't_loading.dart';
import 't_loading_theme_data.dart';

/// 用于命令式显示和关闭加载状态的控制器。
class TLoadingController {
  static OverlayEntry? _overlayEntry;

  static bool _isShowing = false;

  /// 在最近的 Overlay 中展示全局唯一加载层。
  ///
  /// 重复调用不替换当前加载层；无 Overlay 时忽略请求。调用方应在任务结束
  /// 或所属页面卸载前调用 [dismiss]，静态控制器不属于某个 Widget 的生命周期。
  /// [context] 用于查找 Overlay 并捕获主题。
  /// [child] 自定义内容；传入后忽略 size、icon 和 text。
  /// [size] 默认加载图标尺寸，默认 20。
  /// [icon] 默认图标类型，默认 circle；null 时隐藏图标。
  /// [text] 默认内容文案，null 时使用当前语言的加载文案。
  /// [theme] 仅覆盖本次加载层的组件主题，null 时继承捕获的主题。
  static void show(
    BuildContext context, {
    Widget? child,
    double size = 20,
    TLoadingIcon? icon = TLoadingIcon.circle,
    String? text,
    TLoadingThemeData? theme,
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

  /// 移除并释放全局加载层；未展示时无副作用。
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
