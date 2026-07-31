import 'dart:async';

import 'package:flutter/material.dart';

import 't_popover_theme_data.dart';
import 't_popover_widget.dart';

/// 气泡弹层
///
/// 通过 [showPopover] 静态方法弹出，支持 12 个方向定位和箭头。
class TPopover {
  /// 显示气泡弹层
  static Future<void> showPopover({
    required BuildContext context,
    String? content,
    Widget? contentWidget,

    /// 弹层与触发元素的间距。
    double? offset,

    /// 气泡语义色。
    TPopoverColorScheme? colorScheme,

    /// 点击气泡外部区域时是否关闭弹层。
    bool closeOnClickOutside = true,

    /// 页面滚动时是否关闭弹层。
    ///
    /// 默认为 true，避免触发元素移动后气泡停留在旧坐标。
    bool closeOnScroll = true,
    TPopoverPlacement? placement,

    /// 是否显示气泡箭头。
    bool? showArrow,

    /// 箭头尺寸。
    double? arrowSize,

    /// 内容内边距。
    EdgeInsetsGeometry? padding,

    /// 内容外框宽度（包含 padding）。
    ///
    /// 使用 `contentWidget` 时必须同时提供 `width` 和 `height`，也可以由
    /// [TPopoverThemeData] 提供对应尺寸。
    double? width,

    /// 内容外框高度（包含 padding）。
    double? height,

    /// 蒙层颜色。
    Color? overlayColor,
    TPopoverTapCallback? onTap,
    TPopoverLongPressCallback? onLongTap,

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
            contentWidget: contentWidget,
            offset: offset ?? theme.offset,
            colorScheme: colorScheme ?? theme.colorScheme,
            placement: placement,
            showArrow: showArrow ?? theme.showArrow,
            arrowSize: arrowSize ?? theme.arrowSize,
            padding: padding ?? theme.padding,
            width: width ?? theme.minWidth,
            height: height ?? theme.maxHeight,
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
      builder: (overlayContext) => capturedThemes.wrap(buildOverlayContent()),
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
