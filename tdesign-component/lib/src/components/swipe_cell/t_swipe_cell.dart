import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 't_swipe_cell_inherited.dart';
import 't_swipe_cell_panel.dart';

/// 操作面板所在侧。
enum TSwipeCellSide { start, end }

/// 滑动展开状态变化回调。
typedef TSwipeCellChanged = void Function(TSwipeCellSide side, bool isOpen);

/// [TSwipeCell] 的命令式控制器。
///
/// 一个控制器同一时间只能绑定一个 [TSwipeCell]。通常无需使用控制器，用户拖动、
/// 点击操作项、点击单元格外部或滚动列表时，组件会自行管理展开状态。
class TSwipeCellController {
  _TSwipeCellControllerBinding? _binding;

  /// 展开指定侧的操作面板。
  Future<void> open(TSwipeCellSide side) async {
    await _binding?.open(side);
  }

  /// 关闭当前展开的操作面板。
  Future<void> close() async {
    await _binding?.close();
  }

  void _attach(_TSwipeCellControllerBinding binding) {
    if (_binding != null && !identical(_binding, binding)) {
      throw FlutterError(
        'A TSwipeCellController can only be attached to one TSwipeCell.',
      );
    }
    _binding = binding;
  }

  void _detach(_TSwipeCellControllerBinding binding) {
    if (identical(_binding, binding)) {
      _binding = null;
    }
  }
}

abstract interface class _TSwipeCellControllerBinding {
  Future<void> open(TSwipeCellSide side);

  Future<void> close();
}

/// 滑动单元格组件。
class TSwipeCell extends StatefulWidget {
  const TSwipeCell({
    Key? key,
    required this.child,
    this.enabled = true,
    this.start,
    this.end,
    this.onOpenChanged,
    this.controller,
    this.initialOpenSide,
    this.closeOnScroll = true,
  }) : super(key: key);

  /// 要增强为可滑动单元格的内容。
  final Widget child;

  /// 是否允许用户拖动，默认为 true。
  final bool enabled;

  /// 起始侧操作面板。
  final TSwipeCellPanel? start;

  /// 结束侧操作面板。
  final TSwipeCellPanel? end;

  /// 面板展开状态变化回调。
  final TSwipeCellChanged? onOpenChanged;

  /// 命令式控制器。
  final TSwipeCellController? controller;

  /// 首次布局后默认展开的面板；为空时保持关闭。
  final TSwipeCellSide? initialOpenSide;

  /// 祖先滚动容器开始滚动时是否关闭面板，默认为 true。
  final bool closeOnScroll;

  @override
  State<TSwipeCell> createState() => _TSwipeCellState();
}

