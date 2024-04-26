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
    this.direction = TDDropdownPopupDirection.down,
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
  late double _overlay1Top,
      _overlay1Bottom,
      _overlay2Top,
      _overlay2Bottom,
      _overlay3Top,
      _overlay3Bottom,
      _initContentTop,
      _initContentBottom;
  late VoidCallback _closeContent;

  OverlayEntry? overlayEntry;

  Duration get _duration => duration ?? const Duration(milliseconds: 200);

  double get maxContentHeight => direction == TDDropdownPopupDirection.down ? _initContentBottom : _initContentTop;

  void _init() {
    var renderBox = parentContext.findRenderObject() as RenderBox;
    var position = renderBox.localToGlobal(Offset.zero);
    var size = renderBox.size;
    var screenHeight = MediaQuery.of(parentContext).size.height;
    var isDown = direction == TDDropdownPopupDirection.down;
    if (isDown) {
      _overlay1Top = position.dy + size.height;
      _overlay2Top = position.dy;
      _overlay3Top = 0;
      _initContentTop = position.dy + size.height;

      _overlay1Bottom = 0;
      _overlay2Bottom = screenHeight - position.dy - size.height;
      _overlay3Bottom = screenHeight - position.dy;
      _initContentBottom = screenHeight - position.dy - size.height;
    } else {
      _overlay1Top = 0;
      _overlay2Top = position.dy;
      _overlay3Top = position.dy + size.height;
      _initContentTop = position.dy;

      _overlay1Bottom = screenHeight - position.dy;
      _overlay2Bottom = screenHeight - position.dy - size.height;
      _overlay3Bottom = 0;
      _initContentBottom = screenHeight - position.dy;
    }
  }

  Future<void> add([TDDropdownItem? updateChild]) async {
    _init();
    overlayEntry?.remove();
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Stack(children: [
          _getOverlay1(),
          _getOverlay2(),
          _getOverlay3(),
          TDDropdownInherited(
              state: this,
              child: TDDropdownPanel(
                duration: _duration,
                direction: direction ?? TDDropdownPopupDirection.down,
                initContentBottom: _initContentBottom,
                initContentTop: _initContentTop,
                closeCallback: _closeCallback,
                child: updateChild ?? child,
              )),
        ]);
      },
    );

    Overlay.of(parentContext).insert(overlayEntry!);
    await Future.delayed(_duration);
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
