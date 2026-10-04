import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import 't_loading.dart';
import 't_loading_theme_data.dart';

/// 用于命令式显示和关闭加载状态的控制器。
class TLoadingController {
  static _TLoadingOverlaySession? _session;

  /// 在最近的 Overlay 中展示全局唯一加载层。
  ///
  /// 重复调用不替换当前加载层；无 Overlay 时忽略请求。
  /// 所属 Overlay 卸载后会释放会话，后续可在新的 Overlay 展示。
  /// 普通页面离开但所属 Overlay 尚存时不会自动关闭；调用方应在任务结束
  /// 或需要随页面关闭时调用 [dismiss]。
  /// 尚未首次绘制的加载层随 Overlay 卸载后，在下一次 show/dismiss 时释放。
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

    final session = _TLoadingOverlaySession(overlayState, entry);
    session.listener = () {
      if (!entry.mounted && !overlayState.mounted) {
        // Entry 正在通知卸载，避免在 ChangeNotifier 通知栈内同步释放。
        _release(session, deferDispose: true);
      }
    };
    entry.addListener(session.listener);
    try {
      overlayState.insert(entry);
      _session = session;
    } catch (_) {
      entry.removeListener(session.listener);
      entry.dispose();
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

  static void _release(
    _TLoadingOverlaySession session, {
    bool deferDispose = false,
  }) {
    if (!identical(_session, session)) {
      return;
    }
    _session = null;
    session.entry.removeListener(session.listener);
    session.entry.remove();
    if (deferDispose) {
      scheduleMicrotask(session.entry.dispose);
    } else {
      session.entry.dispose();
    }
  }
}

class _TLoadingOverlaySession {
  _TLoadingOverlaySession(this.overlay, this.entry);

  final OverlayState overlay;
  final OverlayEntry entry;
  late final VoidCallback listener;
}
