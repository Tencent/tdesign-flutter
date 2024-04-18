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
  final Widget child;
  final FutureCallback? handleClose;
  final TDDropdownPopupDirection? direction;
  final bool? showOverlay;
  final bool? closeOnClickOverlay;
  final Duration? duration;

  late double _overlayTop,
      _overlayBottom,
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
      _overlayTop = position.dy + size.height;
      _initContentTop = _overlayTop;
      _overlayBottom = 0;
      _initContentBottom = screenHeight - _initContentTop;
    } else {
      _overlayTop = 0;
      _initContentTop = position.dy;
      _overlayBottom = screenHeight - position.dy;
      _initContentBottom = _overlayBottom;
    }
  }

  Future<void> add([Widget? updateChild]) async {
    _init();
    overlayEntry?.remove();
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Stack(children: [
          Positioned(
            top: _overlayTop,
            bottom: _overlayBottom,
            left: 0,
            right: 0,
            child: Container(
              color:
                  (showOverlay ?? true) ? Colors.black54 : Colors.transparent,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (!(closeOnClickOverlay ?? true)) {
                    return;
                  }
                  if (handleClose != null) {
                    handleClose!();
                  } else {
                    remove();
                  }
                },
              ),
            ),
          ),
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
