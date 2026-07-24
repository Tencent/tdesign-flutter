import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import 't_swiper_theme_data.dart';
import 't_swiper_types.dart';

/// 受控轮播组件。
///
/// 当前页只由 [value] 决定。用户滑动、自动播放和控制按钮仅通过 [onChanged]
/// 请求新页，不在组件内缓存业务页码。
class TSwiper extends StatefulWidget {
  const TSwiper({
    this.children,
    this.itemBuilder,
    this.itemCount,
    this.value = 0,
    this.onChanged,
    this.loop = false,
    this.autoplay = false,
    this.autoplayInterval = const Duration(seconds: 3),
    this.pagination,
    this.paginationAlignment = Alignment.bottomCenter,
    this.pageEffect,
    this.scrollDirection = Axis.horizontal,
    this.physics,
    this.pageSnapping = true,
    this.padEnds = true,
    this.clipBehavior = Clip.hardEdge,
    this.reverse = false,
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
    super.key,
  })  : assert((children == null) != (itemBuilder == null)),
        assert(children == null || itemCount == null),
        assert(itemBuilder == null || itemCount != null),
        assert(itemCount == null || itemCount > 0),
        assert(value >= 0),
        assert(!autoplay || onChanged != null);

  /// 页面列表；与 [itemBuilder] 二选一。
  final List<Widget>? children;

  /// 页面构建器；与 [children] 二选一。
  final IndexedWidgetBuilder? itemBuilder;

  /// 构建器模式的页面数量。
  final int? itemCount;

  /// 当前受控页索引。
  final int value;

  /// 请求切换页面的回调；为空时禁用手势与自动播放。
  final ValueChanged<int>? onChanged;

  /// 是否循环切换。
  final bool loop;

  /// 是否自动请求下一页。
  final bool autoplay;

  /// 自动播放间隔。
  final Duration autoplayInterval;

  /// 指示器形态；未设置时读取 Theme 和圆点默认值。
  final TSwiperPaginationVariant? pagination;

  /// 指示器对齐方式。
  final AlignmentGeometry paginationAlignment;

  /// 页面切换效果；未设置时读取 Theme。
  final TSwiperPageEffect? pageEffect;

  /// 滚动方向。
  final Axis scrollDirection;

  /// 滚动物理效果。
  final ScrollPhysics? physics;

  /// 是否吸附到整页。
  final bool pageSnapping;

  /// 是否在首尾页面添加视口边距。
  final bool padEnds;

  /// 裁剪行为。
  final Clip clipBehavior;

  /// 是否反向滚动。
  final bool reverse;

  /// 拖动开始行为。
  final DragStartBehavior dragStartBehavior;

  /// 是否允许隐式滚动。
  final bool allowImplicitScrolling;

  int get resolvedItemCount => children?.length ?? itemCount!;

  @override
  State<TSwiper> createState() => _TSwiperState();
}

class _TSwiperState extends State<TSwiper> {
  static const _loopAnchor = 10000;

  late PageController _controller;
  Timer? _timer;

  int get _count => widget.resolvedItemCount;

  int _normalize(int page) => page % _count;

  int _initialPage() {
    if (!widget.loop) {
      return widget.value;
    }
    final anchor = _loopAnchor - (_loopAnchor % _count);
    return anchor + widget.value;
  }

  @override
  void initState() {
    super.initState();
    assert(widget.value < _count);
    _controller = PageController(initialPage: _initialPage());
    _syncTimer();
  }

