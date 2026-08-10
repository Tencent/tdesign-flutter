import 'package:flutter/material.dart';

import 't_fab_defaults.dart';
import 't_fab_drag.dart';
import 't_fab_layout.dart';
import 't_fab_resolve.dart';
import 't_fab_theme_data.dart';

export 't_fab_layout.dart'
    show
        TFabDragAxis,
        TFabMagnet,
        TFabBounds,
        TFabDragDetails,
        TFabDragCallback;

/// 悬浮操作按钮组件
///
/// T2 组合模式：定位层（右下角悬浮 + 可选拖拽/吸附/边界）+ 动作层（默认内嵌 TButton）
///
/// 示例：
/// ```dart
/// // 纯图标悬浮按钮
/// Stack(fit: StackFit.expand, children: [
///   // 页面内容 ...
///   const TFab(),
/// ])
///
/// // 图标 + 文字
/// TFab(
///   text: '发布',
/// )
///
/// // 可拖拽悬浮按钮
/// TFab(
///   draggable: TFabDragAxis.all,
///   magnet: TFabMagnet.right,
/// )
/// ```
class TFab extends StatelessWidget {
  const TFab({
    super.key,
    this.text = '',
    this.icon,
    this.child,
    this.onPressed,
    this.onLongPress,
    this.tooltip,
    this.semanticLabel,
    this.right,
    this.bottom,
    this.draggable,
    this.magnet,
    this.xBounds,
    this.yBounds,
    this.onDragStart,
    this.onDragEnd,
    this.useSafeArea = true,
  });

  /// 图标 + 文字形态；非空时内嵌 TButton 为 round 形状
  final String text;

  /// 图标；未传时默认 [Icons.add]
  final Widget? icon;

  /// 自定义内容；有则替代默认内嵌 TButton
  final Widget? child;

  /// 点击回调，null 时禁用
  final VoidCallback? onPressed;

  /// 长按回调。
  ///
  /// 仅在 [onPressed] 非空时生效；当 [onPressed] 为空时按钮保持禁用态，
  /// 不会触发点击或长按回调。
  final VoidCallback? onLongPress;

  /// 纯图标 Fab 的 tooltip 提示
  final String? tooltip;

  /// 读屏标签
  final String? semanticLabel;

  /// 距屏幕右侧偏移（默认 16）
  final double? right;

  /// 距屏幕底部偏移（默认 32）
  final double? bottom;

  /// 拖拽轴向；null 表示不启用拖拽，[TFabDragAxis.all] 表示全向拖拽
  final TFabDragAxis? draggable;

  /// 拖拽结束吸附方向；null 表示不吸附
  final TFabMagnet? magnet;

  /// 水平拖拽边界限制
  final TFabBounds? xBounds;

  /// 垂直拖拽边界限制
  final TFabBounds? yBounds;

  /// 拖拽开始回调
  final TFabDragCallback? onDragStart;

  /// 拖拽结束回调
  final TFabDragCallback? onDragEnd;

  /// 是否避让系统安全区。
  ///
  /// 默认为 true。固定定位的 [right]、[bottom] 从安全边界起算；
  /// 拖拽与吸附范围同时避让四侧安全区。
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    // ---- resolve Theme ----
    final theme = Theme.of(context).extension<TFabThemeData>();
    final safePadding =
        useSafeArea ? MediaQuery.paddingOf(context) : EdgeInsets.zero;

    // ---- resolveLayout ----
    final layout = TFabResolve.resolveLayout(
      right: right,
      bottom: bottom,
      draggable: draggable,
      magnet: magnet,
      xBounds: xBounds,
      yBounds: yBounds,
      themeDefaultRight: theme?.defaultRight,
      themeDefaultBottom: theme?.defaultBottom,
      themeDefaultXBounds: theme?.defaultXBounds,
      themeDefaultYBounds: theme?.defaultYBounds,
      safePadding: safePadding,
    );

    final dragTapSlop = theme?.dragTapSlop ?? 18;
    final magnetDuration =
        theme?.magnetAnimationDuration ?? const Duration(milliseconds: 200);

    // ---- 构建动作层 ----
    final isChildMode = child != null;
    Widget actionChild;

    if (isChildMode) {
      actionChild = child!;
    } else {
      actionChild = TFabResolve.resolveButton(
        text: text,
        icon: icon,
        onPressed: onPressed,
        onLongPress: onLongPress,
        context: context,
      );
    }

    // 禁用时包 IgnorePointer（仅 child 模式，TButton 内部已处理禁用）
    if (isChildMode && onPressed == null) {
      actionChild = Semantics(
        enabled: false,
        child: Opacity(
          opacity: 0.4,
          child: IgnorePointer(child: actionChild),
        ),
      );
    }

    // Tooltip / Semantics
    if (tooltip != null && tooltip!.isNotEmpty) {
      actionChild = Tooltip(message: tooltip!, child: actionChild);
    }
    if (semanticLabel != null && semanticLabel!.isNotEmpty) {
      actionChild = Semantics(label: semanticLabel!, child: actionChild);
    }

    // ---- 定位层 ----
    return buildFabPositioned(
      layout: layout,
      child: actionChild,
      dragTapSlop: dragTapSlop,
      onPressed: isChildMode ? onPressed : null,
      // child 模式下长按由定位层手势接管；TButton 模式已在内部处理
      onLongPress: isChildMode ? onLongPress : null,
      onDragStart: onDragStart,
      onDragEnd: onDragEnd,
      magnetAnimationDuration: magnetDuration,
    );
  }
}
