import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderStack;

import 't_fab_defaults.dart';
import 't_fab_layout.dart';

/// 构建 Fab 定位包装器
///
/// 非拖拽模式：返回固定 [Positioned]
/// 拖拽模式：返回 [Positioned] 内嵌 [_FabDraggable] 追踪位移
Widget buildFabPositioned({
  required TFabLayout layout,
  required Widget child,
  required double dragTapSlop,
  required VoidCallback? onPressed,
  required bool wrapFixedTap,
  TFabDragCallback? onDragStart,
  TFabDragCallback? onDragEnd,
  Duration? magnetAnimationDuration,
}) {
  if (layout.draggable == null) {
    var positionedChild = child;
    if (wrapFixedTap && onPressed != null) {
      positionedChild = GestureDetector(
        onTap: onPressed,
        child: positionedChild,
      );
    }
    return Positioned(
      right: layout.right,
      bottom: layout.bottom,
      child: positionedChild,
    );
  }
  return _FabDraggable(
    layout: layout,
    child: child,
    dragTapSlop: dragTapSlop,
    onPressed: onPressed,
    onDragStart: onDragStart,
    onDragEnd: onDragEnd,
    magnetAnimationDuration: magnetAnimationDuration,
  );
}

/// 拖拽状态组件（内部）
class _FabDraggable extends StatefulWidget {
  const _FabDraggable({
    required this.layout,
    required this.child,
    required this.dragTapSlop,
    this.onPressed,
    this.onDragStart,
    this.onDragEnd,
    this.magnetAnimationDuration,
  });

  final TFabLayout layout;
  final Widget child;
  final double dragTapSlop;
  final VoidCallback? onPressed;
  final TFabDragCallback? onDragStart;
  final TFabDragCallback? onDragEnd;
  final Duration? magnetAnimationDuration;

  @override
  State<_FabDraggable> createState() => _FabDraggableState();
}

