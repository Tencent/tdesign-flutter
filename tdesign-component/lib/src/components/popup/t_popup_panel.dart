import 'dart:math';

import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';

typedef PopupClick = Function();

/// 弹窗基类
abstract class TPopupBasePanel extends StatefulWidget {
  const TPopupBasePanel({
    Key? key,
    required this.child,
    this.title,
    this.titleColor,
    this.backgroundColor,
    this.radius,
    this.draggable = false,
    this.maxHeightRatio = 0.9,
    this.minHeightRatio = 0.3,
    this.fixedHeight,
  }) : super(key: key);

  /// 子控件
  final Widget child;

  /// 标题
  final String? title;

  /// 标题颜色
  final Color? titleColor;

  /// 背景颜色
  final Color? backgroundColor;

  /// 圆角
  final double? radius;

  /// 边缘是否可拖动
  final bool draggable;

  /// 最大高度比例
  final double maxHeightRatio;

  /// 最小高度比例
  final double minHeightRatio;

  /// 固定高度（px）。设置后忽略 [maxHeightRatio] / [minHeightRatio]，
  /// 面板高度固定为该值。
  final double? fixedHeight;

  @override
  State<TPopupBasePanel> createState();
}

abstract class _TPopupBaseState<T extends TPopupBasePanel> extends State<T>
    with SingleTickerProviderStateMixin {
  final GlobalKey _childKey = GlobalKey();
  static const _dragHandleHeight = 24.0;
  static const _headerHeight = 58.0;

  late AnimationController _controller;
  double _maxHeight = 0;
  double _minHeight = 0;
  double _currentHeight = 0;
  double _lastScreenHeight = 0;
  double? _lastMaxHeightRatio;
  double? _lastMinHeightRatio;
  bool? _lastDraggable;
  bool _isFullscreen = false;
  bool _isAnimating = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    if (widget.draggable) {
      _controller.addListener(_updateHeight);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _initHeight());
  }

  /// 根据屏幕高度和比例（或固定高度）初始化面板高度
  void _initHeight() {
    final ctx = _childKey.currentContext ?? context;
    final screenHeight = MediaQuery.of(ctx).size.height;

    if (_lastScreenHeight == screenHeight &&
        _lastMaxHeightRatio == widget.maxHeightRatio &&
        _lastMinHeightRatio == widget.minHeightRatio &&
        _lastDraggable == widget.draggable) {
      return;
    }
    _lastScreenHeight = screenHeight;
    _lastMaxHeightRatio = widget.maxHeightRatio;
    _lastMinHeightRatio = widget.minHeightRatio;
    _lastDraggable = widget.draggable;

    if (widget.fixedHeight != null) {
      _maxHeight = widget.fixedHeight!;
      _minHeight = widget.fixedHeight!;
    } else {
      _maxHeight = screenHeight * widget.maxHeightRatio;
      _minHeight = screenHeight * widget.minHeightRatio;
      if (_minHeight > _maxHeight) {
        _minHeight = _maxHeight;
      }
    }

    _currentHeight = _maxHeight;
    _controller.value = 1.0;
    // 触发 rebuild 以应用新计算的 _currentHeight
    setState(() {});
  }

  void _updateHeight() => setState(() {
        _currentHeight =
            _minHeight + (_maxHeight - _minHeight) * _controller.value;
      });

  void _toggleFullscreen(bool fullscreen) {
    if (_isAnimating || _isFullscreen == fullscreen) {
      return;
    }

    setState(() {
      _isFullscreen = fullscreen;
      _maxHeight = fullscreen
          ? MediaQuery.of(context).size.height
          : MediaQuery.of(context).size.height * widget.maxHeightRatio;
    });

    _controller.animateTo(
      fullscreen ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _animateTo(double height) {
    if (_isAnimating) {
      return;
    }
    _isAnimating = true;

    final value = (height - _minHeight) / (_maxHeight - _minHeight);
    _controller
        .animateTo(
          value.clamp(0.0, 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
        )
        .whenComplete(() => _isAnimating = false);
  }

  Widget _buildDragHandle() {
    if (!widget.draggable) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      onDoubleTap: () => _toggleFullscreen(!_isFullscreen),
      child: Container(
        height: _dragHandleHeight,
        alignment: Alignment.center,
        child: Container(
          width: 48,
          height: 4,
          decoration: BoxDecoration(
            color: TTheme.of(context).componentStrokeColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isDragging) {
        return;
      }
      _initHeight();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => RepaintBoundary(
        child: Container(
          height: _currentHeight,
          decoration: BoxDecoration(
            color:
                widget.backgroundColor ?? TTheme.of(context).bgColorContainer,
            borderRadius: _isFullscreen
                ? null
                : BorderRadius.vertical(
                    top: Radius.circular(
                        widget.radius ?? TTheme.of(context).radiusExtraLarge)),
          ),
          child: Column(children: [
            _buildDragHandle(),
            buildHeader(context),
            Expanded(
              child: _buildContent(),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildContent() => NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            final metrics = notification.metrics;
            if ((metrics.pixels <= 0 ||
                    metrics.pixels >= metrics.maxScrollExtent) &&
                notification.dragDetails != null) {
              _handleDragUpdate(notification.dragDetails!);
            }
          }
          return false;
        },
        child: Container(
          key: _childKey,
          child: widget.child,
        ),
      );

  @protected
  void _handleDragUpdate(DragUpdateDetails details);

  @protected
  void _handleDragEnd(DragEndDetails details);

  @protected
  Widget buildHeader(BuildContext context);

  void _baseHandleDragUpdate(DragUpdateDetails details) {
    _isDragging = true;
    if (_isAnimating || !widget.draggable) {
      return;
    }

    final newHeight = _currentHeight - details.primaryDelta! * 1.2;
    _currentHeight = newHeight.clamp(_minHeight, _maxHeight);
    _controller.value =
        (_currentHeight - _minHeight) / (_maxHeight - _minHeight);
  }

  void _baseHandleDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dy;
    final predictedHeight = _currentHeight + velocity * 0.15;

    if (predictedHeight > _maxHeight * 0.7 || velocity < -800) {
      _animateTo(_maxHeight);
    } else if (predictedHeight < _minHeight * 1.3 || velocity > 800) {
      _animateTo(_minHeight);
    }
    _isDragging = false;
  }
}

/// 右上角带关闭的底部浮层面板
class TPopupBottomDisplayPanel extends TPopupBasePanel {
  const TPopupBottomDisplayPanel({
    super.key,
    required super.child,
    super.title,
    super.titleColor,
    this.titleFontSize,
    this.titleLeft = false,
    this.hideClose = false,
    this.closeColor,
    this.closeSize,
    this.closeClick,
    super.backgroundColor,
    super.radius,
    super.draggable,
    super.maxHeightRatio,
    super.minHeightRatio,
    super.fixedHeight,
  });

  /// 标题字体大小
  final double? titleFontSize;

  /// 标题是否靠左
  final bool titleLeft;

  /// 是否隐藏关闭按钮
  final bool hideClose;

  /// 关闭按钮颜色
  final Color? closeColor;

  /// 关闭按钮图标尺寸
  final double? closeSize;

  /// 关闭按钮点击回调
  final PopupClick? closeClick;

  @override
  State<TPopupBasePanel> createState() => _TPopupBottomDisplayPanelState();
}

class _TPopupBottomDisplayPanelState
    extends _TPopupBaseState<TPopupBottomDisplayPanel> {
  @override
  Widget buildHeader(BuildContext context) {
    Widget header = Container(
      alignment: widget.titleLeft ? Alignment.centerLeft : Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TText(
        widget.title ?? '',
        textColor: widget.titleColor ?? TTheme.of(context).textColorPrimary,
        font: TTheme.of(context).fontTitleLarge?.withSize(
            widget.titleFontSize?.toInt() ??
                TTheme.of(context).fontTitleLarge!.size.toInt()),
        fontWeight: FontWeight.w700,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    if (!widget.hideClose) {
      header = Stack(
        alignment: Alignment.centerLeft,
        children: [
          Padding(
            padding:
                EdgeInsets.only(right: 40, left: widget.titleLeft ? 0 : 40),
            child: header,
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: Icon(
                TIcons.close,
                color: widget.closeColor,
                size: widget.closeSize,
              ),
              onPressed: widget.closeClick,
            ),
          ),
        ],
      );
    }

    return SizedBox(
      height: widget.draggable
          ? _TPopupBaseState._headerHeight -
              _TPopupBaseState._dragHandleHeight
          : _TPopupBaseState._headerHeight,
      child: header,
    );
  }

  @override
  void _handleDragUpdate(DragUpdateDetails details) {
    super._baseHandleDragUpdate(details);

    final progress = (_currentHeight - _minHeight) / (_maxHeight - _minHeight);
    if (progress > 0.85 && !_isFullscreen) {
      _toggleFullscreen(true);
    } else if (progress < 0.75 && _isFullscreen) {
      _toggleFullscreen(false);
    }
  }

  @override
  void _handleDragEnd(DragEndDetails details) =>
      super._baseHandleDragEnd(details);
}

/// 带确认的底部浮层面板
class TPopupBottomConfirmPanel extends TPopupBasePanel {
  const TPopupBottomConfirmPanel({
    super.key,
    required super.child,
    super.title,
    super.titleColor,
    this.leftText,
    this.leftTextColor,
    this.leftClick,
    this.rightText,
    this.rightTextColor,
    this.rightClick,
    this.titleFontSize,
    this.leftTextFontSize,
    this.rightTextFontSize,
    super.backgroundColor,
    super.radius,
    super.draggable,
    super.maxHeightRatio,
    super.minHeightRatio,
  });

  /// 标题字体大小
  final double? titleFontSize;

  /// 左边文本
  final String? leftText;

  /// 左边文本字体大小
  final double? leftTextFontSize;

  /// 左边文本颜色
  final Color? leftTextColor;

  /// 左边文本点击回调
  final PopupClick? leftClick;

  /// 右边文本
  final String? rightText;

  /// 右边文本字体大小
  final double? rightTextFontSize;

  /// 右边文本颜色
  final Color? rightTextColor;

  /// 右边文本点击回调
  final PopupClick? rightClick;

  @override
  State<TPopupBasePanel> createState() => _TPopupBottomConfirmPanelState();
}

class _TPopupBottomConfirmPanelState
    extends _TPopupBaseState<TPopupBottomConfirmPanel> {
  @override
  Widget buildHeader(BuildContext context) {
    return SizedBox(
      height: widget.draggable
          ? _TPopupBaseState._headerHeight -
              _TPopupBaseState._dragHandleHeight
          : _TPopupBaseState._headerHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(
            text: widget.leftText ?? context.resource.cancel,
            color:
                widget.leftTextColor ?? TTheme.of(context).textColorSecondary,
            onTap: widget.leftClick,
            left: true,
          ),
          Expanded(
            child: Center(
              child: TText(
                widget.title ?? '',
                textColor:
                    widget.titleColor ?? TTheme.of(context).textColorPrimary,
                font: TTheme.of(context).fontTitleLarge?.withSize(
                    widget.titleFontSize?.toInt() ??
                        TTheme.of(context).fontTitleLarge!.size.toInt()),
                fontWeight: FontWeight.w700,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          _buildActionButton(
            text: widget.rightText ?? context.resource.confirm,
            color:
                widget.rightTextColor ?? TTheme.of(context).brandNormalColor,
            onTap: widget.rightClick,
            left: false,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    required VoidCallback? onTap,
    required bool left,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(
            left: left ? 16 : 0,
            right: left ? 0 : 16,
          ),
          child: TText(
            text,
            textColor: color,
            font: (left
                    ? TTheme.of(context).fontBodyLarge
                    : TTheme.of(context).fontTitleMedium)
                ?.withSize(left
                    ? widget.leftTextFontSize?.toInt() ??
                        TTheme.of(context).fontBodyLarge!.size.toInt()
                    : widget.rightTextFontSize?.toInt() ??
                        TTheme.of(context).fontTitleMedium!.size.toInt()),
            fontWeight: left ? FontWeight.w400 : FontWeight.w600,
          ),
        ),
      );

  @override
  void _handleDragUpdate(DragUpdateDetails details) {
    super._baseHandleDragUpdate(details);

    const threshold = 0.15;
    final progress = (_currentHeight - _minHeight) / (_maxHeight - _minHeight);
    if (progress > (1 - threshold) && !_isFullscreen) {
      _toggleFullscreen(true);
    } else if (progress < threshold && _isFullscreen) {
      _toggleFullscreen(false);
    }
  }

  @override
  void _handleDragEnd(DragEndDetails details) =>
      super._baseHandleDragEnd(details);
}

/// 居中浮层面板
class TPopupCenterPanel extends StatelessWidget {
  const TPopupCenterPanel({
    super.key,
    required this.child,
    this.closeUnderBottom = false,
    this.closeColor,
    this.closeClick,
    this.backgroundColor,
    this.radius,
    this.closeSize,
  });

  /// 子控件
  final Widget child;

  /// 关闭按钮是否在视图框下方
  final bool closeUnderBottom;

  /// 关闭按钮颜色
  final Color? closeColor;

  /// 关闭按钮图标尺寸
  final double? closeSize;

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
          const SizedBox(height: 40),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: backgroundColor ?? TTheme.of(context).bgColorContainer,
              borderRadius: BorderRadius.circular(
                  radius ?? TTheme.of(context).radiusExtraLarge),
            ),
            child: child,
          ),
          IconButton(
            icon: Icon(
              TIcons.close_circle,
              color: closeColor ?? TTheme.of(context).fontWhColor1,
              size: closeSize ?? 32,
            ),
            onPressed: closeClick,
          ),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(
            radius ?? TTheme.of(context).radiusExtraLarge),
      ),
      child: Stack(
        children: [
          child,
          Positioned(
            top: TTheme.of(context).spacer8,
            right: TTheme.of(context).spacer8,
            child: IconButton(
              icon: Icon(
                TIcons.close,
                color: closeColor,
                size: closeSize,
              ),
              onPressed: closeClick,
            ),
          ),
        ],
      ),
    );
  }
}
