import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import 't_loading.dart';
import 't_loading_theme_data.dart';

/// 用于命令式显示和关闭加载状态的控制器。
class TLoadingController {
  static _TLoadingOverlaySession? _session;

  /// 在 [context] 的 Overlay 中显示全局加载层。
  ///
  /// 已有加载层或找不到 Overlay 时不重复创建。[child] 非空时替代内置 TLoading；
  /// 否则使用 [size]、[icon] 和 [text] 构建加载内容，text 为空时读取资源代理。
  /// 所属 Overlay 卸载后释放会话；普通页面离开但所属 Overlay 尚存时保持展示。
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
    final previous = _session;
    if (previous != null && !previous.overlay.mounted) {
      _release(previous);
    }
    if (_session != null) {
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
    final entry = OverlayEntry(
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

    // Observe the owner without retaining the obscured content State.
    final lifecycleEntry = OverlayEntry(
      maintainState: true,
      builder: (_) => const SizedBox.shrink(),
    );
    final session = _TLoadingOverlaySession(
      overlayState,
      entry,
      lifecycleEntry,
    );
    session.listener = () {
      // The ancestor may still be mounted during the Entry's unmount notification.
      scheduleMicrotask(() {
        if (!overlayState.mounted) {
          _release(session);
        }
      });
    };
    lifecycleEntry.addListener(session.listener);
    try {
      overlayState.insertAll([lifecycleEntry, entry]);
      _session = session;
      WidgetsBinding.instance.addPostFrameCallback((_) => session.listener());
    } catch (_) {
      lifecycleEntry.removeListener(session.listener);
      entry.dispose();
      lifecycleEntry.dispose();
      rethrow;
    }
  }

  /// 移除并释放全局加载层；未展示或已因 Overlay 卸载而清理时无副作用。
  static void dismiss() {
    final session = _session;
    if (session != null) {
      _release(session);
    }
  }

  static void _release(_TLoadingOverlaySession session) {
    if (!identical(_session, session)) {
      return;
    }
    _session = null;
    session.lifecycleEntry.removeListener(session.listener);
    session.entry.remove();
    session.entry.dispose();
    session.lifecycleEntry.remove();
    session.lifecycleEntry.dispose();
  }
}

class _TLoadingOverlaySession {
  _TLoadingOverlaySession(this.overlay, this.entry, this.lifecycleEntry);

  final OverlayState overlay;
  final OverlayEntry entry;
  final OverlayEntry lifecycleEntry;
  late final VoidCallback listener;
}
