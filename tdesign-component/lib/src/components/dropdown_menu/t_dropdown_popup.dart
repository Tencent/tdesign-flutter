import 'dart:async';

import 'package:flutter/material.dart';

import 't_dropdown_inherited.dart';
import 't_dropdown_item.dart';
import 't_dropdown_menu.dart';
import 't_dropdown_panel.dart';

typedef TDropdownPopupDirection = TDropdownMenuDirection;
typedef FutureCallback = Future<void> Function();

class TDropdownPopup {
  TDropdownPopup({
    required this.parentContext,
    required this.child,
    required this.handleClose,
    this.direction = TDropdownPopupDirection.auto,
    this.showOverlay = true,
    this.closeOnClickOverlay = true,
    this.duration = const Duration(milliseconds: 200),
  });

  final BuildContext parentContext;
  final TDropdownItem child;
  final FutureCallback handleClose;
  final TDropdownPopupDirection? direction;
  final bool? showOverlay;
  final bool? closeOnClickOverlay;
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

  double get maxContentHeight => direction == TDropdownPopupDirection.down
      ? _initContentBottom
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

  Future<void> add([TDropdownItem? updateChild]) {
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

  Widget _getPopup(TDropdownMenuDirection value, TDropdownItem? updateChild,
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
      TDropdownInherited(
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
          onOpened: () {
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
                return AnimatedContainer(
                  color: value ? Colors.black54 : Colors.black54.withAlpha(0),
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
        onVerticalDragUpdate: (details) {},
        onHorizontalDragUpdate: (details) {},
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

  void _overlayClick() {
    if (!(closeOnClickOverlay ?? true)) {
      return;
    }
    Navigator.maybePop(parentContext);
  }

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
    await handleClose();
    return super.willPop();
  }
}
