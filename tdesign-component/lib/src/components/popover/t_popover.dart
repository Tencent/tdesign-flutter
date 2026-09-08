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

/// [TPopoverAnchor] 的触发区域构建器。
///
/// [controller] 用于展开、关闭气泡和查询展开状态；[child] 是传给
/// [TPopoverAnchor.child] 的可选、不依赖展开状态的子组件。
typedef TPopoverAnchorBuilder =
    Widget Function(
      BuildContext context,
      TPopoverController controller,
      Widget? child,
    );

/// 控制与其绑定的 [TPopoverAnchor]。
///
/// 气泡内容、位置和视觉配置由 [TPopoverAnchor] 声明，控制器只负责展开、关闭
/// 和查询当前状态，不形成第二份配置来源。
class TPopoverController {
  _TPopoverAnchorState? _anchor;

  /// 与该控制器绑定的气泡是否已展开。
  bool get isOpen => _anchor?._isOpen ?? false;

  /// 展开与该控制器绑定的气泡。
  ///
  /// 控制器必须先通过 [TPopoverAnchor.controller] 绑定到 Widget 树。
  void open() {
    assert(
      _anchor != null,
      'TPopoverController.open() requires a TPopoverAnchor binding.',
    );
    _anchor!._open();
  }

  /// 关闭与该控制器绑定的气泡。
  ///
  /// 未绑定或已经关闭时无副作用。
  void close() => _anchor?._close();

  void _attach(_TPopoverAnchorState anchor) => _anchor = anchor;

  void _detach(_TPopoverAnchorState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  /// 返回 [context] 最近的 [TPopoverAnchor] 所关联的控制器。
  ///
  /// 未处于 Anchor 的触发区域或气泡内容子树时返回 null。
  static TPopoverController? maybeOf(BuildContext context) {
    return context
        .getInheritedWidgetOfExactType<_TPopoverControllerScope>()
        ?.controller;
  }
}

class _TPopoverControllerScope extends InheritedWidget {
  const _TPopoverControllerScope({
    required this.controller,
    required this.isOpen,
    required super.child,
  });

  final TPopoverController controller;
  final bool isOpen;

  @override
  bool updateShouldNotify(_TPopoverControllerScope oldWidget) {
    return controller != oldWidget.controller || isOpen != oldWidget.isOpen;
  }
}

/// 将可控制的气泡与 Widget 树中的触发区域绑定。
///
/// [TPopoverAnchor] 声明气泡内容、位置和视觉配置，[TPopoverController] 只负责
/// `open`、`close` 和 `isOpen`。简单的一次性展示仍可使用
/// [TPopover.showPopover]。
///
/// 气泡展开时会读取当前的内容、位置、视觉配置和关闭策略；展开期间更新这些
/// 配置不会刷新已显示的浮层，关闭后再次展开时生效。[builder] 和 [child] 仍按
/// 普通 Widget 树的更新规则重建。
class TPopoverAnchor extends StatefulWidget {
  const TPopoverAnchor({
    super.key,
    required this.content,
    required this.builder,
    this.controller,
    this.child,
    this.offset,
    this.colorScheme = TPopoverColorScheme.defaultTheme,
    this.closeOnClickOutside = true,
    this.closeOnScroll = true,
    this.placement = TPopoverPlacement.top,
    this.showArrow,
    this.arrowSize,
    this.padding,
    this.width,
    this.height,
    this.overlayColor,
    this.onTap,
    this.onLongTap,
    this.radius,
    this.onOpen,
    this.onClose,
  });

  /// 气泡内容。
  final Widget content;

  /// 构建气泡所绑定的触发区域。
  ///
  /// 构建器会收到当前有效的控制器；未传入 [controller] 时由组件内部创建。
  final TPopoverAnchorBuilder builder;

  /// 可选控制器，用于从触发区域外部展开或关闭气泡。
  final TPopoverController? controller;

  /// 传递给 [builder] 的可选子组件。
  final Widget? child;

  /// 弹层与触发元素的间距。
  final double? offset;

  /// 气泡预设配色。
  final TPopoverColorScheme colorScheme;

  /// 点击气泡外部区域时是否关闭弹层。
  final bool closeOnClickOutside;

  /// 页面滚动时是否关闭弹层。
  final bool closeOnScroll;

  /// 浮层出现位置。
  final TPopoverPlacement placement;

  /// 是否显示气泡箭头。
  final bool? showArrow;

  /// 箭头尺寸。
  final double? arrowSize;

  /// 内容内边距。
  final EdgeInsetsGeometry? padding;

  /// 内容外框宽度（包含 padding）。
  final double? width;

  /// 内容外框高度（包含 padding）。
  final double? height;

  /// 蒙层颜色。
  final Color? overlayColor;

  /// 点击气泡内容时触发。
  final VoidCallback? onTap;

  /// 长按气泡内容时触发。
  final VoidCallback? onLongTap;

  /// 气泡圆角。
  final BorderRadius? radius;

  /// 气泡展开后触发。
  final VoidCallback? onOpen;

  /// 气泡通过任意路径关闭后触发。
  final VoidCallback? onClose;

