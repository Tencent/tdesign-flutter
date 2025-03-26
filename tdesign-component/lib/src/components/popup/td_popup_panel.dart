import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';

typedef PopupClick = Function();

/// 右上角带关闭的底部浮层面板
class TDPopupBottomDisplayPanel extends StatefulWidget {
  const TDPopupBottomDisplayPanel({
    required this.child,
    this.title,
    this.titleColor,
    this.titleLeft = false,
    this.hideClose = false,
    this.closeColor,
    this.closeClick,
    this.backgroundColor,
    this.radius,
    this.draggable = false,
    this.maxHeightRatio = 0.9,
    this.minHeightRatio = 0.3,
    Key? key,
  }) : super(key: key);

  /// 子控件
  final Widget child;

  /// 标题
  final String? title;

  /// 标题颜色
  final Color? titleColor;

  /// 标题是否靠左
  final bool titleLeft;

  /// 是否隐藏关闭按钮
  final bool hideClose;

  /// 关闭按钮颜色
  final Color? closeColor;

  /// 关闭按钮点击回调
  final PopupClick? closeClick;

  /// 背景颜色
  final Color? backgroundColor;

  /// 圆角
  final double? radius;

  /// 是否可拖动
  final bool draggable;

  /// 最大高度比例
  final double maxHeightRatio;

  /// 最小高度比例
  final double minHeightRatio;

  @override
  State<TDPopupBottomDisplayPanel> createState() => _TDPopupBottomDisplayPanelState();
}