class _TSwipeCellState extends State<TSwipeCell>
    with SingleTickerProviderStateMixin
    implements _TSwipeCellControllerBinding {
  static const _animationDuration = Duration(milliseconds: 600);
  static const _animationCurve = Cubic(0.18, 0.89, 0.32, 1);
  static const _openThreshold = 0.3;
  static final Map<ModalRoute<dynamic>?, Set<_TSwipeCellState>>
  _instancesByRoute = <ModalRoute<dynamic>?, Set<_TSwipeCellState>>{};

  final _startPanelKey = GlobalKey();
  final _endPanelKey = GlobalKey();

  late final AnimationController _offsetController;
  ScrollPosition? _scrollPosition;
  ModalRoute<dynamic>? _route;
  TextDirection? _textDirection;
  TSwipeCellSide? _openSide;
  double _startExtent = 0;
  double _endExtent = 0;
  double _dragStartOffset = 0;
  TSwipeCellSide? _dragStartSide;
  bool _dragCanceled = false;
  bool _tapOutsideRouteRegistered = false;
  bool _measurementScheduled = false;

  double get _offset => _offsetController.value;

  double get _startSign =>
      (_textDirection ?? Directionality.of(context)) == TextDirection.ltr
      ? 1
      : -1;

  double get _startTarget => _startSign * _startExtent;

  double get _endTarget => -_startSign * _endExtent;

  @override
  void initState() {
    super.initState();
    _offsetController = AnimationController.unbounded(vsync: this);
    widget.controller?._attach(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }
      _refreshPanelExtents();
      final initialOpenSide = widget.initialOpenSide;
      if (initialOpenSide != null) {
        await open(initialOpenSide);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bindRoute();
    _bindScrollable();
    final textDirection = Directionality.of(context);
    final directionChanged =
        _textDirection != null && _textDirection != textDirection;
    _textDirection = textDirection;
    if (directionChanged) {
      _schedulePanelMeasurement();
    }
  }

  @override
  void didUpdateWidget(covariant TSwipeCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      widget.controller?._attach(this);
    }
    if (oldWidget.closeOnScroll != widget.closeOnScroll) {
      _bindScrollable();
    }
    _schedulePanelMeasurement();
  }

  @override
  void dispose() {
    _unbindRoute();
    widget.controller?._detach(this);
    _unbindScrollable();
    _unregisterTapOutsideListener();
    _offsetController.dispose();
    super.dispose();
  }

  void _bindScrollable() {
    final position = widget.closeOnScroll
        ? Scrollable.maybeOf(context)?.position
        : null;
    if (identical(_scrollPosition, position)) {
      return;
    }
    _unbindScrollable();
    _scrollPosition = position;
    _scrollPosition?.isScrollingNotifier.addListener(_handleScroll);
  }

  void _unbindScrollable() {
    _scrollPosition?.isScrollingNotifier.removeListener(_handleScroll);
    _scrollPosition = null;
  }

  void _handleScroll() {
    if (_scrollPosition?.isScrollingNotifier.value == true) {
      close();
    }
  }

  void _bindRoute() {
    final route = ModalRoute.of(context);
    if (identical(_route, route) &&
        _instancesByRoute[route]?.contains(this) == true) {
      return;
    }
    _unbindRoute();
    _route = route;
    _instancesByRoute.putIfAbsent(route, () => <_TSwipeCellState>{}).add(this);
  }

  void _unbindRoute() {
    final instances = _instancesByRoute[_route];
    instances?.remove(this);
    if (instances?.isEmpty == true) {
      _instancesByRoute.remove(_route);
    }
    _route = null;
  }

  void _schedulePanelMeasurement() {
    if (_measurementScheduled) {
      return;
    }
    _measurementScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measurementScheduled = false;
      if (mounted) {
        _refreshPanelExtents();
      }
    });
  }

  void _refreshPanelExtents() {
    final startExtent = _measureWidth(_startPanelKey);
    final endExtent = _measureWidth(_endPanelKey);
    if (startExtent == _startExtent && endExtent == _endExtent) {
      _reconcileOpenOffset();
      return;
    }
    setState(() {
      _startExtent = startExtent;
      _endExtent = endExtent;
    });
    _reconcileOpenOffset();
  }

  void _reconcileOpenOffset() {
    final side = _openSide;
    if (side == null) {
      return;
    }
    final target = side == TSwipeCellSide.start ? _startTarget : _endTarget;
    if (target == 0) {
      _setOpenSide(null);
      _offsetController.value = 0;
      return;
    }
    if (_offset != target) {
      _offsetController.value = target;
    }
  }

  double _measureWidth(GlobalKey key) {
    final renderObject = key.currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      return renderObject.size.width;
    }
    return 0;
  }

  @override
  Future<void> open(TSwipeCellSide side) async {
    _refreshPanelExtents();
    final target = side == TSwipeCellSide.start ? _startTarget : _endTarget;
    if (target == 0) {
      await close();
      return;
    }
    _closeOthers();
    _setOpenSide(side);
    await _animateTo(target);
  }

  @override
  Future<void> close() async {
    _setOpenSide(null);
    await _animateTo(0);
  }

  Future<void> _animateTo(double target) async {
    try {
      await _offsetController
          .animateTo(
            target,
            duration: _animationDuration,
            curve: _animationCurve,
          )
          .orCancel;
    } on TickerCanceled {
      // Widget 在动画过程中被移除时，控制器命令仍应正常结束。
    }
  }

  void _closeOthers() {
    final instances = _instancesByRoute[_route] ?? const <_TSwipeCellState>{};
    for (final instance in instances.toList(growable: false)) {
      if (!identical(instance, this) && instance.mounted) {
        instance.close();
      }
    }
  }

  void _setOpenSide(TSwipeCellSide? side) {
    if (_openSide == side) {
      return;
    }
    final previous = _openSide;
    _openSide = side;
    if (previous != null) {
      widget.onOpenChanged?.call(previous, false);
    }
    if (side != null) {
      widget.onOpenChanged?.call(side, true);
      _registerTapOutsideListener();
    } else {
      _unregisterTapOutsideListener();
    }
  }

  void _registerTapOutsideListener() {
    if (_tapOutsideRouteRegistered) {
      return;
    }
    WidgetsBinding.instance.pointerRouter.addGlobalRoute(_handlePointerDown);
    _tapOutsideRouteRegistered = true;
  }

  void _unregisterTapOutsideListener() {
    if (!_tapOutsideRouteRegistered) {
      return;
    }
    WidgetsBinding.instance.pointerRouter.removeGlobalRoute(_handlePointerDown);
    _tapOutsideRouteRegistered = false;
  }

  void _handlePointerDown(PointerEvent event) {
    if (event is! PointerDownEvent) {
      return;
    }
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return;
    }
    final local = renderObject.globalToLocal(event.position);
    if (!renderObject.size.contains(local)) {
      close();
    }
  }

  void _handleChildTap() {
    if (_openSide != null) {
      close();
    }
  }

  void _handleDragStart(DragStartDetails details) {
    _refreshPanelExtents();
    _closeOthers();
    _offsetController.stop();
    _dragStartOffset = _offset;
    _dragStartSide = _openSide;
    _dragCanceled = false;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final minOffset = math.min(0, math.min(_startTarget, _endTarget));
    final maxOffset = math.max(0, math.max(_startTarget, _endTarget));
    _offsetController.value = (_offset + details.primaryDelta!)
        .clamp(minOffset, maxOffset)
        .toDouble();
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dragCanceled) {
      _restoreDragStartState();
      return;
    }
    if (_wasOpenAtDragStart()) {
      close();
      return;
    }
    if (_startExtent > 0 && _offset * _startSign > 0) {
      if (_offset.abs() >= _startExtent * _openThreshold) {
        open(TSwipeCellSide.start);
      } else {
        close();
      }
      return;
    }
    if (_endExtent > 0 && _offset * _startSign < 0) {
      if (_offset.abs() >= _endExtent * _openThreshold) {
        open(TSwipeCellSide.end);
      } else {
        close();
      }
      return;
    }
    close();
  }

  void _handleDragCancel() {
    _restoreDragStartState();
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _dragCanceled = true;
  }

  void _restoreDragStartState() {
    _dragCanceled = false;
    final dragStartSide = _dragStartSide;
    if (dragStartSide == null) {
      unawaited(close());
    } else {
      unawaited(open(dragStartSide));
    }
  }

  bool _wasOpenAtDragStart() {
    const tolerance = 0.5;
    final moved = (_offset - _dragStartOffset).abs() >= tolerance;
    return moved &&
        ((_startExtent > 0 &&
                (_dragStartOffset - _startTarget).abs() < tolerance) ||
            (_endExtent > 0 &&
                (_dragStartOffset - _endTarget).abs() < tolerance));
  }

  @override
  Widget build(BuildContext context) {
    _schedulePanelMeasurement();
    final canDrag =
        widget.enabled && (widget.start != null || widget.end != null);
    return TSwipeCellInherited(
      close: close,
      child: Listener(
        onPointerCancel: _handlePointerCancel,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          dragStartBehavior: DragStartBehavior.start,
          onHorizontalDragStart: canDrag ? _handleDragStart : null,
          onHorizontalDragUpdate: canDrag ? _handleDragUpdate : null,
          onHorizontalDragEnd: canDrag ? _handleDragEnd : null,
          onHorizontalDragCancel: canDrag ? _handleDragCancel : null,
          child: AnimatedBuilder(
            animation: _offsetController,
            builder: (context, _) {
              return ClipRect(
                child: Stack(
                  children: [
                    if (widget.start != null)
                      PositionedDirectional(
                        top: 0,
                        bottom: 0,
                        start: 0,
                        child: Transform.translate(
                          offset: Offset(
                            _offset - _startSign * _startExtent,
                            0,
                          ),
                          child: KeyedSubtree(
                            key: _startPanelKey,
                            child: IgnorePointer(
                              ignoring: _openSide != TSwipeCellSide.start,
                              child: widget.start!.build(context),
                            ),
                          ),
                        ),
                      ),
                    if (widget.end != null)
                      PositionedDirectional(
                        top: 0,
                        bottom: 0,
                        end: 0,
                        child: Transform.translate(
                          offset: Offset(_offset + _startSign * _endExtent, 0),
                          child: KeyedSubtree(
                            key: _endPanelKey,
                            child: IgnorePointer(
                              ignoring: _openSide != TSwipeCellSide.end,
                              child: widget.end!.build(context),
                            ),
                          ),
                        ),
                      ),
                    Transform.translate(
                      offset: Offset(_offset, 0),
                      child: Stack(
                        children: [
                          IgnorePointer(
                            ignoring: _offset != 0,
                            child: widget.child,
                          ),
                          if (_offset != 0)
                            Positioned.fill(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: _handleChildTap,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
