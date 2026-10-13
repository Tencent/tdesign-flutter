import 'package:flutter/material.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import 't_loading.dart';
import 't_loading_theme_data.dart';

/// 用于命令式显示和关闭加载状态的控制器。
class TLoadingController {
  static OverlayEntry? _overlayEntry;

  static bool _isShowing = false;

  /// 监听当前加载层是否被宿主 Overlay 卸载；未展示时为 null。
  static VoidCallback? _entryListener;

  // 展示
  /// 在 [context] 的 Overlay 中显示全局加载层。
  ///
  /// 已有加载层或找不到 Overlay 时不重复创建。[child] 非空时替代内置 TLoading；
  /// 否则使用 [size]、[icon] 和 [text] 构建加载内容，text 为空时读取资源代理。
  /// [theme] 仅作用于本次加载层，未提供时保留捕获的祖先主题。
  ///
  /// 若上一次加载层的宿主 Overlay 已随页面销毁（页面 pop、热重载等）而没来得及
  /// 调用 [dismiss]，内部状态会自动复位并创建新的加载层，不会永久失效。
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
    if (_isShowing && (_overlayEntry?.mounted ?? false)) {
      debugPrint('warn: TLoading is showing!');
      return;
    }
    // 上一次的加载层若已随宿主 Overlay 卸载（页面 pop、热重载），状态会残留为
    // “正在展示”；先回收残留引用，否则后续 show 会被上面的分支永久拦住。
    _releaseEntry();

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
    _entryListener = () {
      // 宿主 Overlay 被销毁时 entry 会自行卸载；同步复位，避免 _isShowing 卡死。
      if (!entry.mounted) {
        _releaseEntry();
      }
    };
    entry.addListener(_entryListener!);
    try {
      overlayState.insert(entry);
      _isShowing = true;
    } catch (_) {
      _releaseEntry();
      rethrow;
    }
  }

  /// 移除并释放全局加载层；没有加载层时调用无效，可重复调用。
  ///
  /// 宿主 Overlay 若已被销毁，仅复位内部状态，不会重复移除已卸载的加载层。
  static void dismiss() {
    _releaseEntry();
  }

  /// 断开与当前加载层的关联并复位内部状态。
  ///
  /// 仍挂载的加载层按 [OverlayEntry.remove] + [OverlayEntry.dispose] 释放；
  /// 已卸载的加载层由框架随宿主 Overlay 回收，这里只丢弃引用，避免重复移除。
  static void _releaseEntry() {
    final entry = _overlayEntry;
    final listener = _entryListener;
    _overlayEntry = null;
    _entryListener = null;
    _isShowing = false;
    if (entry == null) {
      return;
    }
    if (listener != null) {
      entry.removeListener(listener);
    }
    if (entry.mounted) {
      entry.remove();
      entry.dispose();
    }
  }
}
