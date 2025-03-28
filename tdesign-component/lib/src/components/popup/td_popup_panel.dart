import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';

typedef PopupClick = Function();

/// 弹窗基类
abstract class TDPopupBasePanel extends StatefulWidget {
  const TDPopupBasePanel({
    Key? key,
    required this.child,
    this.title,
    this.titleColor,
    this.backgroundColor,
    this.radius,
    this.draggable = false,
    this.maxHeightRatio = 0.9,
    this.minHeightRatio = 0.3,
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

  @override
  State<TDPopupBasePanel> createState();
}

abstract class _TDPopupBaseState<T extends TDPopupBasePanel> extends State<T>
    with SingleTickerProviderStateMixin {
  static const _dragHandleHeight = 24.0;
  static const _headerHeight = 58.0;

  late AnimationController _controller;
  late double _maxHeight;
  late double _minHeight;
  double _currentHeight = 0;
  bool _isFullscreen = false;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..addListener(_updateHeight);
  }

  void _updateHeight() => setState(() {
    _currentHeight = _minHeight + (_maxHeight - _minHeight) * _controller.value;
  });

  void _toggleFullscreen(bool fullscreen) {
    if (_isAnimating || _isFullscreen == fullscreen) return;

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
    if (_isAnimating) return;
    _isAnimating = true;

    final value = (height - _minHeight) / (_maxHeight - _minHeight);
    _controller.animateTo(value.clamp(0.0, 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
    ).whenComplete(() => _isAnimating = false);
  }

  Widget _buildDragHandle() {
    if (!widget.draggable) return const SizedBox.shrink();

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
            color: TDTheme.of(context).grayColor3,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    _maxHeight = screenHeight * widget.maxHeightRatio;
    _minHeight = screenHeight * widget.minHeightRatio;
    if (_currentHeight == 0) _currentHeight = _minHeight;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => RepaintBoundary(
        child: Container(
          height: _currentHeight,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? TDTheme.of(context).whiteColor1,
            borderRadius: _isFullscreen
                ? null
                : BorderRadius.vertical(top: Radius.circular(widget.radius ?? 12)),
          ),
          child: Column(children: [
            _buildDragHandle(),
            buildHeader(context),
            Expanded(child: _buildContent()),
          ]),
        ),
      ),
    );
  }

  Widget _buildContent() => NotificationListener<ScrollNotification>(
    onNotification: (notification) {
      if (notification is ScrollUpdateNotification) {
        final metrics = notification.metrics;
        if ((metrics.pixels <= 0 || metrics.pixels >= metrics.maxScrollExtent) &&
            notification.dragDetails != null) {
          _handleDragUpdate(notification.dragDetails!);
        }
      }
      return false;
    },
    child: widget.child,
  );

  @protected
  void _handleDragUpdate(DragUpdateDetails details);

  @protected
  void _handleDragEnd(DragEndDetails details);

  @protected
  Widget buildHeader(BuildContext context);

  void _baseHandleDragUpdate(DragUpdateDetails details) {
    if (_isAnimating || !widget.draggable) return;

    final newHeight = _currentHeight - details.primaryDelta! * 1.2;
    _currentHeight = newHeight.clamp(_minHeight, _maxHeight);
    _controller.value = (_currentHeight - _minHeight) / (_maxHeight - _minHeight);
  }

  void _baseHandleDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dy;
    final predictedHeight = _currentHeight + velocity * 0.15;

    if (predictedHeight > _maxHeight * 0.7 || velocity < -800) {
      _animateTo(_maxHeight);
    } else if (predictedHeight < _minHeight * 1.3 || velocity > 800) {
      _animateTo(_minHeight);
    }
  }
}

/// 右上角带关闭的底部浮层面板
class TDPopupBottomDisplayPanel extends TDPopupBasePanel {
  const TDPopupBottomDisplayPanel({
    super.key,
    required super.child,
    super.title,
    super.titleColor,
    this.titleLeft = false,
    this.hideClose = false,
    this.closeColor,
    this.closeClick,
    super.backgroundColor,
    super.radius,
    super.draggable,
    super.maxHeightRatio,
    super.minHeightRatio,
  });

