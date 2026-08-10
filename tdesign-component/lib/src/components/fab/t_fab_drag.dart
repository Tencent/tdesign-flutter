import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderStack;

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
  VoidCallback? onLongPress,
  TFabDragCallback? onDragStart,
  TFabDragCallback? onDragEnd,
  Duration? magnetAnimationDuration,
}) {
  if (layout.draggable == null) {
    var positionedChild = child;
    if (onPressed != null || onLongPress != null) {
      positionedChild = GestureDetector(
        onTap: onPressed,
        onLongPress: onLongPress,
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
    onLongPress: onLongPress,
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
    this.onLongPress,
    this.onDragStart,
    this.onDragEnd,
    this.magnetAnimationDuration,
  });

  final TFabLayout layout;
  final Widget child;
  final double dragTapSlop;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final TFabDragCallback? onDragStart;
  final TFabDragCallback? onDragEnd;
  final Duration? magnetAnimationDuration;

  @override
  State<_FabDraggable> createState() => _FabDraggableState();
}

class _FabDraggableState extends State<_FabDraggable> {
  final GlobalKey _childKey = GlobalKey();
  late double _right;
  late double _bottom;
  double _totalDisplacement = 0;

  @override
  void initState() {
    super.initState();
    _right = widget.layout.right;
    _bottom = widget.layout.bottom;
  }

  @override
  void didUpdateWidget(covariant _FabDraggable oldWidget) {
    super.didUpdateWidget(oldWidget);
    final positionChanged =
        oldWidget.layout.right != widget.layout.right ||
        oldWidget.layout.bottom != widget.layout.bottom;
    if (positionChanged) {
      _right = _clampSafe(widget.layout.right, _minX(), _maxX());
      _bottom = _clampSafe(widget.layout.bottom, _minY(), _maxY());
      return;
    }
    _right = _clampSafe(_right, _minX(), _maxX());
    _bottom = _clampSafe(_bottom, _minY(), _maxY());
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
        onLongPress: widget.onLongPress,
        child: KeyedSubtree(key: _childKey, child: widget.child),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    _totalDisplacement = 0;
    widget.onDragStart?.call(
      TFabDragDetails(position: Offset(_right, _bottom), start: details),
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final delta = details.delta;
    _totalDisplacement += delta.distance;

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
    final isDrag = _totalDisplacement > widget.dragTapSlop;

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
        widget.magnetAnimationDuration ?? const Duration(milliseconds: 200);

    // 简易吸附：直接用 setState（未来可升级为 AnimationController）
    Future.delayed(duration, () {
      if (mounted) {
        setState(() {
          _right = targetRight;
        });
      }
    });
  }

  double _minX() {
    final bounds = widget.layout.xBounds;
    return (bounds?.start ?? 16) + widget.layout.safePadding.right;
  }

  static double _clampSafe(double value, double min, double max) {
    return max <= min ? min : value.clamp(min, max);
  }

  double _maxX() {
    final width = _stackSize().width;
    final bounds = widget.layout.xBounds;
    final fabWidth = _fabSize().width;
    return width -
        (bounds?.end ?? 16) -
        fabWidth -
        widget.layout.safePadding.left;
  }

  double _minY() {
    final bounds = widget.layout.yBounds;
    return (bounds?.start ?? 0) + widget.layout.safePadding.bottom;
  }

  double _maxY() {
    final height = _stackSize().height;
    final bounds = widget.layout.yBounds;
    final fabHeight = _fabSize().height;
    return height -
        (bounds?.end ?? 0) -
        fabHeight -
        widget.layout.safePadding.top;
  }

  Size _fabSize() {
    final renderObject = _childKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      return renderObject.size;
    }
    return const Size(48, 48);
  }
}
