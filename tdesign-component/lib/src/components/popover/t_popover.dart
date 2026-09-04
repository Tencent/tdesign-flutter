import 'dart:async';

import 'package:flutter/material.dart';

import 't_popover_theme_data.dart';
import 't_popover_types.dart';
import 't_popover_widget.dart';

class _PopoverAnchorLifecycle extends StatefulWidget {
  const _PopoverAnchorLifecycle({
    required this.anchorContext,
    required this.onAnchorUnmounted,
    required this.child,
  });

  final BuildContext anchorContext;
  final VoidCallback onAnchorUnmounted;
  final Widget child;

  @override
  State<_PopoverAnchorLifecycle> createState() =>
      _PopoverAnchorLifecycleState();
}

class _PopoverAnchorLifecycleState extends State<_PopoverAnchorLifecycle> {
  var _checkScheduled = false;

  @override
  void initState() {
    super.initState();
    _scheduleAnchorCheck();
  }

  @override
  void didUpdateWidget(_PopoverAnchorLifecycle oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleAnchorCheck();
  }

  void _scheduleAnchorCheck() {
    if (_checkScheduled) {
      return;
    }
    _checkScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback(_checkAnchor);
  }

  void _checkAnchor(Duration _) {
    _checkScheduled = false;
    if (!mounted) {
      return;
    }
    if (widget.anchorContext case final Element element when !element.mounted) {
      widget.onAnchorUnmounted();
      return;
    }
    _scheduleAnchorCheck();
  }

  @override
  Widget build(BuildContext context) {
    _scheduleAnchorCheck();
    return widget.child;
  }
}

/// 气泡弹层
///
/// 通过 [showPopover] 静态方法弹出，支持 12 个方向定位和箭头。
class TPopover {
  /// 显示气泡弹层
  static Future<void> showPopover({
    /// 触发元素的上下文，用于计算气泡锚点位置。
    required BuildContext context,

    /// 气泡内容。
    ///
    /// 直接传入未设置样式的 [Text] 时使用气泡默认文字样式；组合内容应自行定义
    /// 子组件样式和布局。
    required Widget content,

    /// 弹层与触发元素的间距。
    double? offset,

    /// 气泡预设配色。
    TPopoverColorScheme colorScheme = TPopoverColorScheme.defaultTheme,

    /// 点击气泡外部区域时是否关闭弹层。
    bool closeOnClickOutside = true,

    /// 页面滚动时是否关闭弹层。
    ///
    /// 默认为 true，避免触发元素移动后气泡停留在旧坐标。
    bool closeOnScroll = true,

    /// 浮层出现位置，默认为 [TPopoverPlacement.top]。
    TPopoverPlacement placement = TPopoverPlacement.top,

    /// 是否显示气泡箭头。
    bool? showArrow,

    /// 箭头尺寸。
    double? arrowSize,

    /// 内容内边距。
    EdgeInsetsGeometry? padding,

    /// 内容外框宽度（包含 padding）。
    ///
    /// 未设置时按 `content` 的实际布局宽度确定，并受组件主题尺寸约束。
    double? width,

    /// 内容外框高度（包含 padding）。
    ///
    /// 未设置时按 `content` 的实际布局高度确定，并受组件主题尺寸约束。
    double? height,

    /// 蒙层颜色。
    Color? overlayColor,

    /// 点击气泡内容时触发。
    VoidCallback? onTap,

    /// 长按气泡内容时触发。
    VoidCallback? onLongTap,

    /// 气泡圆角。
    BorderRadius? radius,
  }) {
    final theme =
        Theme.of(context).extension<TPopoverThemeData>() ??
        const TPopoverThemeData();
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      return Future<void>.error(
        FlutterError('TPopover requires an Overlay ancestor.'),
      );
    }

    final completer = Completer<void>();
    final capturedThemes = InheritedTheme.capture(
      from: context,
      to: overlay.context,
    );
    final effectiveOverlayColor =
        overlayColor ?? theme.barrierColor ?? Colors.transparent;
    final scrollPosition = Scrollable.maybeOf(context)?.position;
    final route = ModalRoute.of(context);
    late OverlayEntry entry;
    LocalHistoryEntry? historyEntry;
    VoidCallback? scrollListener;
    var dismissed = false;

    void removeEntry() {
      final currentScrollListener = scrollListener;
      if (currentScrollListener != null) {
        scrollPosition?.removeListener(currentScrollListener);
      }
      if (entry.mounted) {
        entry.remove();
      }
      entry.dispose();
      if (!completer.isCompleted) {
        completer.complete();
      }
    }

    void dismiss() {
      if (dismissed) {
        return;
      }
      dismissed = true;
      final currentHistoryEntry = historyEntry;
      historyEntry = null;
      currentHistoryEntry?.remove();
      removeEntry();
    }

    void dismissFromHistory() {
      historyEntry = null;
      if (dismissed) {
        return;
      }
      dismissed = true;
      removeEntry();
    }

    Widget buildOverlayContent() {
      return Stack(
        fit: StackFit.expand,
        children: [
          IgnorePointer(
            child: ColoredBox(
              key: const Key('t-popover-overlay-color'),
              color: effectiveOverlayColor,
            ),
          ),
          if (closeOnClickOutside || closeOnScroll)
            Listener(
              behavior: HitTestBehavior.translucent,
              onPointerMove: closeOnScroll ? (_) => dismiss() : null,
              onPointerSignal: closeOnScroll ? (_) => dismiss() : null,
              child: closeOnClickOutside
                  ? GestureDetector(
                      key: const Key('t-popover-outside-dismiss'),
                      behavior: HitTestBehavior.translucent,
                      onTap: dismiss,
                      child: const SizedBox.expand(),
                    )
                  : const SizedBox.expand(),
            ),
          TPopoverWidget(
            context: context,
            content: content,
            offset: offset ?? theme.offset,
            colorScheme: colorScheme,
            placement: placement,
            showArrow: showArrow ?? theme.showArrow,
            arrowSize: arrowSize ?? theme.arrowSize,
            padding: padding ?? theme.padding,
            width: width,
            height: height,
            onTap: onTap,
            onLongTap: onLongTap,
            radius:
                radius ??
                (theme.borderRadius == null
                    ? null
                    : BorderRadius.circular(theme.borderRadius!)),
          ),
        ],
      );
    }

    entry = OverlayEntry(
      builder: (overlayContext) => capturedThemes.wrap(
        _PopoverAnchorLifecycle(
          anchorContext: context,
          onAnchorUnmounted: dismiss,
          child: buildOverlayContent(),
        ),
      ),
    );

    if (closeOnScroll && scrollPosition != null) {
      scrollListener = dismiss;
      scrollPosition.addListener(dismiss);
    }
    overlay.insert(entry);
    if (route != null) {
      historyEntry = LocalHistoryEntry(onRemove: dismissFromHistory);
      route.addLocalHistoryEntry(historyEntry!);
    }
    return completer.future;
  }
}