  @override
  void didUpdateWidget(TSwiper oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.value < _count);
    if (oldWidget.loop != widget.loop ||
        oldWidget.resolvedItemCount != _count) {
      _controller.dispose();
      _controller = PageController(initialPage: _initialPage());
    } else if (_controller.hasClients &&
        _normalize(_controller.page?.round() ?? 0) != widget.value) {
      final current = _controller.page?.round() ?? _initialPage();
      final target = widget.loop
          ? current + (widget.value - _normalize(current))
          : widget.value;
      _controller.animateToPage(
        target,
        duration: kThemeAnimationDuration,
        curve: Curves.easeInOut,
      );
    }
    if (oldWidget.autoplay != widget.autoplay ||
        oldWidget.autoplayInterval != widget.autoplayInterval ||
        oldWidget.onChanged != widget.onChanged) {
      _syncTimer();
    }
  }

  void _syncTimer() {
    _timer?.cancel();
    if (!widget.autoplay || widget.onChanged == null || _count < 2) {
      return;
    }
    _timer = Timer.periodic(widget.autoplayInterval, (_) {
      final next = widget.value + 1;
      if (next < _count) {
        widget.onChanged!(next);
      } else if (widget.loop) {
        widget.onChanged!(0);
      }
    });
  }

  void _handlePageChanged(int page) {
    final value = _normalize(page);
    if (value != widget.value) {
      widget.onChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TSwiperThemeData>();
    final pagination =
        widget.pagination ?? theme?.pagination ?? TSwiperPaginationVariant.dots;
    final effect =
        widget.pageEffect ?? theme?.pageEffect ?? TSwiperPageEffect.none;
    final pageView = PageView.builder(
      controller: _controller,
      itemCount: widget.loop ? null : _count,
      onPageChanged: _handlePageChanged,
      scrollDirection: widget.scrollDirection,
      physics: widget.onChanged == null
          ? const NeverScrollableScrollPhysics()
          : widget.physics,
      pageSnapping: widget.pageSnapping,
      padEnds: widget.padEnds,
      clipBehavior: widget.clipBehavior,
      reverse: widget.reverse,
      dragStartBehavior: widget.dragStartBehavior,
      allowImplicitScrolling: widget.allowImplicitScrolling,
      itemBuilder: (context, page) => _buildPage(context, page, effect),
    );

    if (pagination == TSwiperPaginationVariant.none || _count < 2) {
      return pageView;
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        pageView,
        Align(
          alignment: widget.paginationAlignment,
          child: Padding(
            padding: theme?.paginationMargin ?? const EdgeInsets.all(10),
            child: _buildPagination(context, pagination, theme),
          ),
        ),
      ],
    );
  }

  Widget _buildPage(
    BuildContext context,
    int page,
    TSwiperPageEffect effect,
  ) {
    final child = widget.children?[_normalize(page)] ??
        widget.itemBuilder!(context, _normalize(page));
    if (effect == TSwiperPageEffect.none) {
      return child;
    }
    return AnimatedBuilder(
      animation: _controller,
      child: child,
      builder: (context, child) {
        final current = _controller.hasClients
            ? _controller.page ?? _controller.initialPage.toDouble()
            : _controller.initialPage.toDouble();
        final distance = (current - page).abs().clamp(0.0, 1.0);
        switch (effect) {
          case TSwiperPageEffect.none:
            return child!;
          case TSwiperPageEffect.cardMargin:
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 6 + distance * 6),
              child: child,
            );
          case TSwiperPageEffect.scaleAndFade:
            return Opacity(
              opacity: 1 - distance * 0.3,
              child: Transform.scale(scale: 1 - distance * 0.2, child: child),
            );
        }
      },
    );
  }

  Widget _buildPagination(
    BuildContext context,
    TSwiperPaginationVariant variant,
    TSwiperThemeData? theme,
  ) {
    switch (variant) {
      case TSwiperPaginationVariant.none:
        return const SizedBox.shrink();
      case TSwiperPaginationVariant.fraction:
        return _buildFraction(context, theme);
      case TSwiperPaginationVariant.controls:
        return _buildControls(context, theme);
      case TSwiperPaginationVariant.dots:
      case TSwiperPaginationVariant.dotsBar:
        return _buildDots(context, variant, theme);
    }
  }

  Widget _buildDots(
    BuildContext context,
    TSwiperPaginationVariant variant,
    TSwiperThemeData? theme,
  ) {
    final size = theme?.dotSize ?? 6;
    final spacing = theme?.dotSpacing ?? 4;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < _count; index++)
          AnimatedContainer(
            key: ValueKey('swiper-dot-$index'),
            duration: kThemeAnimationDuration,
            width: index == widget.value &&
                    variant == TSwiperPaginationVariant.dotsBar
                ? theme?.activeDotWidth ?? 20
                : size,
            height: size,
            margin: EdgeInsets.symmetric(horizontal: spacing),
            decoration: BoxDecoration(
              color: index == widget.value
                  ? theme?.activeColor ?? context.tTheme.brandNormalColor
                  : theme?.inactiveColor ??
                      context.tTheme.bgColorComponentHover,
              borderRadius: BorderRadius.circular(size / 2),
            ),
          ),
      ],
    );
  }

  Widget _buildFraction(BuildContext context, TSwiperThemeData? theme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme?.fractionBackgroundColor ??
            context.tTheme.textColorPlaceholder,
        borderRadius: BorderRadius.circular(context.tTheme.radiusRound),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          '${widget.value + 1}/$_count',
          style: theme?.fractionStyle ??
              TextStyle(
                color: context.tTheme.textColorAnti,
                fontSize: context.tTheme.fontBodySmall?.size ?? 12,
              ),
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context, TSwiperThemeData? theme) {
    final canGoBack = widget.loop || widget.value > 0;
    final canGoForward = widget.loop || widget.value < _count - 1;
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            tooltip: 'Previous',
            onPressed: widget.onChanged != null && canGoBack
                ? () => widget.onChanged!(
                      widget.value == 0 ? _count - 1 : widget.value - 1,
                    )
                : null,
            icon: const Icon(Icons.chevron_left),
          ),
          IconButton(
            tooltip: 'Next',
            onPressed: widget.onChanged != null && canGoForward
                ? () => widget.onChanged!(
                      widget.value == _count - 1 ? 0 : widget.value + 1,
                    )
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}
