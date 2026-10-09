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
  /// 在 [context] 的 Overlay 中显示全局加载层。
  ///
  /// 已有加载层或找不到 Overlay 时不重复创建。[child] 非空时替代内置 TLoading；
  /// 否则使用 [size]、[icon] 和 [text] 构建加载内容，text 为空时读取资源代理。
  /// [theme] 仅作用于本次加载层，未提供时保留捕获的祖先主题。
  static void show(
    /// 当前构建上下文，用于读取祖先配置。
    BuildContext context, {

    /// 替代默认加载内容的自定义组件；为空时由 size、icon 和 text 构建 TLoading。
    Widget? child,
    double size = 20,
    TLoadingIcon? icon = TLoadingIcon.circle,

    /// 加载文案；为空时使用资源代理的 loading 文案。
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

  // 消失
  /// 移除并释放全局加载层；没有加载层时调用无效，可重复调用。
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
