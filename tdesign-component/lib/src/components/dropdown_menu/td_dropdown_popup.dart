import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'td_dropdown_item.dart';
import 'td_dropdown_menu.dart';

typedef FutureReturnCallback = Future<void> Function();
typedef FutureParamCallback = void Function(FutureReturnCallback);

class TDDropdownPopup {
  TDDropdownPopup(
    this.context,
    this.items,
    this.index,
    this.widget,
    this.onClose,
  );

  final BuildContext context;
  final List<TDDropdownItem> items;
  final int index;
  final TDDropdownMenu widget;
  final VoidCallback onClose;

  late double _overlayTop, _overlayBottom, _initContentTop, _initContentBottom;
  late FutureReturnCallback _closeContent;

  OverlayEntry? overlayEntry;

  Future<void> add() async {
    var completer = Completer<void>();
    var renderBox = context.findRenderObject() as RenderBox;
    var position = renderBox.localToGlobal(Offset.zero);
    var size = renderBox.size;
    var screenHeight = MediaQuery.of(context).size.height;
    var isDown = widget.direction == TDDropdownMenuDirection.down;
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
              color: widget.showOverlay ? Colors.black54 : Colors.transparent,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (widget.closeOnClickOverlay) {
                    onClose();
                  }
                },
              ),
            ),
          ),
          _TDDropdownContent(
            duration: Duration(milliseconds: widget.duration.toInt()),
            direction: widget.direction,
            initContentBottom: _initContentBottom,
            initContentTop: _initContentTop,
            closeCallback: _closeCallback,
            opened: () {
              completer.complete();
            },
            child: items[index],
          ),
        ]);
      },
    );

    Overlay.of(context).insert(overlayEntry!);
    await completer.future;
  }

  Future<void> remove() async {
    await _closeContent();
    overlayEntry?.remove();
    overlayEntry = null;
  }

  _closeCallback(FutureReturnCallback fn) {
    _closeContent = fn;
  }
}

class _TDDropdownContent extends StatefulWidget {
  const _TDDropdownContent({
    Key? key,
    required this.initContentTop,
    required this.initContentBottom,
    required this.duration,
    required this.direction,
    required this.closeCallback,
    required this.opened,
    required this.child,
  }) : super(key: key);

  final double initContentTop;
  final double initContentBottom;
  final Duration duration;
  final TDDropdownMenuDirection direction;
  final FutureParamCallback closeCallback;
  final VoidCallback opened;
  final Widget child;

  @override
  _TDDropdownContentState createState() => _TDDropdownContentState();
}

class _TDDropdownContentState extends State<_TDDropdownContent> {
  double? contentTop, contentBottom;
  Completer<void>? _animationCompleter;

  @override
  void initState() {
    super.initState();
    widget.closeCallback(close);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: contentTop ?? widget.initContentTop,
      bottom: contentBottom ?? widget.initContentBottom,
      left: 0,
      right: 0,
      duration: contentBottom != null || contentTop != null
          ? widget.duration
          : widget.duration ~/ 2,
      onEnd: () {
        _animationCompleter?.complete();
      },
      child: SingleChildScrollView(
        child: Builder(
          builder: (BuildContext context) {
            open(context);
            return widget.child;
          },
        ),
      ),
    );
  }

  void open(BuildContext popupContext) {
    if (contentBottom != null || contentTop != null) {
      return;
    }
    if (_animationCompleter != null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _animationCompleter = Completer<void>();
      var renderBox = popupContext.findRenderObject() as RenderBox;
      var size = renderBox.size;
      setState(() {
        if (widget.direction == TDDropdownMenuDirection.down) {
          contentBottom = max(0, widget.initContentBottom - size.height);
        } else {
          contentTop = max(0, widget.initContentTop - size.height);
        }
      });
      await _animationCompleter!.future;
      _animationCompleter = null;
      widget.opened();
    });
  }

  Future<void> close() async {
    _animationCompleter = Completer<void>();
    setState(() {
      contentBottom = contentTop = null;
    });
    await _animationCompleter!.future;
    _animationCompleter = null;
  }
}
