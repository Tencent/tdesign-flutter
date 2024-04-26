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
    required this.duration,
    required this.direction,
    required this.closeCallback,
    required this.child,
  }) : super(key: key);

  final double initContentTop;
  final double initContentBottom;
  final Duration duration;
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

  void open(BuildContext popupContext) {
    if (contentBottom != null || contentTop != null || isClose == true) {
      return;
    }
    isClose = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var renderBox = popupContext.findRenderObject() as RenderBox;
      var size = renderBox.size;
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
