import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'td_dropdown_menu.dart';
import 'td_dropdown_popup.dart';

typedef FutureParamCallback = void Function(VoidCallback);

class TDDropdownPanel extends StatefulWidget {
  const TDDropdownPanel({
    Key? key,
    required this.initContentTop,
    required this.initContentBottom,
    required this.reverseHeight,
    required this.duration,
    required this.directionListenable,
    required this.direction,
    required this.closeCallback,
    required this.child,
  }) : super(key: key);

  final double initContentTop;
  final double initContentBottom;
  final double reverseHeight;
  final Duration duration;
  final ValueNotifier<TDDropdownPopupDirection> directionListenable;
  final TDDropdownPopupDirection direction;
  final FutureParamCallback closeCallback;
  final Widget child;

  @override
  TDDropdownPanelState createState() => TDDropdownPanelState();
}

class TDDropdownPanelState extends State<TDDropdownPanel> {
  bool isClose = false;
  double? contentTop, contentBottom;

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

  void open(BuildContext itemContext) {
    if (contentBottom != null || contentTop != null || isClose == true) {
      return;
    }
    isClose = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var renderBox = itemContext.findRenderObject() as RenderBox;
      var size = renderBox.size;
      if (widget.directionListenable.value == TDDropdownPopupDirection.auto) {
        // 比较展开方向（down）的高度能不能放下item，能将方向更新为down
        // 否则比较反方向（up）的高度是否大于down的方向，大于则将方向更新为up，否则保持为down
        if (widget.direction == TDDropdownPopupDirection.down) {
          if (widget.initContentBottom >= size.height) {
            widget.directionListenable.value = TDDropdownPopupDirection.down;
          } else {
            if (widget.reverseHeight > widget.initContentBottom) {
              widget.directionListenable.value = TDDropdownPopupDirection.up;
            } else {
              widget.directionListenable.value = TDDropdownPopupDirection.down;
            }
          }
        } else {
          if (widget.initContentTop >= size.height) {
            widget.directionListenable.value = TDDropdownPopupDirection.up;
          } else {
            if (widget.reverseHeight > widget.initContentTop) {
              widget.directionListenable.value = TDDropdownPopupDirection.down;
            } else {
              widget.directionListenable.value = TDDropdownPopupDirection.up;
            }
          }
        }
        return;
      }
      setState(() {
        if (widget.direction == TDDropdownPopupDirection.down) {
          contentBottom = widget.initContentBottom - size.height; // max(0, widget.initContentBottom - size.height);
        } else {
          contentTop = widget.initContentTop - size.height; // max(0, widget.initContentTop - size.height);
        }
      });
    });
  }

  void close() {
    isClose = true;
    setState(() {
      contentBottom = contentTop = null;
    });
  }
}
