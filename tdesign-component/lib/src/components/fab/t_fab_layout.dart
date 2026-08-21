import 'package:flutter/material.dart';

/// 拖拽轴向
enum TFabDragAxis {
  /// 允许水平和垂直方向拖拽
  all,

  /// 仅允许垂直方向拖拽
  vertical,

  /// 仅允许水平方向拖拽
  horizontal,
}

/// 吸附方向
enum TFabMagnet {
  /// 拖拽结束后吸附到左侧边界
  left,

  /// 拖拽结束后吸附到右侧边界
  right,
}

/// 拖拽边界限制
class TFabBounds {
  /// 起点留白（水平：left，垂直：top）。
  final double start;

  /// 终点留白（水平：right，垂直：bottom）。
  final double end;

  const TFabBounds({required this.start, required this.end})
    : assert(start >= 0 && start < double.infinity),
      assert(end >= 0 && end < double.infinity);
}

/// 拖拽回调详情
class TFabDragDetails {
  /// 当前定位偏移，`dx` 为 right，`dy` 为 bottom。
  final Offset position;

  /// 拖拽开始详情
  final DragStartDetails? start;

  /// 拖拽结束详情
  final DragEndDetails? end;

  const TFabDragDetails({required this.position, this.start, this.end});
}

/// 拖拽回调
typedef TFabDragCallback = void Function(TFabDragDetails details);

/// Fab 定位层内部模型
///
/// 由构造器扁平参数经 resolveLayout 组装，内部使用，不 export。
class TFabLayout {
  final double right;
  final double bottom;
  final TFabDragAxis? draggable; // null = false
  final TFabMagnet? magnet; // null = false
  final TFabBounds? xBounds;
  final TFabBounds? yBounds;
  final EdgeInsets safePadding;

  const TFabLayout({
    required this.right,
    required this.bottom,
    this.draggable,
    this.magnet,
    this.xBounds,
    this.yBounds,
    this.safePadding = EdgeInsets.zero,
  });
}