class _TDPopupBottomDisplayPanelState extends State<TDPopupBottomDisplayPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _maxHeight;
  late double _minHeight;
  double _currentHeight = 0;
  bool _isFullscreen = false;
  late BoxConstraints _constraints;

  final double _dragHandleHeight = 24.0;
  final double _headerHeight = 58.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _controller.addListener(_updateHeight);
  }

  void _updateHeight() {
    setState(() {
      _currentHeight = _minHeight + (_maxHeight - _minHeight) * _controller.value;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFullscreen(bool fullscreen) {
    if (_isFullscreen == fullscreen) {
      return;
    }

    setState(() {
      _isFullscreen = fullscreen;
      if (fullscreen) {
        _maxHeight = MediaQuery.of(context).size.height;
      } else {
        _maxHeight = _constraints.maxHeight * widget.maxHeightRatio;
      }
    });

    _controller.animateTo(
      fullscreen ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!widget.draggable) {
      return;
    }

    final newHeight = _currentHeight - details.primaryDelta! * 1.2;
    _currentHeight = newHeight.clamp(_minHeight, _maxHeight);

    final progress = (_currentHeight - _minHeight) / (_maxHeight - _minHeight);
    _controller.value = progress.clamp(0.0, 1.0);

    if (progress > 0.85 && !_isFullscreen) {
      _toggleFullscreen(true);
    } else if (progress < 0.75 && _isFullscreen) {
      _toggleFullscreen(false);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!widget.draggable) {
      return;
    }

    final velocity = details.velocity.pixelsPerSecond.dy;
    if (velocity < -800 || _controller.value > 0.5) {
      _animateTo(_maxHeight);
    } else if (velocity > 800 || _controller.value < 0.5) {
      _animateTo(_minHeight);
    }
  }

  void _animateTo(double height) {
    final value = (height - _minHeight) / (_maxHeight - _minHeight);
    _controller.animateTo(
      value,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _constraints = constraints;
        _maxHeight = constraints.maxHeight * widget.maxHeightRatio;
        _minHeight = constraints.maxHeight * widget.minHeightRatio;
        if (_currentHeight == 0) {
          _currentHeight = _minHeight;
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Container(
              height: _currentHeight,
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? TDTheme.of(context).whiteColor1,
                borderRadius: _isFullscreen
                    ? null
                    : BorderRadius.vertical(top: Radius.circular(widget.radius ?? 12)),
              ),
              child: Column(
                children: [
                  // 拖动条
                  _buildDragHandle(context),
                  // 标题
                  _buildHeader(),
                  // 内容
                  Expanded(child: _buildContent()),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    if (!widget.draggable) {
      // 未开启拖动事件,则不展示拖动条
      return Container();
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      onDoubleTap: () => _toggleFullscreen(!_isFullscreen),
      child: Container(
        // color: Colors.red,
        height: _dragHandleHeight,
        child: Center(
          child: Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: TDTheme.of(context).grayColor3,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    Widget result = Container(
      alignment: widget.titleLeft ? Alignment.centerLeft : Alignment.center,
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: TDText(
        widget.title ?? '',
        textColor: widget.titleColor ?? TDTheme.of(context).fontGyColor1,
        font: TDTheme.of(context).fontTitleLarge,
        fontWeight: FontWeight.w700,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
    if (!widget.hideClose) {
      result =Row(
        children: [
          // const SizedBox(width: 40,),
          Expanded(child: result),
          GestureDetector(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              width: 40,
              child: Icon(
                TDIcons.close,
                color: widget.closeColor,
                size: 24,
              ),
            ),
            onTap: widget.closeClick,
          )
        ],
      );
    }
    return SizedBox(
      height: widget.draggable ?  _headerHeight - _dragHandleHeight: _headerHeight,
      child: result,
    );
  }

  Widget _buildContent() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          final metrics = notification.metrics;
          // 顶部越界拖动
          if (metrics.pixels <= 0 && notification.dragDetails != null) {
            _handleDragUpdate(notification.dragDetails!);
          }
          // 底部越界拖动
          else if (metrics.pixels >= metrics.maxScrollExtent &&
              notification.dragDetails != null) {
            _handleDragUpdate(notification.dragDetails!);
          }
        }
        return false;
      },
      child: widget.child,
    );
  }
}


/// 带确认的底部浮层面板
class TDPopupBottomConfirmPanel extends StatefulWidget {
  const TDPopupBottomConfirmPanel({
    required this.child,
    this.title,
    this.titleColor,
    this.leftText,
    this.leftTextColor,
    this.leftClick,
    this.rightText,
    this.rightTextColor,
    this.rightClick,
    this.backgroundColor,
    this.radius,
    this.draggable = false,
    this.maxHeightRatio = 0.9,
    this.minHeightRatio = 0.3,
    Key? key,
  }) : super(key: key);

  /// 子控件
  final Widget child;

  /// 标题
  final String? title;

  /// 标题颜色
  final Color? titleColor;

  /// 左边文本
  final String? leftText;

  /// 左边文本颜色
  final Color? leftTextColor;

  /// 左边文本点击回调
  final PopupClick? leftClick;

  /// 右边文本
  final String? rightText;

  /// 右边文本颜色
  final Color? rightTextColor;

  /// 右边文本点击回调
  final PopupClick? rightClick;

  /// 背景颜色
  final Color? backgroundColor;

  /// 圆角
  final double? radius;

  /// 是否可拖动
  final bool draggable;

  /// 最大高度比例
  final double maxHeightRatio;

  /// 最小高度比例
  final double minHeightRatio;

  @override
  State<TDPopupBottomConfirmPanel> createState() => _TDPopupBottomConfirmPanelState();
}

class _TDPopupBottomConfirmPanelState extends State<TDPopupBottomConfirmPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _maxHeight;
  late double _minHeight;
  double _currentHeight = 0;
  bool _isFullscreen = false;
  late BoxConstraints _constraints;

  final double _dragHandleHeight = 24.0;
  final double _headerHeight = 58.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _controller.addListener(_updateHeight);
  }

  void _updateHeight() {
    setState(() {
      _currentHeight = _minHeight + (_maxHeight - _minHeight) * _controller.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _constraints = constraints;
        _maxHeight = constraints.maxHeight * widget.maxHeightRatio;
        _minHeight = constraints.maxHeight * widget.minHeightRatio;
        if (_currentHeight == 0) {
          _currentHeight = _minHeight;
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Container(
              height: _currentHeight,
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? TDTheme.of(context).whiteColor1,
                borderRadius: _isFullscreen
                    ? null
                    : BorderRadius.vertical(top: Radius.circular(widget.radius ?? 12)),
              ),
              child: Column(
                children: [
                  // 拖动条
                  _buildDragHandle(context),
                  // 标题
                  _buildTop(context),
                  // 内容
                  Expanded(child: _buildContent()),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _toggleFullscreen(bool fullscreen) {
    if (_isFullscreen == fullscreen) {
      return;
    }

    setState(() {
      _isFullscreen = fullscreen;
      if (fullscreen) {
        _maxHeight = MediaQuery.of(context).size.height;
      } else {
        _maxHeight = _constraints.maxHeight * widget.maxHeightRatio;
      }
    });

    _controller.animateTo(
      fullscreen ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!widget.draggable) {
      return;
    }

    final newHeight = _currentHeight - details.primaryDelta! * 1.2;
    _currentHeight = newHeight.clamp(_minHeight, _maxHeight);

    final progress = (_currentHeight - _minHeight) / (_maxHeight - _minHeight);
    _controller.value = progress.clamp(0.0, 1.0);

    if (progress > 0.85 && !_isFullscreen) {
      _toggleFullscreen(true);
    } else if (progress < 0.75 && _isFullscreen) {
      _toggleFullscreen(false);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!widget.draggable) {
      return;
    }

    final velocity = details.velocity.pixelsPerSecond.dy;
    if (velocity < -800 || _controller.value > 0.5) {
      _animateTo(_maxHeight);
    } else if (velocity > 800 || _controller.value < 0.5) {
      _animateTo(_minHeight);
    }
  }

  void _animateTo(double height) {
    final value = (height - _minHeight) / (_maxHeight - _minHeight);
    _controller.animateTo(
      value,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    if (!widget.draggable) {
      // 未开启拖动事件,则不展示拖动条
      return Container();
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      onDoubleTap: () => _toggleFullscreen(!_isFullscreen),
      child: SizedBox(
        height: _dragHandleHeight + 12,
        child: Center(
          child: Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: TDTheme.of(context).grayColor3,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          final metrics = notification.metrics;
          // 顶部越界拖动处理
          if (metrics.pixels <= 0 && notification.dragDetails != null) {
            _handleDragUpdate(notification.dragDetails!);
          }
          // 底部越界拖动处理
          else if (metrics.pixels >= metrics.maxScrollExtent &&
              notification.dragDetails != null) {
            _handleDragUpdate(notification.dragDetails!);
          }
        }
        return false;
      },
      child: widget.child,
    );
  }

  Widget _buildTop(BuildContext context) {
    return SizedBox(
      height: widget.draggable ?  _headerHeight - _dragHandleHeight: _headerHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: TDText(
                widget.leftText ?? context.resource.cancel,
                textColor: widget.leftTextColor ?? TDTheme.of(context).fontGyColor2,
                font: TDTheme.of(context).fontBodyLarge,
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: widget.leftClick,
          ),
          Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TDText(
                  widget.title ?? '',
                  textColor: widget.titleColor ?? TDTheme.of(context).fontGyColor1,
                  font: TDTheme.of(context).fontTitleLarge,
                  fontWeight: FontWeight.w700,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: TDText(
                widget.rightText ?? context.resource.confirm,
                textColor: widget.rightTextColor ?? TDTheme.of(context).brandNormalColor,
                font: TDTheme.of(context).fontTitleMedium,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: widget.rightClick,
          ),
        ],
      ),
    );
  }
}

/// 居中浮层面板
class TDPopupCenterPanel extends StatelessWidget {
  const TDPopupCenterPanel({
    required this.child,
    this.closeUnderBottom = false,
    this.closeColor,
    this.closeClick,
    this.backgroundColor,
    this.radius,
    Key? key,
  }) : super(key: key);

  /// 子控件
  final Widget child;

  /// 关闭按钮是否在视图框下方
  final bool closeUnderBottom;

  /// 关闭按钮颜色
  final Color? closeColor;

  /// 关闭按钮点击回调
  final PopupClick? closeClick;

  /// 背景颜色
  final Color? backgroundColor;

  /// 圆角
  final double? radius;

  @override
  Widget build(BuildContext context) {
    if (closeUnderBottom) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: TDTheme.of(context).spacer40,
          ),
          Container(
            margin: EdgeInsets.only(top: TDTheme.of(context).spacer24, bottom: TDTheme.of(context).spacer24),
            decoration: BoxDecoration(
                color: backgroundColor ?? TDTheme.of(context).whiteColor1,
                borderRadius: BorderRadius.all(Radius.circular(radius ?? 12))),
            child: child,
          ),
          GestureDetector(
            child: Icon(
              TDIcons.close_circle,
              color: closeColor ?? TDTheme.of(context).fontWhColor1,
              size: TDTheme.of(context).spacer40,
            ),
            onTap: closeClick,
          )
        ],
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            color: backgroundColor ?? TDTheme.of(context).whiteColor1,
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 12))),
        child: Stack(
          children: [
            child,
            closeUnderBottom
                ? Container()
                : Positioned(
                    top: TDTheme.of(context).spacer16,
                    right: TDTheme.of(context).spacer16,
                    child: GestureDetector(
                      child: Icon(
                        TDIcons.close,
                        color: closeColor,
                        size: 24,
                      ),
                      onTap: closeClick,
                    ))
          ],
        ),
      );
    }
  }
}
