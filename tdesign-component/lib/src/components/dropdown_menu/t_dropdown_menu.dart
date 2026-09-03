import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import 't_dropdown_theme_data.dart';

/// 下拉筛选面板相对筛选栏的展开位置。
enum TDropdownMenuPlacement { auto, below, above }

/// 下拉筛选面板关闭的原因。
enum TDropdownMenuCloseReason {
  selection,
  confirm,
  cancel,
  overlay,
  back,
  trigger,
  controller,
  switchItem,
}

/// 下拉筛选面板关闭回调。
typedef TDropdownMenuClosedCallback =
    void Function(int index, TDropdownMenuCloseReason reason);

/// 默认触发项的面板构建器。
typedef TDropdownMenuPanelBuilder =
    Widget Function(
      BuildContext context,
      TDropdownMenuPanelController controller,
    );

/// 自定义触发项构建器。
typedef TDropdownMenuTriggerBuilder =
    Widget Function(BuildContext context, TDropdownMenuTriggerState state);

class _TDropdownMenuReveal extends StatelessWidget {
  const _TDropdownMenuReveal({
    super.key,
    required this.sizeFactor,
    required this.alignment,
    required this.child,
  });

  final Animation<double> sizeFactor;
  final AlignmentGeometry alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: sizeFactor,
      child: child,
      builder: (context, child) => ClipRect(
        child: Align(
          alignment: alignment,
          heightFactor: sizeFactor.value,
          child: child,
        ),
      ),
    );
  }
}

/// 自定义触发项可读取的不可变状态。
class TDropdownMenuTriggerState {
  const TDropdownMenuTriggerState({
    required this.index,
    required this.isOpen,
    required this.enabled,
    required this.toggle,
  });

  final int index;
  final bool isOpen;
  final bool enabled;
  final VoidCallback toggle;
}

/// 当前面板可使用的局部控制器。
class TDropdownMenuPanelController {
  const TDropdownMenuPanelController._({
    required this.index,
    required Future<void> Function(TDropdownMenuCloseReason reason) close,
  }) : _close = close;

  final int index;
  final Future<void> Function(TDropdownMenuCloseReason reason) _close;

  Future<void> close([
    TDropdownMenuCloseReason reason = TDropdownMenuCloseReason.cancel,
  ]) => _close(reason);
}

/// 一个筛选触发项及其对应面板。
class TDropdownMenuItem {
  const TDropdownMenuItem({
    required this.label,
    required this.panelBuilder,
    this.enabled = true,
    this.flex = 1,
    this.width,
  }) : triggerBuilder = null,
       assert(flex > 0);

  const TDropdownMenuItem.custom({
    required this.triggerBuilder,
    required this.panelBuilder,
    this.enabled = true,
    this.flex = 1,
    this.width,
  }) : label = null,
       assert(flex > 0);

  final String? label;
  final TDropdownMenuTriggerBuilder? triggerBuilder;
  final TDropdownMenuPanelBuilder panelBuilder;
  final bool enabled;
  final int flex;
  final double? width;
}

/// 类型安全的下拉筛选栏控制器。
class TDropdownMenuController extends ChangeNotifier {
  Future<void> Function(int index)? _openCallback;
  Future<void> Function(TDropdownMenuCloseReason reason)? _closeCallback;
  Future<void> Function(int index)? _toggleCallback;
  int? _openIndex;

  int? get openIndex => _openIndex;
  bool get isOpen => _openIndex != null;

  Future<void> open(int index) async {
    await _openCallback?.call(index);
  }

  Future<void> close() async {
    await _closeCallback?.call(TDropdownMenuCloseReason.controller);
  }

  Future<void> toggle(int index) async {
    await _toggleCallback?.call(index);
  }

  void _attach({
    required Future<void> Function(int index) open,
    required Future<void> Function(TDropdownMenuCloseReason reason) close,
    required Future<void> Function(int index) toggle,
  }) {
    _openCallback = open;
    _closeCallback = close;
    _toggleCallback = toggle;
  }

  void _detach() {
    _openCallback = null;
    _closeCallback = null;
    _toggleCallback = null;
    _openIndex = null;
  }

  void _setOpenIndex(int? value) {
    if (_openIndex == value) {
      return;
    }
    _openIndex = value;
    notifyListeners();
  }
}

/// 用于页面内容排序、筛选的横向下拉筛选栏。
class TDropdownMenu extends StatefulWidget {
  const TDropdownMenu({
    super.key,
    required this.items,
    this.controller,
    this.placement = TDropdownMenuPlacement.auto,
    this.scrollable = false,
    this.showOverlay = true,
    this.closeOnOverlayTap = true,
    this.useRootOverlay = false,
    this.animationDuration,
    this.onOpened,
    this.onClosed,
  });

