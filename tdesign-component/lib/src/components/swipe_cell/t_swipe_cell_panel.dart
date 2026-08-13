import 'package:flutter/material.dart';

import './t_swipe_cell.dart';
import 't_swipe_cell_action.dart';

/// 滑动动画展示方式
enum SwipeMotion {
  /// 滚动
  scroll,

  /// 揭开
  behind,

  /// 抽屉
  drawer,

  /// 拉伸
  stretch,
}

/// 滑动单元格操作面板组件
class TSwipeCellPanel {
  const TSwipeCellPanel({
    this.extentRatio = 0.3,
    this.openThreshold,
    this.closeThreshold,
    this.motionType,
    this.dragDismissible = false,
    this.dismissThreshold = 0.75,
    this.dismissalDuration = const Duration(milliseconds: 300),
    this.resizeDuration = const Duration(milliseconds: 300),
    this.closeOnCancel = false,
    this.confirmDismiss,
    this.onDismissed,
    required this.children,
    this.confirms,
  })  : assert(extentRatio > 0 && extentRatio <= 1,
            'extentRatio must be in (0, 1].'),
        assert(
          confirms == null ||
              confirms.every((item) =>
                  item.confirmIndex != null &&
                  item.confirmIndex!
                      .every((index) => index >= 0 && index < children.length)),
          'Confirms must have a confirmIndex, '
          'and each confirmIndex in confirms must be within the range of children indices.',
        );

  /// 宽度占比
  final double extentRatio;

  /// 拖动多少占比触发打开动作，默认 [extentRatio] 的一半
  final double? openThreshold;

  /// 拖动多少占比触发关闭动作，默认 [extentRatio] 的一半
  final double? closeThreshold;

  /// 滑动动画展示方式
  final SwipeMotion? motionType;

  /// 操作组件列表
  final List<TSwipeCellAction> children;

  /// 二次确认操作组件列表
  ///
  /// 通过 [TSwipeCellAction.confirmIndex] 与 [children] 中的索引关联。
  /// 点击 [children] 中某操作项后，若命中某个 confirm 的索引则展示二次确认。
  /// **点击的 action 需与 [children] 中为同一实例**；
  /// 若使用 `copyWith` 等重建等价实例，请为两者设置相同的
  /// [TSwipeCellAction.id]，按标识而非引用匹配。
  final List<TSwipeCellAction>? confirms;

  /// 是否可通过拖动操作来移除 [TSwipeCell] 组件
  final bool dragDismissible;

  /// 滑动到多少比例时，触发移除。dragDismissible为true才有效
  final double dismissThreshold;

  /// 触发移除的滑动动画时长。dragDismissible为true才有效
  final Duration dismissalDuration;

  /// 移除动画（高度变为0）时长。dragDismissible为true才有效
  final Duration resizeDuration;

  /// 移除取消后，是否关闭滑动单元格。dragDismissible为true才有效
  final bool closeOnCancel;

  /// 移除前回调，可阻止移除。dragDismissible为true才有效
  final Future<bool> Function(BuildContext context)? confirmDismiss;

  /// 移除后回调。dragDismissible为true才有效
  final void Function(BuildContext context)? onDismissed;

  ActionPane build(BuildContext context) {
    return ActionPane(
      extentRatio: extentRatio,
      motion: getMotionWidget(),
      openThreshold: openThreshold ?? (extentRatio / 2),
      closeThreshold: closeThreshold ?? (extentRatio / 2),
      children: children,
      dragDismissible: dragDismissible,
      dismissible: dragDismissible
          ? DismissiblePane(
              closeOnCancel: closeOnCancel,
              dismissThreshold: dismissThreshold,
              dismissalDuration: dismissalDuration,
              resizeDuration: resizeDuration,
              confirmDismiss: () async {
                // coverage:ignore-line
                if (confirmDismiss != null) {
                  // coverage:ignore-line
                  return confirmDismiss!(context); // coverage:ignore-line
                }
                return true;
              },
              onDismissed: () async {
                // coverage:ignore-line
                await TSwipeCell.of(context)?.close(); // coverage:ignore-line
                onDismissed?.call(context); // coverage:ignore-line
              },
            )
          : null,
    );
  }

  /// 获取滑动动画对应的 Motion 组件
  Widget getMotionWidget() {
    switch (motionType) {
      case SwipeMotion.scroll:
        return const ScrollMotion();
      case SwipeMotion.behind:
        return const BehindMotion();
      case SwipeMotion.drawer:
        return const DrawerMotion();
      case SwipeMotion.stretch:
        return const StretchMotion();
      default:
        return const ScrollMotion();
    }
  }
}