  /// 标题是否靠左
  final bool titleLeft;
  /// 是否隐藏关闭按钮
  final bool hideClose;
  /// 关闭按钮颜色
  final Color? closeColor;
  /// 关闭按钮点击回调
  final PopupClick? closeClick;

  @override
  State<TDPopupBasePanel> createState() => _TDPopupBottomDisplayPanelState();
}

class _TDPopupBottomDisplayPanelState extends _TDPopupBaseState<TDPopupBottomDisplayPanel> {
  @override
  Widget buildHeader(BuildContext context) {
    Widget header = Container(
      alignment: widget.titleLeft ? Alignment.centerLeft : Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
      header = Stack(
        alignment: Alignment.centerLeft,
        children: [
          Padding(
            padding: EdgeInsets.only(
                right: 40,
                left: widget.titleLeft ? 0 : 40
            ),
            child: header,
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: Icon(TDIcons.close,
                color: widget.closeColor,
                size: 24,
              ),
              onPressed: widget.closeClick,
            ),
          ),
        ],
      );
    }

    return SizedBox(
      height: widget.draggable
          ? _TDPopupBaseState._headerHeight - _TDPopupBaseState._dragHandleHeight
          : _TDPopupBaseState._headerHeight,
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
  void _handleDragEnd(DragEndDetails details) => super._baseHandleDragEnd(details);
}

/// 带确认的底部浮层面板
class TDPopupBottomConfirmPanel extends TDPopupBasePanel {
  const TDPopupBottomConfirmPanel({
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
    super.backgroundColor,
    super.radius,
    super.draggable,
    super.maxHeightRatio,
    super.minHeightRatio,
  });

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

  @override
  State<TDPopupBasePanel> createState() => _TDPopupBottomConfirmPanelState();
}

class _TDPopupBottomConfirmPanelState extends _TDPopupBaseState<TDPopupBottomConfirmPanel> {
  @override
  Widget buildHeader(BuildContext context) {
    return SizedBox(
      height: widget.draggable
          ? _TDPopupBaseState._headerHeight - _TDPopupBaseState._dragHandleHeight
          : _TDPopupBaseState._headerHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(
            text: widget.leftText ?? context.resource.cancel,
            color: widget.leftTextColor ?? TDTheme.of(context).fontGyColor2,
            onTap: widget.leftClick,
            left: true,
          ),
          Expanded(
            child: Center(
              child: TDText(
                widget.title ?? '',
                textColor: widget.titleColor ?? TDTheme.of(context).fontGyColor1,
                font: TDTheme.of(context).fontTitleLarge,
                fontWeight: FontWeight.w700,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          _buildActionButton(
            text: widget.rightText ?? context.resource.confirm,
            color: widget.rightTextColor ?? TDTheme.of(context).brandNormalColor,
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
  }) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.only(
        left: left ? 16 : 0,
        right: left ? 0 : 16,
      ),
      child: TDText(
        text,
        textColor: color,
        font: left
            ? TDTheme.of(context).fontBodyLarge
            : TDTheme.of(context).fontTitleMedium,
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
  void _handleDragEnd(DragEndDetails details) => super._baseHandleDragEnd(details);
}

/// 居中浮层面板
class TDPopupCenterPanel extends StatelessWidget {
  const TDPopupCenterPanel({
    super.key,
    required this.child,
    this.closeUnderBottom = false,
    this.closeColor,
    this.closeClick,
    this.backgroundColor,
    this.radius,
  });

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
          const SizedBox(height: 40),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: backgroundColor ?? TDTheme.of(context).whiteColor1,
              borderRadius: BorderRadius.circular(radius ?? 12),
            ),
            child: child,
          ),
          IconButton(
            icon: Icon(TDIcons.close_circle,
              color: closeColor ?? TDTheme.of(context).fontWhColor1,
              size: 40,
            ),
            onPressed: closeClick,
          ),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? TDTheme.of(context).whiteColor1,
        borderRadius: BorderRadius.circular(radius ?? 12),
      ),
      child: Stack(
        children: [
          child,
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: Icon(TDIcons.close,
                color: closeColor,
                size: 24,
              ),
              onPressed: closeClick,
            ),
          ),
        ],
      ),
    );
  }
}