  final List<TDropdownMenuItem> items;
  final TDropdownMenuController? controller;
  final TDropdownMenuPlacement placement;
  final bool scrollable;
  final bool showOverlay;
  final bool closeOnOverlayTap;
  final bool useRootOverlay;

  /// 展开、关闭及切换动画时长。
  ///
  /// 未指定时使用 [TDropdownThemeData.animationDuration]，再回退到 200ms。
  /// 显式值（包括 [Duration.zero]）优先于主题；系统禁用动画时始终使用零时长。
  final Duration? animationDuration;
  final ValueChanged<int>? onOpened;
  final TDropdownMenuClosedCallback? onClosed;

  @override
  State<TDropdownMenu> createState() => _TDropdownMenuState();
}

class _TDropdownMenuState extends State<TDropdownMenu>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  static final Map<NavigatorState, _TDropdownMenuState> _activeMenus = {};
  static const double _autoPlacementHysteresis = 8;
  static const double _panelSwitchOffset = 0.04;

  final LayerLink _layerLink = LayerLink();
  final GlobalKey _barKey = GlobalKey();
  final GlobalKey _panelKey = GlobalKey();
  GlobalKey _activePanelKey = GlobalKey();
  final Object _tapRegionGroup = Object();
  final FocusNode _panelFocusNode = FocusNode(
    debugLabel: 'TDropdownMenu panel',
  );
  late AnimationController _animationController;
  late AnimationController _panelSwitchController;
  late TDropdownMenuController _controller;
  late bool _ownsController;
  List<FocusNode> _triggerFocusNodes = <FocusNode>[];
  OverlayEntry? _overlayEntry;
  OverlayState? _overlayState;
  CapturedThemes? _capturedThemes;
  ScrollNotificationObserverState? _scrollNotificationObserver;
  ScrollPosition? _scrollPosition;
  NavigatorState? _navigator;
  Offset? _outsidePointerDownPosition;
  int? _outsidePointer;
  int _operationEpoch = 0;
  int _panelActivationEpoch = 0;
  int? _outgoingIndex;
  int? _outgoingPanelActivation;
  final Set<int> _pendingSwitchClosures = <int>{};
  bool _disposing = false;
  bool _overlayRefreshScheduled = false;
  bool _triggerRefreshScheduled = false;
  bool _placementCheckScheduled = false;
  bool _autoOpensAbove = false;
  bool _autoPlacementResolved = false;
  double? _autoPanelHeight;
  int _autoPlacementEpoch = 0;

  TDropdownThemeData get _theme =>
      Theme.of(context).extension<TDropdownThemeData>() ??
      const TDropdownThemeData();

  Duration get _duration {
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      return Duration.zero;
    }
    return widget.animationDuration ??
        _theme.animationDuration ??
        const Duration(milliseconds: 200);
  }

  void _resetAutoPlacement({
    required bool opensAbove,
    bool replacePanelKey = false,
  }) {
    _autoPlacementEpoch++;
    _placementCheckScheduled = false;
    _autoOpensAbove = opensAbove;
    _autoPlacementResolved = false;
    _autoPanelHeight = null;
    if (replacePanelKey) {
      _activePanelKey = GlobalKey();
    }
  }

  bool _resolveAutoOpensAbove({
    required double panelHeight,
    required double above,
    required double below,
  }) {
    if (!_autoOpensAbove) {
      return panelHeight > below && above > below + _autoPlacementHysteresis;
    }
    final belowClearlyFits = panelHeight + _autoPlacementHysteresis <= below;
    final belowClearlyLarger = below > above + _autoPlacementHysteresis;
    return !belowClearlyFits && !belowClearlyLarger;
  }

  void _updateAutoDirection(bool opensAbove) {
    if (_autoOpensAbove == opensAbove) {
      return;
    }
    _autoOpensAbove = opensAbove;
    if (_triggerRefreshScheduled || _disposing) {
      return;
    }
    _triggerRefreshScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerRefreshScheduled = false;
      if (mounted && !_disposing) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _panelSwitchController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: 1,
    );
    _bindController(widget.controller);
    _syncFocusNodes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animationController.duration = _duration;
    _panelSwitchController.duration = _duration;
    if (_controller.isOpen && widget.placement == TDropdownMenuPlacement.auto) {
      _resetAutoPlacement(opensAbove: _autoOpensAbove);
    }
    _bindScrollObserver();
    _navigator = Navigator.maybeOf(context, rootNavigator: true);
    final overlay = _overlayState;
    if (overlay != null) {
      _capturedThemes = InheritedTheme.capture(
        from: context,
        to: overlay.context,
      );
    }
    _refreshOverlay();
  }

  void _bindScrollObserver() {
    final nextObserver = ScrollNotificationObserver.maybeOf(context);
    if (!identical(nextObserver, _scrollNotificationObserver)) {
      _scrollNotificationObserver?.removeListener(_handleScrollNotification);
      _scrollNotificationObserver = nextObserver;
      _scrollNotificationObserver?.addListener(_handleScrollNotification);
    }
    final nextPosition = nextObserver == null
        ? Scrollable.maybeOf(context)?.position
        : null;
    if (!identical(nextPosition, _scrollPosition)) {
      _scrollPosition?.removeListener(_refreshOverlay);
      _scrollPosition = nextPosition;
      _scrollPosition?.addListener(_refreshOverlay);
    }
  }

  bool _notificationIsFromAncestorScrollable(ScrollNotification notification) {
    final notificationContext = notification.context;
    if (notificationContext == null) {
      return false;
    }
    final notificationScrollable = notificationContext
        .findAncestorStateOfType<ScrollableState>();
    if (notificationScrollable == null) {
      return false;
    }
    BuildContext? currentContext = context;
    while (currentContext != null) {
      final scrollable = currentContext
          .findAncestorStateOfType<ScrollableState>();
      if (identical(scrollable, notificationScrollable)) {
        return true;
      }
      currentContext = scrollable?.context;
    }
    return false;
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (_notificationIsFromAncestorScrollable(notification)) {
      _refreshOverlay();
    }
  }

  @override
  void didUpdateWidget(TDropdownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    var controllerWasOpen = false;
    if (!identical(widget.controller, oldWidget.controller)) {
      controllerWasOpen = _controller.isOpen;
      if (controllerWasOpen) {
        _operationEpoch++;
        _animationController.stop();
        _clearPanelSwitch(resetAnimation: false);
        _pendingSwitchClosures.clear();
        _removeOverlay();
        _resetAutoPlacement(opensAbove: false, replacePanelKey: true);
        final navigator = _navigator;
        if (navigator != null && identical(_activeMenus[navigator], this)) {
          _activeMenus.remove(navigator);
        }
      }
      _controller._detach();
      if (_ownsController) {
        _controller.dispose();
      }
      _bindController(widget.controller);
      if (controllerWasOpen) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_controller.isOpen) {
            _animationController.value = 0;
          }
        });
      }
    }
    if (widget.items.length != oldWidget.items.length) {
      _syncFocusNodes();
    }
    _animationController.duration = _duration;
    _panelSwitchController.duration = _duration;
    final openIndex = _controller.openIndex;
    final activeItemChanged =
        openIndex != null &&
        openIndex < widget.items.length &&
        openIndex < oldWidget.items.length &&
        !identical(widget.items[openIndex], oldWidget.items[openIndex]);
    if (openIndex != null &&
        widget.placement == TDropdownMenuPlacement.auto &&
        (activeItemChanged ||
            oldWidget.placement != TDropdownMenuPlacement.auto)) {
      _resetAutoPlacement(opensAbove: _autoOpensAbove);
    }
    if (openIndex != null &&
        (openIndex >= widget.items.length ||
            !widget.items[openIndex].enabled)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _controller.openIndex != openIndex) {
          return;
        }
        if (openIndex >= widget.items.length ||
            !widget.items[openIndex].enabled) {
          unawaited(_close(TDropdownMenuCloseReason.cancel));
        }
      });
    } else if (openIndex != null &&
        widget.useRootOverlay != oldWidget.useRootOverlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controller.openIndex == openIndex) {
          _insertOverlay();
        }
      });
    } else {
      _refreshOverlay();
    }
  }

  @override
  void didChangeMetrics() {
    _refreshOverlay();
  }

  @override
  void dispose() {
    _disposing = true;
    WidgetsBinding.instance.removeObserver(this);
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollPosition?.removeListener(_refreshOverlay);
    if (_navigator case final navigator?) {
      if (identical(_activeMenus[navigator], this)) {
        _activeMenus.remove(navigator);
      }
    }
    _operationEpoch++;
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
    _overlayState = null;
    _capturedThemes = null;
    _controller._detach();
    if (_ownsController) {
      _controller.dispose();
    }
    for (final node in _triggerFocusNodes) {
      node.dispose();
    }
    _panelFocusNode.dispose();
    _animationController.dispose();
    _panelSwitchController.dispose();
    super.dispose();
  }

  void _bindController(TDropdownMenuController? external) {
    _ownsController = external == null;
    _controller = external ?? TDropdownMenuController();
    _controller._attach(open: _open, close: _close, toggle: _toggle);
  }

  void _syncFocusNodes() {
    final old = _triggerFocusNodes;
    _triggerFocusNodes = List<FocusNode>.generate(
      widget.items.length,
      (index) => index < old.length
          ? old[index]
          : FocusNode(debugLabel: 'TDropdownMenu trigger $index'),
    );
    for (var index = widget.items.length; index < old.length; index++) {
      old[index].dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final material = Theme.of(context);
    final colorScheme = material.tExplicitColorScheme;
    final theme = _theme;
    final bar = widget.scrollable
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List<Widget>.generate(
                widget.items.length,
                (index) => SizedBox(
                  width: widget.items[index].width ?? 112,
                  child: _buildTrigger(index),
                ),
              ),
            ),
          )
        : LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.hasBoundedWidth) {
                return Row(
                  children: List<Widget>.generate(
                    widget.items.length,
                    (index) => Expanded(
                      flex: widget.items[index].flex,
                      child: _buildTrigger(index),
                    ),
                  ),
                );
              }
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(
                  widget.items.length,
                  (index) => SizedBox(
                    width: widget.items[index].width ?? 112,
                    child: _buildTrigger(index),
                  ),
                ),
              );
            },
          );

    return PopScope<void>(
      canPop: !_controller.isOpen,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _controller.isOpen) {
          unawaited(_close(TDropdownMenuCloseReason.back));
        }
      },
      child: TapRegion(
        groupId: _tapRegionGroup,
        onTapOutside: _handleTapOutside,
        onTapUpOutside: _handleTapUpOutside,
        child: _DropdownTransformTarget(
          link: _layerLink,
          trackTransforms: _controller.isOpen,
          child: Container(
            key: _barKey,
            height: theme.barHeight ?? 48,
            decoration: BoxDecoration(
              color:
                  theme.barBackgroundColor ??
                  colorScheme?.surface ??
                  context.tTheme.bgColorContainer,
              border: Border(
                bottom: BorderSide(
                  color:
                      theme.dividerColor ??
                      material.tExplicitDividerColor ??
                      context.tTheme.componentStrokeColor,
                  width: 0.5,
                ),
              ),
            ),
            child: bar,
          ),
        ),
      ),
    );
  }

  Widget _buildTrigger(int index) {
    final material = Theme.of(context);
    final colorScheme = material.tExplicitColorScheme;
    final item = widget.items[index];
    final isOpen = _controller.openIndex == index;
    final onTap = item.enabled ? () => unawaited(_toggle(index)) : null;
    if (item.triggerBuilder != null) {
      return Semantics(
        button: true,
        enabled: item.enabled,
        expanded: isOpen,
        child: Focus(
          focusNode: _triggerFocusNodes[index],
          child: item.triggerBuilder!(
            context,
            TDropdownMenuTriggerState(
              index: index,
              isOpen: isOpen,
              enabled: item.enabled,
              toggle: onTap ?? () {},
            ),
          ),
        ),
      );
    }

    final theme = _theme;
    final tokenFont = context.tTheme.fontBodyMedium;
    final activeTokenFont = context.tTheme.fontMarkMedium;
    final baseStyle =
        theme.textStyle ??
        context.tExplicitDefaultTextStyle ??
        material.tExplicitTextTheme?.bodyMedium ??
        TextStyle(
          color: context.tTheme.textColorPrimary,
          fontSize: tokenFont?.size,
          height: tokenFont?.height,
          fontWeight: tokenFont?.fontWeight,
        );
    final style = !item.enabled
        ? theme.disabledTextStyle ??
              baseStyle.copyWith(
                color:
                    material.tExplicitDisabledColor ??
                    context.tTheme.textDisabledColor,
              )
        : isOpen
        ? theme.activeTextStyle ??
              baseStyle.copyWith(
                color: colorScheme?.primary ?? context.tTheme.brandNormalColor,
                fontWeight: activeTokenFont?.fontWeight,
              )
        : baseStyle.copyWith(
            color: baseStyle.color ?? context.tTheme.textColorPrimary,
          );
    final iconColor = !item.enabled
        ? theme.disabledIconColor ??
              material.tExplicitDisabledColor ??
              context.tTheme.textDisabledColor
        : isOpen
        ? theme.activeIconColor ??
              colorScheme?.primary ??
              context.tTheme.brandNormalColor
        : theme.iconColor ??
              context.tExplicitIconTheme?.color ??
              context.tTheme.textColorPrimary;
    final opensAbove = switch (widget.placement) {
      TDropdownMenuPlacement.above => true,
      TDropdownMenuPlacement.below => false,
      TDropdownMenuPlacement.auto => isOpen && _autoOpensAbove,
    };
    final arrowTurns = opensAbove ? (isOpen ? 0.0 : 0.5) : (isOpen ? 0.5 : 0.0);

    return Semantics(
      button: true,
      enabled: item.enabled,
      expanded: isOpen,
      child: InkWell(
        focusNode: _triggerFocusNodes[index],
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                item.label!,
                style: style,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: context.tTheme.spacer4),
            AnimatedRotation(
              turns: arrowTurns,
              duration: _duration,
              curve: Curves.ease,
              child: Icon(
                TIcons.caret_down_small,
                size: theme.iconSize ?? 24,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggle(int index) async {
    if (_controller.openIndex == index) {
      await _close(TDropdownMenuCloseReason.trigger);
      return;
    }
    await _open(index);
  }

  void _handleTapOutside(PointerDownEvent event) {
    if (!_controller.isOpen) {
      return;
    }
    _outsidePointer = event.pointer;
    _outsidePointerDownPosition = event.position;
  }

  void _handleTapUpOutside(PointerUpEvent event) {
    final downPosition = _outsidePointer == event.pointer
        ? _outsidePointerDownPosition
        : null;
    _outsidePointer = null;
    _outsidePointerDownPosition = null;
    if (!_controller.isOpen ||
        !widget.closeOnOverlayTap ||
        downPosition == null) {
      return;
    }
    if ((event.position - downPosition).distance <= kTouchSlop) {
      unawaited(_close(TDropdownMenuCloseReason.overlay));
    }
  }

  Future<void> _waitForAutoPlacement() async {
    if (widget.placement != TDropdownMenuPlacement.auto ||
        _duration == Duration.zero) {
      return;
    }
    await WidgetsBinding.instance.endOfFrame;
  }

  void _clearPanelSwitch({bool resetAnimation = true}) {
    _panelSwitchController.stop();
    if (resetAnimation) {
      _panelSwitchController.value = 1;
    }
    _outgoingIndex = null;
    _outgoingPanelActivation = null;
  }

  void _flushPendingSwitchClosures({int? except}) {
    final closedIndices = _pendingSwitchClosures
        .where((index) => index != except)
        .toList(growable: false);
    _pendingSwitchClosures.clear();
    for (final index in closedIndices) {
      widget.onClosed?.call(index, TDropdownMenuCloseReason.switchItem);
    }
  }

  Future<void> _open(int index) async {
    if (!mounted ||
        index < 0 ||
        index >= widget.items.length ||
        !widget.items[index].enabled) {
      return;
    }
    if (_controller.openIndex == index) {
      return;
    }
    if (_controller.isOpen) {
      await _switchItem(index);
      return;
    }

    final navigator =
        _navigator ?? Navigator.maybeOf(context, rootNavigator: true);
    final activeMenu = navigator == null ? null : _activeMenus[navigator];
    if (activeMenu != null && !identical(activeMenu, this)) {
      await activeMenu._close(TDropdownMenuCloseReason.switchItem);
      if (!mounted || activeMenu._controller.isOpen) {
        return;
      }
    }

    final epoch = ++_operationEpoch;
    if (navigator != null) {
      _navigator = navigator;
      _activeMenus[navigator] = this;
    }
    _resetAutoPlacement(opensAbove: false, replacePanelKey: true);
    _panelActivationEpoch++;
    _clearPanelSwitch();
    _pendingSwitchClosures.clear();
    _controller._setOpenIndex(index);
    setState(() {});
    _insertOverlay();
    _animationController.duration = _duration;
    await _waitForAutoPlacement();
    if (!mounted ||
        epoch != _operationEpoch ||
        _controller.openIndex != index) {
      return;
    }
    try {
      await _animationController.forward(from: 0).orCancel;
    } on TickerCanceled {
      return;
    }
    if (!mounted ||
        epoch != _operationEpoch ||
        _controller.openIndex != index) {
      return;
    }
    _panelFocusNode.requestFocus();
    widget.onOpened?.call(index);
  }

  Future<void> _switchItem(int index) async {
    final previousIndex = _controller.openIndex;
    if (previousIndex == null || previousIndex == index) {
      return;
    }

    final epoch = ++_operationEpoch;
    _panelSwitchController.stop();
    _panelSwitchController.value = 0;
    _outgoingIndex = previousIndex;
    _outgoingPanelActivation = _panelActivationEpoch;
    _panelActivationEpoch++;
    _pendingSwitchClosures.add(previousIndex);
    _resetAutoPlacement(opensAbove: _autoOpensAbove, replacePanelKey: true);
    _controller._setOpenIndex(index);
    setState(() {});
    _overlayEntry?.markNeedsBuild();

    await _waitForAutoPlacement();
    if (!mounted ||
        epoch != _operationEpoch ||
        _controller.openIndex != index) {
      return;
    }
    _panelSwitchController.duration = _duration;
    _animationController.duration = _duration;
    final animations = <Future<void>>[
      _panelSwitchController.forward(from: 0).orCancel,
      _animationController.forward().orCancel,
    ];
    try {
      await Future.wait(animations);
    } on TickerCanceled {
      return;
    }
    if (epoch != _operationEpoch || _controller.openIndex != index) {
      return;
    }
    _outgoingIndex = null;
    _outgoingPanelActivation = null;
    _overlayEntry?.markNeedsBuild();
    _flushPendingSwitchClosures(except: index);
    _panelFocusNode.requestFocus();
    widget.onOpened?.call(index);
  }

  Future<void> _close(TDropdownMenuCloseReason reason) async {
    final index = _controller.openIndex;
    if (index == null) {
      return;
    }
    final epoch = ++_operationEpoch;
    _clearPanelSwitch();
    _overlayEntry?.markNeedsBuild();
    try {
      await _animationController.reverse().orCancel;
    } on TickerCanceled {
      return;
    }
    if (epoch != _operationEpoch) {
      return;
    }
    _removeOverlay();
    _resetAutoPlacement(opensAbove: false);
    _controller._setOpenIndex(null);
    _flushPendingSwitchClosures();
    final navigator = _navigator;
    if (navigator != null && identical(_activeMenus[navigator], this)) {
      _activeMenus.remove(navigator);
    }
    if (mounted) {
      setState(() {});
      if (index < _triggerFocusNodes.length) {
        _triggerFocusNodes[index].requestFocus();
      }
      widget.onClosed?.call(index, reason);
    }
  }

  void _insertOverlay() {
    _removeOverlay();
    final overlay = Overlay.of(context, rootOverlay: widget.useRootOverlay);
    _overlayState = overlay;
    _capturedThemes = InheritedTheme.capture(
      from: context,
      to: overlay.context,
    );
    _overlayEntry = OverlayEntry(builder: _buildOverlay);
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
    _overlayState = null;
    _capturedThemes = null;
    _placementCheckScheduled = false;
  }

  void _refreshOverlay() {
    if (_disposing ||
        _overlayRefreshScheduled ||
        _overlayEntry?.mounted != true) {
      return;
    }
    _overlayRefreshScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayRefreshScheduled = false;
      if (!_disposing && _overlayEntry?.mounted == true) {
        _overlayEntry?.markNeedsBuild();
      }
    });
  }

  Rect? _anchorRect(RenderBox overlayBox) {
    final renderObject = _barKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) {
      return null;
    }
    final topLeft = renderObject.localToGlobal(
      Offset.zero,
      ancestor: overlayBox,
    );
    return topLeft & renderObject.size;
  }

  void _scheduleAutoPlacementCheck({
    required double above,
    required double below,
  }) {
    if (_placementCheckScheduled ||
        widget.placement != TDropdownMenuPlacement.auto ||
        _autoPlacementResolved) {
      return;
    }
    _placementCheckScheduled = true;
    final placementEpoch = _autoPlacementEpoch;
    final panelKey = _activePanelKey;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (placementEpoch != _autoPlacementEpoch) {
        return;
      }
      _placementCheckScheduled = false;
      if (_disposing || _overlayEntry?.mounted != true) {
        return;
      }
      final renderObject = panelKey.currentContext?.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.hasSize) {
        return;
      }
      final shouldOpenAbove = _resolveAutoOpensAbove(
        panelHeight: renderObject.size.height,
        above: above,
        below: below,
      );
      _autoPanelHeight = renderObject.size.height;
      _autoPlacementResolved = true;
      _updateAutoDirection(shouldOpenAbove);
      _overlayEntry?.markNeedsBuild();
    });
  }

  Widget _buildOverlay(BuildContext overlayContext) {
    final overlayBox = _overlayState?.context.findRenderObject();
    if (overlayBox is! RenderBox) {
      return const SizedBox.shrink();
    }
    final rect = _anchorRect(overlayBox);
    final index = _controller.openIndex;
    if (rect == null || index == null || index >= widget.items.length) {
      return const SizedBox.shrink();
    }
    final media = MediaQuery.of(context);
    final view = View.of(context);
    final anchorSeamExtent = 1 / view.devicePixelRatio;
    final keyboardInset = math.max(
      media.viewInsets.bottom,
      view.viewInsets.bottom / view.devicePixelRatio,
    );
    final safeTop = media.padding.top;
    final safeBottom =
        overlayBox.size.height - media.padding.bottom - keyboardInset;
    final above = (rect.top - safeTop).clamp(0.0, double.infinity);
    final below = (safeBottom - rect.bottom).clamp(0.0, double.infinity);
    final resolvedAutoOpensAbove = switch (_autoPanelHeight) {
      final height? => _resolveAutoOpensAbove(
        panelHeight: height,
        above: above,
        below: below,
      ),
      null => _autoOpensAbove,
    };
    if (_autoPanelHeight != null) {
      _updateAutoDirection(resolvedAutoOpensAbove);
    }
    final opensAbove = switch (widget.placement) {
      TDropdownMenuPlacement.above => true,
      TDropdownMenuPlacement.below => false,
      TDropdownMenuPlacement.auto => _autoOpensAbove,
    };
    final maxHeight =
        widget.placement == TDropdownMenuPlacement.auto &&
            !_autoPlacementResolved
        ? math.max(above, below)
        : opensAbove
        ? above
        : below;
    final barrierExtent = opensAbove
        ? rect.top.clamp(0.0, overlayBox.size.height)
        : (overlayBox.size.height - rect.bottom).clamp(
            0.0,
            overlayBox.size.height,
          );
    final anchorVisible =
        rect.bottom > 0 &&
        rect.top < overlayBox.size.height &&
        rect.right > 0 &&
        rect.left < overlayBox.size.width;
    if (!anchorVisible ||
        maxHeight <= 0 ||
        (widget.placement != TDropdownMenuPlacement.auto &&
            barrierExtent <= 0)) {
      return const SizedBox.shrink();
    }
    final followerExtent = widget.placement == TDropdownMenuPlacement.auto
        ? math.max(maxHeight, barrierExtent)
        : barrierExtent;
    final theme = _theme;
    final material = Theme.of(context);
    final colorScheme = material.tExplicitColorScheme;
    final panelBackgroundColor =
        theme.panelBackgroundColor ??
        colorScheme?.surface ??
        context.tTheme.bgColorContainer;

    Widget buildPanel({
      required int panelIndex,
      required int activation,
      GlobalKey? measureKey,
    }) {
      final panelController = TDropdownMenuPanelController._(
        index: panelIndex,
        close: (reason) {
          if (_controller.openIndex != panelIndex) {
            return Future<void>.value();
          }
          return _close(reason);
        },
      );
      return KeyedSubtree(
        key: ValueKey<int>(activation),
        child: KeyedSubtree(
          key: const ValueKey<String>('t-dropdown-menu-panel'),
          child: ConstrainedBox(
            key: measureKey,
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Material(
              color: panelBackgroundColor,
              child: FocusScope(
                child: widget.items[panelIndex].panelBuilder(
                  context,
                  panelController,
                ),
              ),
            ),
          ),
        ),
      );
    }

    final switchOffset = opensAbove
        ? const Offset(0, _panelSwitchOffset)
        : const Offset(0, -_panelSwitchOffset);
    final switchAnimation = CurvedAnimation(
      parent: _panelSwitchController,
      curve: Curves.easeInOutCubic,
    );
    final outgoingIndex = _outgoingIndex;
    final outgoingActivation = _outgoingPanelActivation;
    final canBuildOutgoing =
        outgoingIndex != null &&
        outgoingActivation != null &&
        outgoingIndex < widget.items.length;
    final panelSwitcher = AnimatedBuilder(
      animation: _panelSwitchController,
      builder: (context, child) {
        return Stack(
          clipBehavior: Clip.hardEdge,
          alignment: opensAbove ? Alignment.bottomCenter : Alignment.topCenter,
          children: [
            if (canBuildOutgoing)
              IgnorePointer(
                child: ExcludeSemantics(
                  child: SlideTransition(
                    key: const ValueKey<String>(
                      't-dropdown-menu-outgoing-slide',
                    ),
                    position: Tween<Offset>(
                      begin: Offset.zero,
                      end: switchOffset,
                    ).animate(switchAnimation),
                    child: SizedBox(
                      width: rect.width,
                      child: buildPanel(
                        panelIndex: outgoingIndex,
                        activation: outgoingActivation,
                      ),
                    ),
                  ),
                ),
              ),
            SlideTransition(
              key: const ValueKey<String>('t-dropdown-menu-incoming-slide'),
              position: Tween<Offset>(
                begin: switchOffset,
                end: Offset.zero,
              ).animate(switchAnimation),
              child: SizedBox(
                width: rect.width,
                child: buildPanel(
                  panelIndex: index,
                  activation: _panelActivationEpoch,
                  measureKey: _activePanelKey,
                ),
              ),
            ),
          ],
        );
      },
    );
    final switchingPanel = ClipRect(
      key: _panelKey,
      child: ColoredBox(
        key: const ValueKey<String>('t-dropdown-menu-panel-surface'),
        color: panelBackgroundColor,
        child: panelSwitcher,
      ),
    );
    final focusedPanel = Focus(
      focusNode: _panelFocusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          unawaited(_close(TDropdownMenuCloseReason.cancel));
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: switchingPanel,
    );
    final animatedPanel = _TDropdownMenuReveal(
      key: const ValueKey<String>('t-dropdown-menu-open-close-reveal'),
      sizeFactor: CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
      alignment: opensAbove
          ? AlignmentDirectional.bottomStart
          : AlignmentDirectional.topStart,
      child: focusedPanel,
    );
    final anchoredPanel = Stack(
      clipBehavior: Clip.none,
      children: [
        animatedPanel,
        Positioned(
          key: const ValueKey<String>('t-dropdown-menu-anchor-seam'),
          top: opensAbove ? null : -anchorSeamExtent,
          bottom: opensAbove ? -anchorSeamExtent : null,
          left: 0,
          right: 0,
          height: anchorSeamExtent * 2,
          child: IgnorePointer(child: ColoredBox(color: panelBackgroundColor)),
        ),
      ],
    );
    final captured = _capturedThemes;
    _scheduleAutoPlacementCheck(above: above, below: below);

    Widget barrier() {
      final overlayColor = theme.overlayColor ?? const Color(0x99000000);
      return TapRegion(
        groupId: _tapRegionGroup,
        child: Semantics(
          label: MaterialLocalizations.of(context).modalBarrierDismissLabel,
          button: widget.closeOnOverlayTap,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.closeOnOverlayTap
                ? () => unawaited(_close(TDropdownMenuCloseReason.overlay))
                : null,
            child: ColoredBox(
              key: const ValueKey<String>('t-dropdown-menu-overlay'),
              color: widget.showOverlay
                  ? overlayColor.withValues(
                      alpha: overlayColor.a * _animationController.value,
                    )
                  : Colors.transparent,
            ),
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return captured!.wrap(
          SizedBox.expand(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  targetAnchor: opensAbove
                      ? Alignment.topLeft
                      : Alignment.bottomLeft,
                  followerAnchor: opensAbove
                      ? Alignment.bottomLeft
                      : Alignment.topLeft,
                  offset: Offset(-rect.left, 0),
                  child: SizedBox(
                    width: overlayBox.size.width,
                    height: followerExtent,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: opensAbove ? null : 0,
                          bottom: opensAbove ? 0 : null,
                          left: 0,
                          right: 0,
                          height: barrierExtent,
                          child: barrier(),
                        ),
                        Positioned(
                          left: rect.left,
                          top: opensAbove ? null : 0,
                          bottom: opensAbove ? 0 : null,
                          width: rect.width,
                          child: TapRegion(
                            groupId: _tapRegionGroup,
                            child: anchoredPanel,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Reports affine transforms omitted by image-filter layers to the follower.
/// The menu itself is still painted through the original ancestor filters.
class _DropdownTransformTarget extends CompositedTransformTarget {
  const _DropdownTransformTarget({
    required super.link,
    required super.child,
    required this.trackTransforms,
  });

  final bool trackTransforms;

  @override
  RenderLeaderLayer createRenderObject(BuildContext context) {
    return _DropdownRenderLeaderLayer(
      link: link,
      trackTransforms: trackTransforms,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderLeaderLayer renderObject,
  ) {
    super.updateRenderObject(context, renderObject);
    (renderObject as _DropdownRenderLeaderLayer).trackTransforms =
        trackTransforms;
  }
}

class _DropdownRenderLeaderLayer extends RenderLeaderLayer {
  _DropdownRenderLeaderLayer({
    required super.link,
    required bool trackTransforms,
  }) : _trackTransforms = trackTransforms;

  bool _trackTransforms;
  bool get trackTransforms => _trackTransforms;
  set trackTransforms(bool value) {
    if (_trackTransforms == value) {
      return;
    }
    _trackTransforms = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    layer ??= _DropdownLeaderLayer(link: link, target: this);
    super.paint(context, offset);
  }
}

class _DropdownLeaderLayer extends LeaderLayer {
  _DropdownLeaderLayer({required super.link, required this.target});

  final _DropdownRenderLeaderLayer target;
  Matrix4? _correction;

  @override
  bool get alwaysNeedsAddToScene =>
      target.trackTransforms || super.alwaysNeedsAddToScene;

  @override
  void addToScene(ui.SceneBuilder builder) {
    _correction = null;
    if (target.trackTransforms && target.attached) {
      final ancestors = <ContainerLayer>[];
      for (
        var ancestor = parent;
        ancestor != null;
        ancestor = ancestor.parent
      ) {
        ancestors.add(ancestor);
      }
      final layerTransform = Matrix4.identity();
      for (var index = ancestors.length - 1; index >= 0; index--) {
        ancestors[index].applyTransform(
          index == 0 ? this : ancestors[index - 1],
          layerTransform,
        );
      }
      super.applyTransform(null, layerTransform);

      // An explicit root includes its view transform, matching the layer tree.
      RenderObject root = target;
      while (root.parent != null) {
        root = root.parent!;
      }
      final renderTransform = target.getTransformTo(root);
      if (!MatrixUtils.matrixEquals(layerTransform, renderTransform)) {
        _correction = Matrix4.tryInvert(layerTransform)
          ?..multiply(renderTransform);
      }
    }
    super.addToScene(builder);
  }

  @override
  void applyTransform(Layer? child, Matrix4 transform) {
    super.applyTransform(child, transform);
    final correction = _correction;
    if (correction != null) {
      transform.multiply(correction);
    }
  }
}
