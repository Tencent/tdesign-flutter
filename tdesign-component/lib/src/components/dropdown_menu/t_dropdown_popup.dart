import 'dart:async';

import 'package:flutter/material.dart';

import 't_dropdown_inherited.dart';
import 't_dropdown_item.dart';
import 't_dropdown_menu.dart';
import 't_dropdown_panel.dart';

/// 下拉弹出方向（别名 [TDropdownMenuDirection]）
typedef TDropdownPopupDirection = TDropdownMenuDirection;

/// 异步回调类型
typedef FutureCallback = Future<void> Function();

/// 下拉菜单弹出层管理器
///
/// 负责管理 Overlay 层的创建、方向计算和遮罩渲染。
class TDropdownPopup<T> {
  TDropdownPopup({
    required this.parentContext,
    required this.child,
    required this.handleClose,
    this.direction = TDropdownPopupDirection.auto,
    this.showOverlay = true,
    this.overlayColor,
    this.closeOnClickOverlay = true,
    this.duration = const Duration(milliseconds: 200),
  });

  /// 父级上下文（用于定位）
  final BuildContext parentContext;

  /// 下拉内容
  final TDropdownItem<T> child;

  /// 关闭回调
  final FutureCallback handleClose;

  /// 展开方向
  final TDropdownPopupDirection? direction;

  /// 是否显示遮罩
  final bool? showOverlay;

  /// 遮罩颜色
  final Color? overlayColor;

  /// 点击遮罩是否关闭
  final bool? closeOnClickOverlay;

  /// 动画时长
  final Duration? duration;

  /// _overlay1：下拉方向的
  late double _overlay1Top,
      _overlay1Bottom,

      /// _overlay2：menu部分的
      _overlay2Top,
      _overlay2Bottom,

      /// _overlay3：下拉反方向的
      _overlay3Top,
      _overlay3Bottom,

      /// _overlay3Height：下拉反方向的高度，用于判断auto方向
      _overlay3Height,

      /// _initContent：初始内容
      _initContentTop,
      _initContentBottom;
  final _closeListenable = ValueNotifier<FutureCallback?>(null);
  final _directionListenable =
      ValueNotifier<TDropdownPopupDirection>(TDropdownPopupDirection.auto);
  final _colorAlphaListenable = ValueNotifier(false);

  Duration get _duration => duration ?? const Duration(milliseconds: 200);

  /// 最大内容高度
  double get maxContentHeight => direction == TDropdownPopupDirection.down
      ? _initContentBottom // coverage:ignore-line
      : _initContentTop;

  void _init(TDropdownPopupDirection d) {
    final ancestor = Navigator.of(parentContext).context.findRenderObject();
    final popupContainerHeight = (ancestor as RenderBox).size.height;
    var renderBox = parentContext.findRenderObject() as RenderBox;
    var position = renderBox.localToGlobal(Offset.zero, ancestor: ancestor);
    var size = renderBox.size;
    if (d == TDropdownPopupDirection.down) {
      _overlay1Top = position.dy + size.height;
      _overlay2Top = position.dy;
      _overlay3Top = 0;
      _initContentTop = position.dy + size.height;

      _overlay1Bottom = 0;
      _overlay2Bottom = popupContainerHeight - position.dy - size.height;
      _overlay3Bottom = popupContainerHeight - position.dy;

      _overlay3Height = position.dy;
      _initContentBottom = popupContainerHeight - position.dy - size.height;
    } else {
      _overlay1Top = 0;
      _overlay2Top = position.dy;
      _overlay3Top = position.dy + size.height;
      _initContentTop = position.dy;

      _overlay1Bottom = popupContainerHeight - position.dy;
      _overlay2Bottom = popupContainerHeight - position.dy - size.height;
      _overlay3Bottom = 0;

      _overlay3Height = popupContainerHeight - position.dy - size.height;
      _initContentBottom = popupContainerHeight - position.dy;
    }
  }

  /// 添加并显示弹出层
  Future<void> add([TDropdownItem<T>? updateChild]) {
    var completer = Completer<void>();
    _directionListenable.value = direction ?? TDropdownPopupDirection.auto;
    final overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return _directionListenable.value == TDropdownPopupDirection.auto
            ? ValueListenableBuilder(
                valueListenable: _directionListenable,
                builder: (context, value, child) =>
                    value == TDropdownPopupDirection.auto
                        ? child!
                        : _getPopup(
                            value, updateChild, completer), // 每次重新渲染item，更新高度
                child: _getPopup(
                    TDropdownPopupDirection.down, updateChild, completer),
              )
            : _getPopup(_directionListenable.value, updateChild, completer);
      },
    );
    Navigator.push(
        parentContext, _PopupOverlayRoute(overlayEntry, handleClose));
    return completer.future;
  }

  Widget _getPopup(TDropdownMenuDirection value, TDropdownItem<T>? updateChild,
      Completer<void> completer) {
    _init(value);
    final barrier = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _overlayClick,
    );
    return Stack(children: [
      if (_directionListenable.value != TDropdownPopupDirection.auto) ...[
        _getOverlay1(barrier),
        _getOverlay2(),
        _getOverlay3(barrier),
      ],
      TDropdownInherited<T>(
        popupState: this,
        directionListenable: _directionListenable,
        child: TDropdownPanel(
          duration: _duration,
          direction: value,
          directionListenable: _directionListenable,
          colorAlphaListenable: _colorAlphaListenable,
          initContentBottom: _initContentBottom,
          initContentTop: _initContentTop,
          reverseHeight: _overlay3Height,
          closeListenable: _closeListenable,
          onOpened: () { // coverage:ignore-line
            completer.complete();
          },
          child: updateChild ?? child,
        ),
      ),
    ]);
  }

  Widget _getOverlay1(Widget barrier) {
    return Positioned(
      top: _overlay1Top,
      bottom: _overlay1Bottom,
      left: 0,
      right: 0,
      child: showOverlay == true
          ? ValueListenableBuilder(
              builder: (BuildContext context, value, Widget? child) {
                final color = overlayColor ?? Colors.black54;
                return AnimatedContainer(
                  color: value ? color : color.withAlpha(0),
                  duration: value ? _duration : _duration ~/ 2,
                  child: barrier,
                );
              },
              valueListenable: _colorAlphaListenable,
            )
          : barrier,
    );
  }

  Widget _getOverlay2() {
    return Positioned(
      top: _overlay2Top,
      bottom: _overlay2Bottom,
      left: 0,
      right: 0,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {}, // coverage:ignore-line
        onHorizontalDragUpdate: (details) {}, // coverage:ignore-line
        behavior: HitTestBehavior.translucent,
      ),
    );
  }

  Widget _getOverlay3(Widget barrier) {
    return Positioned(
      top: _overlay3Top,
      bottom: _overlay3Bottom,
      left: 0,
      right: 0,
      child: barrier,
    );
  }

  void _overlayClick() { // coverage:ignore-line
    if (!(closeOnClickOverlay ?? true)) { // coverage:ignore-line
      return;
    }
    Navigator.maybePop(parentContext); // coverage:ignore-line
  }

  /// 移除并关闭弹出层
  Future<void> remove() async {
    await _closeListenable.value?.call();
    _closeListenable.value = null;
  }
}

class _PopupOverlayRoute<T> extends OverlayRoute<T> {
  final OverlayEntry overlayEntry;
  final FutureCallback handleClose;

  _PopupOverlayRoute(this.overlayEntry, this.handleClose);

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [overlayEntry];
  }

  @override
  Future<RoutePopDisposition> willPop() async {
    unawaited(handleClose());
    return RoutePopDisposition.pop;
  }
}
