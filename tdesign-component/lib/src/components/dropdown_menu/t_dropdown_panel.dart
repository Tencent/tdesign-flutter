import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 't_dropdown_menu.dart';
import 't_dropdown_popup.dart';

/// 下拉菜单内容面板，负责展开/收起动画
class TDropdownPanel extends StatefulWidget {
  const TDropdownPanel({
    Key? key,
    required this.initContentTop,
    required this.initContentBottom,
    required this.reverseHeight,
    required this.duration,
    required this.directionListenable,
    required this.colorAlphaListenable,
    required this.direction,
    required this.closeListenable,
    required this.onOpened,
    required this.child,
  }) : super(key: key);

  /// 初始内容顶部偏移
  final double initContentTop;

  /// 初始内容底部偏移
  final double initContentBottom;

  /// 反方向可用高度
  final double reverseHeight;

  /// 动画时长
  final Duration duration;

  /// 方向监听器
  final ValueNotifier<TDropdownPopupDirection> directionListenable;

  /// 遮罩透明度监听器
  final ValueNotifier<bool> colorAlphaListenable;

  /// 展开方向
  final TDropdownPopupDirection direction;

  /// 关闭回调监听器
  final ValueNotifier<FutureCallback?> closeListenable;

  /// 展开完成回调
  final VoidCallback onOpened;

  /// 子内容
  final Widget child;

  @override
  _TDropdownPanelState createState() => _TDropdownPanelState();
}

class _TDropdownPanelState extends State<TDropdownPanel> with SingleTickerProviderStateMixin {
  double? contentTop, contentBottom;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    widget.closeListenable.value = close;
  }

  @override
  void didUpdateWidget(TDropdownPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.directionListenable != oldWidget.directionListenable) {
      widget.closeListenable.value = close; // coverage:ignore-line
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PositionedTransition(
      rect: _getAnimation(),
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

  /// 展开面板
  void open(BuildContext itemContext) {
    if (contentBottom != null || contentTop != null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) {
        return;
      }
      var renderBox = itemContext.findRenderObject() as RenderBox;
      var size = renderBox.size;
      if (widget.directionListenable.value == TDropdownPopupDirection.auto) {
        // 比较展开方向（down）的高度能不能放下item，能将方向更新为down
        // 否则比较反方向（up）的高度是否大于down的方向，大于则将方向更新为up，否则保持为down
        if (widget.direction == TDropdownPopupDirection.down) {
          if (widget.initContentBottom >= size.height) {
            widget.directionListenable.value = TDropdownPopupDirection.down;
          } else {
            if (widget.reverseHeight > widget.initContentBottom) { // coverage:ignore-line
              widget.directionListenable.value = TDropdownPopupDirection.up; // coverage:ignore-line
            } else {
              widget.directionListenable.value = TDropdownPopupDirection.down; // coverage:ignore-line
            }
          }
        } else {
          if (widget.initContentTop >= size.height) { // coverage:ignore-line
            widget.directionListenable.value = TDropdownPopupDirection.up; // coverage:ignore-line
          } else {
            if (widget.reverseHeight > widget.initContentTop) { // coverage:ignore-line
              widget.directionListenable.value = TDropdownPopupDirection.down; // coverage:ignore-line
            } else {
              widget.directionListenable.value = TDropdownPopupDirection.up; // coverage:ignore-line
            }
          }
        }
        return;
      }
      if (widget.direction == TDropdownPopupDirection.down) {
        contentBottom = widget.initContentBottom - size.height;
      } else {
        contentTop = widget.initContentTop - size.height;
      }
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        if (_controller.status == AnimationStatus.dismissed) {
          widget.colorAlphaListenable.value = true;
          _controller.duration = widget.duration;
          _controller.forward().whenCompleteOrCancel(() {
            widget.onOpened();
          });
        }
      });
    });
  }

  Animation<RelativeRect> _getAnimation() {
    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(0, widget.initContentTop, 0, widget.initContentBottom),
      end: RelativeRect.fromLTRB(0, contentTop ?? widget.initContentTop, 0, contentBottom ?? widget.initContentBottom),
    ).animate(_controller);
  }

  /// 收起面板
  Future<void> close() {
    widget.colorAlphaListenable.value = false;
    _controller.duration = widget.duration ~/ 2;
    return _controller.reverse();
  }
}