  @override
  State<TPopoverAnchor> createState() => _TPopoverAnchorState();
}

class _TPopoverAnchorState extends State<TPopoverAnchor> {
  late TPopoverController _controller;
  BuildContext? _anchorContext;
  _PopoverSession? _session;
  var _isOpen = false;
  var _operationEpoch = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TPopoverController();
    _controller._attach(this);
  }

  @override
  void didUpdateWidget(TPopoverAnchor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) {
      return;
    }
    _controller._detach(this);
    _controller = widget.controller ?? TPopoverController();
    _controller._attach(this);
    final session = _session;
    if (session != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && identical(_session, session)) {
          session.markNeedsBuild();
        }
      });
    }
  }

  void _open() {
    if (_isOpen || !mounted) {
      return;
    }
    final anchorContext = _anchorContext;
    if (anchorContext == null) {
      return;
    }
    final operationEpoch = ++_operationEpoch;
    final session = TPopover._showPopover(
      context: anchorContext,
      content: widget.content,
      offset: widget.offset,
      colorScheme: widget.colorScheme,
      closeOnClickOutside: widget.closeOnClickOutside,
      closeOnScroll: widget.closeOnScroll,
      placement: widget.placement,
      showArrow: widget.showArrow,
      arrowSize: widget.arrowSize,
      padding: widget.padding,
      width: widget.width,
      height: widget.height,
      overlayColor: widget.overlayColor,
      onTap: widget.onTap,
      onLongTap: widget.onLongTap,
      radius: widget.radius,
      controllerProvider: () => _controller,
      onDismissed: () => _handleDismissed(operationEpoch),
      throwOnMissingOverlay: true,
    );
    if (!session.didShow) {
      return;
    }
    _session = session;
    _isOpen = true;
    setState(() {});
    widget.onOpen?.call();
  }

  void _close() => _session?.close();

  void _handleDismissed(int operationEpoch) {
    if (operationEpoch != _operationEpoch || !_isOpen) {
      return;
    }
    _session = null;
    _isOpen = false;
    if (mounted) {
      setState(() {});
      widget.onClose?.call();
    }
  }

  @override
  void dispose() {
    final wasOpen = _isOpen;
    _operationEpoch++;
    _session?.close();
    _session = null;
    _isOpen = false;
    _controller._detach(this);
    if (wasOpen) {
      widget.onClose?.call();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _TPopoverControllerScope(
      controller: _controller,
      isOpen: _isOpen,
      child: Builder(
        builder: (anchorContext) {
          _anchorContext = anchorContext;
          return widget.builder(anchorContext, _controller, widget.child);
        },
      ),
    );
  }
}

class _PopoverSession {
  const _PopoverSession({
    required this.closed,
    required this.close,
    required this.didShow,
    required this.markNeedsBuild,
  });

  final Future<void> closed;
  final VoidCallback close;
  final bool didShow;
  final VoidCallback markNeedsBuild;
}

/// 气泡弹层
///
/// 可通过 [showPopover] 一次性弹出，或通过 [TPopoverAnchor] 建立可控制气泡，
/// 支持 12 个方向定位和箭头。
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
  }) => _showPopover(
    context: context,
    content: content,
    offset: offset,
    colorScheme: colorScheme,
    closeOnClickOutside: closeOnClickOutside,
    closeOnScroll: closeOnScroll,
    placement: placement,
    showArrow: showArrow,
    arrowSize: arrowSize,
    padding: padding,
    width: width,
    height: height,
    overlayColor: overlayColor,
    onTap: onTap,
    onLongTap: onLongTap,
    radius: radius,
  ).closed;

  static _PopoverSession _showPopover({
    required BuildContext context,
    required Widget content,
    required double? offset,
    required TPopoverColorScheme colorScheme,
    required bool closeOnClickOutside,
    required bool closeOnScroll,
    required TPopoverPlacement placement,
    required bool? showArrow,
    required double? arrowSize,
    required EdgeInsetsGeometry? padding,
    required double? width,
    required double? height,
    required Color? overlayColor,
    required VoidCallback? onTap,
    required VoidCallback? onLongTap,
    required BorderRadius? radius,
    TPopoverController Function()? controllerProvider,
    VoidCallback? onDismissed,
    bool throwOnMissingOverlay = false,
  }) {
    final theme =
        Theme.of(context).extension<TPopoverThemeData>() ??
        const TPopoverThemeData();
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      final error = FlutterError('TPopover requires an Overlay ancestor.');
      if (throwOnMissingOverlay) {
        throw error;
      }
      return _PopoverSession(
        closed: Future<void>.error(error),
        close: () {},
        didShow: false,
        markNeedsBuild: () {},
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
      onDismissed?.call();
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
      final overlayContent = Stack(
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
      final controller = controllerProvider?.call();
      if (controller == null) {
        return overlayContent;
      }
      return _TPopoverControllerScope(
        controller: controller,
        isOpen: true,
        child: overlayContent,
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
    return _PopoverSession(
      closed: completer.future,
      close: dismiss,
      didShow: true,
      markNeedsBuild: entry.markNeedsBuild,
    );
  }
}