class _FabDraggableState extends State<_FabDraggable>
    with SingleTickerProviderStateMixin {
  final GlobalKey _childKey = GlobalKey();
  late double _right;
  late double _bottom;
  double _maxDisplacement = 0;
  Offset? _dragOrigin;
  late final AnimationController _snapController;
  Animation<double>? _snapAnimation;

  @override
  void initState() {
    super.initState();
    _right = widget.layout.right;
    _bottom = widget.layout.bottom;
    _snapController = AnimationController(
      vsync: this,
      duration:
          widget.magnetAnimationDuration ??
          TFabDefaults.defaultMagnetAnimationDuration,
    );
    _snapController
      ..addListener(_handleSnapTick)
      ..addStatusListener(_handleSnapStatus);
  }

  @override
  void didUpdateWidget(covariant _FabDraggable oldWidget) {
    super.didUpdateWidget(oldWidget);
    _snapController.duration =
        widget.magnetAnimationDuration ??
        TFabDefaults.defaultMagnetAnimationDuration;
    final positionChanged =
        oldWidget.layout.right != widget.layout.right ||
        oldWidget.layout.bottom != widget.layout.bottom;
    final boundsChanged =
        !_sameBounds(oldWidget.layout.xBounds, widget.layout.xBounds) ||
        !_sameBounds(oldWidget.layout.yBounds, widget.layout.yBounds) ||
        oldWidget.layout.safePadding != widget.layout.safePadding;
    final interactionChanged =
        oldWidget.layout.draggable != widget.layout.draggable ||
        oldWidget.layout.magnet != widget.layout.magnet ||
        oldWidget.magnetAnimationDuration != widget.magnetAnimationDuration;
    if (positionChanged || boundsChanged || interactionChanged) {
      _stopSnap();
    }
    if (positionChanged) {
      _right = _clampSafe(widget.layout.right, _minX(), _maxX());
      _bottom = _clampSafe(widget.layout.bottom, _minY(), _maxY());
      return;
    }
    _right = _clampSafe(_right, _minX(), _maxX());
    _bottom = _clampSafe(_bottom, _minY(), _maxY());
  }

  @override
  void dispose() {
    _snapController.removeStatusListener(_handleSnapStatus);
    _snapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: _right,
      bottom: _bottom,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: KeyedSubtree(key: _childKey, child: widget.child),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    _stopSnap();
    _maxDisplacement = 0;
    _dragOrigin = details.globalPosition;
    widget.onDragStart?.call(
      TFabDragDetails(position: Offset(_right, _bottom), start: details),
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final delta = details.delta;
    final displacement =
        (details.globalPosition - (_dragOrigin ?? details.globalPosition))
            .distance;
    if (displacement > _maxDisplacement) {
      _maxDisplacement = displacement;
    }

    final axis = widget.layout.draggable;

    setState(() {
      if (axis != TFabDragAxis.vertical) {
        _right = _clampSafe(_right - delta.dx, _minX(), _maxX());
      }
      if (axis != TFabDragAxis.horizontal) {
        _bottom = _clampSafe(_bottom - delta.dy, _minY(), _maxY());
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final isDrag = _maxDisplacement > widget.dragTapSlop;
    _dragOrigin = null;

    if (isDrag) {
      // 拖拽结束 — 可能触发吸附
      if (widget.layout.magnet != null) {
        _snapToEdge();
      }
      widget.onDragEnd?.call(
        TFabDragDetails(position: Offset(_right, _bottom), end: details),
      );
    } else {
      // 点击
      widget.onPressed?.call();
    }
  }

  /// 获取父级 Stack 的尺寸；获取失败时回退到屏幕尺寸
  Size _stackSize() {
    final stack = context.findAncestorRenderObjectOfType<RenderStack>();
    if (stack != null && stack.hasSize) {
      return stack.size;
    }
    final mq = MediaQuery.of(context);
    return mq.size;
  }

  void _snapToEdge() {
    final magnet = widget.layout.magnet;

    final targetRight = switch (magnet) {
      TFabMagnet.left => _maxX(),
      TFabMagnet.right || null => _minX(),
    };

    final duration =
        widget.magnetAnimationDuration ??
        TFabDefaults.defaultMagnetAnimationDuration;
    _stopSnap();
    if (duration == Duration.zero || _right == targetRight) {
      setState(() => _right = targetRight);
      return;
    }
    _snapController.duration = duration;
    _snapAnimation = Tween<double>(begin: _right, end: targetRight).animate(
      CurvedAnimation(parent: _snapController, curve: Curves.easeOutCubic),
    );
    _snapController.forward(from: 0);
  }

  double _minX() {
    final bounds = widget.layout.xBounds;
    return (bounds?.end ?? TFabDefaults.defaultHorizontalBoundary) +
        widget.layout.safePadding.right;
  }

  static double _clampSafe(double value, double min, double max) {
    return max <= min ? min : value.clamp(min, max);
  }

  double _maxX() {
    final width = _stackSize().width;
    final bounds = widget.layout.xBounds;
    final fabWidth = _fabSize().width;
    return width -
        (bounds?.start ?? TFabDefaults.defaultHorizontalBoundary) -
        fabWidth -
        widget.layout.safePadding.left;
  }

  double _minY() {
    final bounds = widget.layout.yBounds;
    return (bounds?.end ?? TFabDefaults.defaultVerticalBoundary) +
        widget.layout.safePadding.bottom;
  }

  double _maxY() {
    final height = _stackSize().height;
    final bounds = widget.layout.yBounds;
    final fabHeight = _fabSize().height;
    return height -
        (bounds?.start ?? TFabDefaults.defaultVerticalBoundary) -
        fabHeight -
        widget.layout.safePadding.top;
  }

  void _handleSnapTick() {
    final animation = _snapAnimation;
    if (animation == null || !mounted) {
      return;
    }
    setState(() => _right = animation.value);
  }

  void _handleSnapStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _snapAnimation = null;
    }
  }

  void _stopSnap() {
    _snapController.stop();
    _snapAnimation = null;
  }

  static bool _sameBounds(TFabBounds? a, TFabBounds? b) {
    return a?.start == b?.start && a?.end == b?.end;
  }

  Size _fabSize() {
    final renderObject = _childKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      return renderObject.size;
    }
    return const Size.square(TFabDefaults.defaultActionExtent);
  }
}
