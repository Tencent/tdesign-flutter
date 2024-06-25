import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_slidable/src/dismissible_pane.dart' as dismissible_pane;

import './td_swipe_action.dart';
import './td_swipe_cell.dart';

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
class TDSwipePanel {
  TDSwipePanel({
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
  }) : assert(
          confirms == null ||
              confirms.every((item) =>
                  item.confirmIndex != null &&
                  item.confirmIndex!.every((index) => index >= 0 && index < children.length)),
          'Confirms must have a confirmIndex, '
          'and each confirmIndex in confirms must be within the range of children indices.',
        );

  /// 宽度占比
  final double? extentRatio;

  /// 拖动多少占比触发打开动作，默认 [extentRatio] 的一半
  final double? openThreshold;

  /// 拖动多少占比触发关闭动作，默认 [extentRatio] 的一半
  final double? closeThreshold;

  /// 滑动动画展示方式
  final SwipeMotion? motionType;

  /// 操作组件列表
  final List<TDSwipeAction> children;

  /// 二次确认操作组件列表
  final List<TDSwipeAction>? confirms;

  /// 是否可通过拖动操作来移除 [TDSwipeCell] 组件
  final bool? dragDismissible;

  /// 滑动到多少比例时，触发移除。dragDismissible为true才有效
  final double? dismissThreshold;

  /// 触发移除的滑动动画时长。dragDismissible为true才有效
  final Duration? dismissalDuration;

  /// 移除动画（高度变为0）时长。dragDismissible为true才有效
  final Duration? resizeDuration;

  /// 移除取消后，是否关闭滑动单元格。dragDismissible为true才有效
  final bool? closeOnCancel;

  /// 移除前回调，可阻止移除。dragDismissible为true才有效
  final dismissible_pane.ConfirmDismissCallback? confirmDismiss;

  /// 移除后回调。dragDismissible为true才有效
  final VoidCallback? onDismissed;

  Duration get _dismissalDuration => dismissalDuration ?? const Duration(milliseconds: 300);

  Duration get _resizeDuration => resizeDuration ?? const Duration(milliseconds: 300);

  bool get _dragDismissible => dragDismissible ?? false;

  double get _extentRatio => extentRatio ?? 0.3;

  double get _openThreshold => openThreshold ?? (_extentRatio / 2);

  double get _closeThreshold => closeThreshold ?? (_extentRatio / 2);

  ActionPane build(BuildContext context) {
    return ActionPane(
      extentRatio: _extentRatio,
      motion: getMotionWidget(),
      openThreshold: _openThreshold,
      closeThreshold: _closeThreshold,
      children: children,
      dragDismissible: _dragDismissible,
      dismissible: _dragDismissible
          ? DismissiblePane(
              closeOnCancel: closeOnCancel ?? false,
              dismissThreshold: dismissThreshold ?? 0.75,
              dismissalDuration: _dismissalDuration,
              resizeDuration: _resizeDuration,
              confirmDismiss: confirmDismiss,
              onDismissed: onDismissed ?? () {},
            )
          : null,
    );
  }

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
