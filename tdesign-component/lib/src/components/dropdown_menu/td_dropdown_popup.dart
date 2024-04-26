import 'dart:async';

import 'package:flutter/material.dart';

import 'td_dropdown_inherited.dart';
import 'td_dropdown_item.dart';
import 'td_dropdown_menu.dart';
import 'td_dropdown_panel.dart';

typedef TDDropdownPopupDirection = TDDropdownMenuDirection;
typedef FutureCallback = Future<void> Function();

class TDDropdownPopup {
  TDDropdownPopup({
    required this.parentContext,
    required this.child,
    this.handleClose,
    this.direction = TDDropdownPopupDirection.auto,
    this.showOverlay = true,
    this.closeOnClickOverlay = true,
    this.duration = const Duration(milliseconds: 200),
  });

  final BuildContext parentContext;
  final TDDropdownItem child;
  final FutureCallback? handleClose;
  final TDDropdownPopupDirection? direction;
  final bool? showOverlay;
  final bool? closeOnClickOverlay;
  final Duration? duration;

  /// _overlay1：下拉方向的
  /// _overlay2：menu部分的
  /// _overlay3：下拉反方向的
  /// _overlay3Height：下拉反方向的高度，用于判断auto方向
  /// _initContent：初始内容
  late double _overlay1Top,
      _overlay1Bottom,
      _overlay2Top,
      _overlay2Bottom,
      _overlay3Top,
      _overlay3Bottom,
      _overlay3Height,
      _initContentTop,
      _initContentBottom;
  late VoidCallback _closeContent;
  final directionListenable = ValueNotifier<TDDropdownPopupDirection>(TDDropdownPopupDirection.auto);

  OverlayEntry? overlayEntry;

  Duration get _duration => duration ?? const Duration(milliseconds: 200);

  double get maxContentHeight => direction == TDDropdownPopupDirection.down ? _initContentBottom : _initContentTop;

  void _init(TDDropdownPopupDirection d) {
    var renderBox = parentContext.findRenderObject() as RenderBox;
    var position = renderBox.localToGlobal(Offset.zero);
    var size = renderBox.size;
    var screenHeight = MediaQuery.of(parentContext).size.height;
    if (d == TDDropdownPopupDirection.down) {
      _overlay1Top = position.dy + size.height;
      _overlay2Top = position.dy;
      _overlay3Top = 0;
      _initContentTop = position.dy + size.height;

      _overlay1Bottom = 0;
      _overlay2Bottom = screenHeight - position.dy - size.height;
      _overlay3Bottom = screenHeight - position.dy;

      _overlay3Height = position.dy;
      _initContentBottom = screenHeight - position.dy - size.height;
    } else {
      _overlay1Top = 0;
      _overlay2Top = position.dy;
      _overlay3Top = position.dy + size.height;
      _initContentTop = position.dy;

      _overlay1Bottom = screenHeight - position.dy;
      _overlay2Bottom = screenHeight - position.dy - size.height;
      _overlay3Bottom = 0;

      _overlay3Height = screenHeight - position.dy - size.height;
      _initContentBottom = screenHeight - position.dy;
    }
  }

  Future<void> add([TDDropdownItem? updateChild]) async {
    directionListenable.value = direction ?? TDDropdownPopupDirection.auto;
    overlayEntry?.remove();
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return directionListenable.value == TDDropdownPopupDirection.auto
            ? ValueListenableBuilder(
                valueListenable: directionListenable,
                builder: (context, value, child) => value == TDDropdownPopupDirection.auto
                    ? child!
                    : _getPopup(value, updateChild), // 每次重新渲染item，更新高度
                child: _getPopup(TDDropdownPopupDirection.down, updateChild),
              )
            : _getPopup(directionListenable.value, updateChild);
      },
    );

    Overlay.of(parentContext).insert(overlayEntry!);
    await Future.delayed(_duration);
  }

  Widget _getPopup(TDDropdownMenuDirection value, TDDropdownItem? updateChild) {
    _init(value);
    return Stack(children: [
      _getOverlay1(),
      _getOverlay2(),
      _getOverlay3(),
      TDDropdownInherited(
          popupState: this,
          directionListenable: directionListenable,
          child: TDDropdownPanel(
            duration: _duration,
            direction: value,
            directionListenable: directionListenable,
            initContentBottom: _initContentBottom,
            initContentTop: _initContentTop,
            reverseHeight: _overlay3Height,
            closeCallback: _closeCallback,
            child: updateChild ?? child,
          )),
    ]);
  }

  Widget _getOverlay1() {
    return showOverlay == true
        ? Positioned(
            top: _overlay1Top,
            bottom: _overlay1Bottom,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _overlayClick,
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _getOverlay2() {
    return showOverlay == true
        ? Positioned(
            top: _overlay2Top,
            bottom: _overlay2Bottom,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {},
              onHorizontalDragUpdate: (details) {},
              behavior: HitTestBehavior.translucent,
              child: const SizedBox(),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _getOverlay3() {
    return showOverlay == true
        ? Positioned(
            top: _overlay3Top,
            bottom: _overlay3Bottom,
            left: 0,
            right: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _overlayClick,
            ),
          )
        : const SizedBox.shrink();
  }

  void _overlayClick() {
    if (!(closeOnClickOverlay ?? true)) {
      return;
    }
    if (handleClose != null) {
      handleClose!();
    } else {
      remove();
    }
  }

  Future<void> remove() async {
    _closeContent();
    await Future.delayed(Duration(milliseconds: _duration.inMilliseconds ~/ 2));
    overlayEntry?.remove();
    overlayEntry = null;
  }

  _closeCallback(VoidCallback fn) {
    _closeContent = fn;
  }
}
