import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import 't_swiper_theme_data.dart';
import 't_swiper_types.dart';

/// 控制 [TSwiper] 当前页和程序化切换。
///
/// 使用 [jumpTo]、[animateTo]、[next] 和 [previous] 发起切换，通过 [index]
/// 或监听 Controller 获取当前业务索引。一个 Controller 同时只能附加一个
/// [TSwiper]，由调用方创建的实例也由调用方负责释放。
class TSwiperController extends ChangeNotifier {
  TSwiperController({this.initialIndex = 0}) : _index = initialIndex {
    if (initialIndex < 0) {
      throw ArgumentError.value(
        initialIndex,
        'initialIndex',
        'must not be negative',
      );
    }
  }

  /// 首次附加时展示的页面。
  final int initialIndex;

  int _index;
  void Function(int index)? _jumpTo;
  Future<void> Function(int index, Duration duration, Curve curve)? _animateTo;
  Future<void> Function(Duration duration, Curve curve)? _next;
  Future<void> Function(Duration duration, Curve curve)? _previous;

  /// 当前实际展示的业务索引。
  int get index => _index;

  /// 是否已附加到一个 Swiper。
  bool get hasClients => _jumpTo != null;

  /// 立即跳转到目标页。
  void jumpTo(int index) => _jumpTo?.call(index);

  /// 动画切换到目标页；循环模式始终向前到达目标。
  Future<void> animateTo(
    int index, {
    Duration duration = kThemeAnimationDuration,
    Curve curve = Curves.easeInOut,
  }) async {
    await _animateTo?.call(index, duration, curve);
  }

  /// 切换到下一页。
  Future<void> next({
    Duration duration = kThemeAnimationDuration,
    Curve curve = Curves.easeInOut,
  }) async {
    await _next?.call(duration, curve);
  }

  /// 切换到上一页。
  Future<void> previous({
    Duration duration = kThemeAnimationDuration,
    Curve curve = Curves.easeInOut,
  }) async {
    await _previous?.call(duration, curve);
  }

  void _attach({
    required void Function(int index) jumpTo,
    required Future<void> Function(int index, Duration duration, Curve curve)
        animateTo,
    required Future<void> Function(Duration duration, Curve curve) next,
    required Future<void> Function(Duration duration, Curve curve) previous,
  }) {
    if (hasClients) {
      throw StateError('TSwiperController can only control one TSwiper.');
    }
    _jumpTo = jumpTo;
    _animateTo = animateTo;
    _next = next;
    _previous = previous;
  }

  void _detach() {
    _jumpTo = null;
    _animateTo = null;
    _next = null;
    _previous = null;
  }

  void _setIndex(int value) {
    if (_index == value) {
      return;
    }
    _index = value;
    notifyListeners();
  }
}

/// Controller 驱动的轮播组件。
class TSwiper extends StatefulWidget {
  const TSwiper({
    this.children,
    this.itemBuilder,
    this.itemCount,
    this.controller,
    this.onChanged,
    this.loop = false,
    this.autoplay = false,
    this.autoplayInterval = const Duration(seconds: 3),
    this.pagination,
    this.paginationPlacement,
    this.paginationAlignment,
    this.paginationItemBuilder,
    this.previousIcon,
    this.nextIcon,
    this.pageEffect,
    this.viewportFraction = 1,
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
        assert(viewportFraction > 0);

  /// 静态页面列表；与 [itemBuilder] 二选一，且不能为空。
  final List<Widget>? children;

  /// 按需构建页面；使用时必须同时提供正数 [itemCount]。
  final IndexedWidgetBuilder? itemBuilder;

  /// [itemBuilder] 模式下的页面数量。
  final int? itemCount;

  /// 外部控制器；未提供时组件会创建并自行释放内部控制器。
  final TSwiperController? controller;

  /// 当前实际展示页发生变化时触发。
  final ValueChanged<int>? onChanged;

  /// 是否循环滚动。
  final bool loop;

  /// 是否自动播放。
  final bool autoplay;

  /// 自动播放每次页面稳定后重新等待的完整间隔，必须大于零。
  final Duration autoplayInterval;

  /// 指示器形态；为空时从组件主题解析，最终默认为 [TSwiperPaginationVariant.dots]。
  final TSwiperPaginationVariant? pagination;

  /// 指示器位置；为空时从组件主题解析，最终默认为覆盖在轮播内容上。
  final TSwiperPaginationPlacement? paginationPlacement;

  /// 指示器对齐；横向默认底部居中，竖向默认右侧居中。
  ///
  /// 覆盖模式下控制指示器在轮播内容中的位置；外置模式下控制指示器
  /// 在下方或右侧外部区域内的对齐。
  final AlignmentGeometry? paginationAlignment;

  /// 自定义 dots 和 dotsBar 的单个标记。
  ///
  /// 组件仍负责排列、间距、选中语义和业务下标更新。
  final TSwiperPaginationItemBuilder? paginationItemBuilder;

  /// previous 控制按钮的自定义图标。
  ///
  /// 仅替换图标内容；点击热区、禁用状态、Tooltip 和切页行为仍由组件管理。
  final Widget? previousIcon;

  /// next 控制按钮的自定义图标。
  ///
  /// 仅替换图标内容；点击热区、禁用状态、Tooltip 和切页行为仍由组件管理。
  final Widget? nextIcon;

  /// 页面视觉效果；为空时从组件主题解析。
  final TSwiperPageEffect? pageEffect;

  /// 每个页面占视口主轴的比例，必须大于零。
  final double viewportFraction;

  /// 页面滚动方向。
  final Axis scrollDirection;

  /// 页面视图使用的滚动物理效果。
  ///
  /// 未指定时使用 [PageView] 的默认物理效果。
  final ScrollPhysics? physics;

  /// 页面停止滚动时是否自动对齐到整页。
  final bool pageSnapping;

  /// 当 [viewportFraction] 小于 1 时，首尾页面是否保留端部留白。
  final bool padEnds;

  /// 页面内容超出轮播边界时的裁剪方式。
  final Clip clipBehavior;

  /// 是否反转页面的视觉顺序和滚动方向。
  final bool reverse;

  /// 拖拽手势开始时的坐标解析方式。
  final DragStartBehavior dragStartBehavior;

  /// 是否允许无障碍服务请求将未显示的页面滚动到可见区域。
  final bool allowImplicitScrolling;

  int get _resolvedItemCount {
    final count = children?.length ?? itemCount!;
    if (count <= 0) {
      throw ArgumentError.value(count, 'itemCount', 'must be positive');
    }
    return count;
  }

  @override
  // Configuration validation must also run for const widget instances.
  // ignore: no_logic_in_create_state
  State<TSwiper> createState() {
    final count = _resolvedItemCount;
    if (autoplayInterval <= Duration.zero) {
      throw ArgumentError.value(
        autoplayInterval,
        'autoplayInterval',
        'must be positive',
      );
    }
    final initialIndex = controller?.initialIndex ?? 0;
    if (initialIndex >= count) {
      throw RangeError.range(
        initialIndex,
        0,
        count - 1,
        'controller.initialIndex',
      );
    }
    return _TSwiperState();
  }
}

class _TSwiperState extends State<TSwiper> with WidgetsBindingObserver {
  late TSwiperController _controller;
  late bool _ownsController;
  late PageController _pageController;
  Timer? _autoplayTimer;
  late int _itemCount;
  late int _rawPage;
  late int _index;
  bool _dragging = false;
  bool _animating = false;
  bool _tickerEnabled = true;
  bool _appActive = true;
  int _operationEpoch = 0;

  int get _count => widget._resolvedItemCount;
  int _normalize(int page) => page % _count;
  int _loopAnchor(int index) => _count * 1000 + index;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final lifecycleState = WidgetsBinding.instance.lifecycleState;
    _appActive =
        lifecycleState == null || lifecycleState == AppLifecycleState.resumed;
    _bindController(widget.controller);
    _itemCount = _count;
    _index = _controller.initialIndex;
    _rawPage = widget.loop ? _loopAnchor(_index) : _index;
    _controller._setIndex(_index);
    _pageController = _createPageController();
    _attachController();
  }

  PageController _createPageController() => PageController(
        initialPage: _rawPage,
        viewportFraction: widget.viewportFraction,
      );

  void _bindController(TSwiperController? external) {
    _ownsController = external == null;
    _controller = external ?? TSwiperController();
  }

  void _attachController() {
    _controller._attach(
      jumpTo: _jumpToIndex,
      animateTo: _animateToIndex,
      next: _next,
      previous: _previous,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tickerEnabled = TickerMode.of(context);
    _syncAutoplay();
  }

  @override
  void didUpdateWidget(TSwiper oldWidget) {
    super.didUpdateWidget(oldWidget);
    final itemCount = _count;
    if (widget.autoplayInterval <= Duration.zero) {
      throw ArgumentError.value(
        widget.autoplayInterval,
        'autoplayInterval',
        'must be positive',
      );
    }
    if (!identical(oldWidget.controller, widget.controller)) {
      if (widget.controller?.hasClients ?? false) {
        throw StateError('TSwiperController can only control one TSwiper.');
      }
      final initialIndex = widget.controller?.initialIndex ?? 0;
      if (initialIndex >= itemCount) {
        throw RangeError.range(
          initialIndex,
          0,
          itemCount - 1,
          'controller.initialIndex',
        );
      }
      _controller._detach();
      if (_ownsController) {
        _controller.dispose();
      }
      _bindController(widget.controller);
      final changed = initialIndex != _index;
      _index = initialIndex;
      _rawPage = widget.loop ? _loopAnchor(_index) : _index;
      _replacePageController();
      _controller._setIndex(_index);
      _attachController();
      if (changed) {
        _notifyChangedAfterFrame();
      }
    } else if (_itemCount != itemCount ||
        oldWidget.loop != widget.loop ||
        oldWidget.viewportFraction != widget.viewportFraction) {
      final nextIndex = _index.clamp(0, itemCount - 1);
      final changed = nextIndex != _index;
      _index = nextIndex;
      _rawPage = widget.loop ? _loopAnchor(_index) : _index;
      _replacePageController();
      _controller._setIndex(_index);
      if (changed) {
        _notifyChangedAfterFrame();
      }
    }
    _itemCount = itemCount;
    _syncAutoplay();
  }

  void _replacePageController() {
    _operationEpoch++;
    _animating = false;
    _dragging = false;
    _pageController.dispose();
    _pageController = _createPageController();
  }

  void _notifyChangedAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onChanged?.call(_index);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appActive = state == AppLifecycleState.resumed;
    _syncAutoplay();
  }

  void _syncAutoplay() {
    _autoplayTimer?.cancel();
    if (!mounted ||
        !widget.autoplay ||
        !_appActive ||
        !_tickerEnabled ||
        _dragging ||
        _animating ||
        _count < 2 ||
        (!widget.loop && _index == _count - 1)) {
      return;
    }
    _autoplayTimer = Timer(widget.autoplayInterval, () {
      if (mounted) {
        unawaited(_next(kThemeAnimationDuration, Curves.easeInOut));
      }
    });
  }

  int _clampIndex(int index) =>
      widget.loop ? index % _count : index.clamp(0, _count - 1);

  void _jumpToIndex(int index) {
    final target = _clampIndex(index);
    final targetRaw =
        widget.loop ? _rawPage - _normalize(_rawPage) + target : target;
    _operationEpoch++;
    _animating = false;
    _autoplayTimer?.cancel();
    _pageController.jumpToPage(targetRaw);
    _syncAutoplay();
  }

  Future<void> _animateToIndex(
    int index,
    Duration duration,
    Curve curve,
  ) async {
    final target = _clampIndex(index);
    final targetRaw =
        widget.loop ? _rawPage + ((target - _index) % _count) : target;
    await _animateRaw(targetRaw, duration, curve);
  }

  Future<void> _next(Duration duration, Curve curve) async {
    if (!widget.loop && _index == _count - 1) {
      _syncAutoplay();
      return;
    }
    await _animateRaw(_rawPage + 1, duration, curve);
  }

  Future<void> _previous(Duration duration, Curve curve) async {
    if (!widget.loop && _index == 0) {
      _syncAutoplay();
      return;
    }
    await _animateRaw(_rawPage - 1, duration, curve);
  }

  Future<void> _animateRaw(
    int target,
    Duration duration,
    Curve curve,
  ) async {
    if (!_pageController.hasClients || target == _rawPage) {
      _syncAutoplay();
      return;
    }
    final epoch = ++_operationEpoch;
    _animating = true;
    _syncAutoplay();
    try {
      await _pageController.animateToPage(
        target,
        duration: duration,
        curve: curve,
      );
    } finally {
      if (mounted && epoch == _operationEpoch) {
        _animating = false;
        _syncAutoplay();
      }
    }
  }

  void _handlePageChanged(int page) {
    _rawPage = page;
    final next = _normalize(page);
    if (_index == next) {
      return;
    }
    setState(() {
      _index = next;
    });
    _controller._setIndex(next);
    widget.onChanged?.call(next);
    _syncAutoplay();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification &&
        notification.dragDetails != null) {
      _dragging = true;
      _syncAutoplay();
    } else if (notification is ScrollEndNotification) {
      _dragging = false;
      _syncAutoplay();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TSwiperThemeData>();
    final pagination =
        widget.pagination ?? theme?.pagination ?? TSwiperPaginationVariant.dots;
    final paginationPlacement = widget.paginationPlacement ??
        theme?.paginationPlacement ??
        TSwiperPaginationPlacement.overlay;
    final effect =
        widget.pageEffect ?? theme?.pageEffect ?? TSwiperPageEffect.none;
    final alignment = widget.paginationAlignment ??
        theme?.paginationAlignment ??
        (widget.scrollDirection == Axis.horizontal
            ? Alignment.bottomCenter
            : Alignment.centerRight);
    final pageView = NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.loop ? null : _count,
        onPageChanged: _handlePageChanged,
        scrollDirection: widget.scrollDirection,
        physics: widget.physics,
        pageSnapping: widget.pageSnapping,
        padEnds: widget.padEnds,
        clipBehavior: widget.clipBehavior,
        reverse: widget.reverse,
        dragStartBehavior: widget.dragStartBehavior,
        allowImplicitScrolling: widget.allowImplicitScrolling,
        itemBuilder: (context, page) => _buildPage(context, page, effect),
      ),
    );

    if (pagination == TSwiperPaginationVariant.none || _count < 2) {
      return pageView;
    }
    final paginationWidget = Align(
      alignment: alignment,
      child: Padding(
        padding: theme?.paginationMargin ?? const EdgeInsets.all(10),
        child: _buildPagination(context, pagination, theme),
      ),
    );
    if (paginationPlacement == TSwiperPaginationPlacement.outside) {
      return Flex(
        direction: widget.scrollDirection == Axis.horizontal
            ? Axis.vertical
            : Axis.horizontal,
        children: [
          Expanded(child: pageView),
          paginationWidget,
        ],
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [pageView, paginationWidget],
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
      animation: _pageController,
      child: child,
      builder: (context, child) {
        final current = _pageController.hasClients
            ? _pageController.page ?? _pageController.initialPage.toDouble()
            : _pageController.initialPage.toDouble();
        final distance = (current - page).abs().clamp(0.0, 1.0);
        switch (effect) {
          case TSwiperPageEffect.none:
            return child!;
          case TSwiperPageEffect.cardMargin:
            final padding = 6 + distance * 6;
            return Padding(
              padding: widget.scrollDirection == Axis.horizontal
                  ? EdgeInsets.symmetric(horizontal: padding)
                  : EdgeInsets.symmetric(vertical: padding),
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
    final activeExtent = theme?.activeDotExtent ?? 20;
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = widget.scrollDirection == Axis.horizontal
            ? constraints.maxWidth
            : constraints.maxHeight;
        final required =
            (_count - 1) * size + activeExtent + _count * spacing * 2;
        if (widget.paginationItemBuilder == null &&
            available.isFinite &&
            required > available) {
          return _buildFraction(context, theme);
        }
        final dots = Flex(
          direction: widget.scrollDirection,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < _count; index++)
              Semantics(
                label: '${index + 1} / $_count',
                selected: index == _index,
                excludeSemantics: true,
                child: Padding(
                  key: ValueKey('swiper-dot-$index'),
                  padding: widget.scrollDirection == Axis.horizontal
                      ? EdgeInsets.symmetric(horizontal: spacing)
                      : EdgeInsets.symmetric(vertical: spacing),
                  child: widget.paginationItemBuilder?.call(
                        context,
                        TSwiperPaginationItemDetails(
                          index: index,
                          currentIndex: _index,
                          itemCount: _count,
                          axis: widget.scrollDirection,
                        ),
                      ) ??
                      AnimatedContainer(
                        duration: kThemeAnimationDuration,
                        width: widget.scrollDirection == Axis.horizontal &&
                                index == _index &&
                                variant == TSwiperPaginationVariant.dotsBar
                            ? activeExtent
                            : size,
                        height: widget.scrollDirection == Axis.vertical &&
                                index == _index &&
                                variant == TSwiperPaginationVariant.dotsBar
                            ? activeExtent
                            : size,
                        decoration: BoxDecoration(
                          color: index == _index
                              ? theme?.activeColor ??
                                  context.tTheme.brandNormalColor
                              : theme?.inactiveColor ??
                                  context.tTheme.bgColorComponentHover,
                          borderRadius: BorderRadius.circular(size / 2),
                        ),
                      ),
                ),
              ),
          ],
        );
        if (widget.paginationItemBuilder != null) {
          return FittedBox(fit: BoxFit.scaleDown, child: dots);
        }
        return dots;
      },
    );
  }

  Widget _buildFraction(BuildContext context, TSwiperThemeData? theme) {
    final tokenFont = context.tTheme.fontBodySmall;
    final defaultStyle = TextStyle(
      color: context.tTheme.textColorAnti,
      fontSize: tokenFont?.size ?? 12,
      height: tokenFont?.height,
      fontWeight: tokenFont?.fontWeight,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme?.fractionBackgroundColor ??
            context.tTheme.textColorPlaceholder,
        borderRadius: BorderRadius.circular(context.tTheme.radiusRound),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          '${_index + 1}/$_count',
          style: defaultStyle.merge(theme?.fractionStyle),
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context, TSwiperThemeData? theme) {
    final canGoBack = widget.loop || _index > 0;
    final canGoForward = widget.loop || _index < _count - 1;
    final localizations = MaterialLocalizations.of(context);
    var forwardIsPositive = !widget.reverse;
    if (widget.scrollDirection == Axis.horizontal &&
        Directionality.of(context) == TextDirection.rtl) {
      forwardIsPositive = !forwardIsPositive;
    }
    final previousIcon = widget.scrollDirection == Axis.horizontal
        ? (forwardIsPositive ? Icons.chevron_left : Icons.chevron_right)
        : (forwardIsPositive
            ? Icons.keyboard_arrow_up
            : Icons.keyboard_arrow_down);
    final nextIcon = widget.scrollDirection == Axis.horizontal
        ? (forwardIsPositive ? Icons.chevron_right : Icons.chevron_left)
        : (forwardIsPositive
            ? Icons.keyboard_arrow_down
            : Icons.keyboard_arrow_up);
    final fallbackStyle = IconButton.styleFrom(
      backgroundColor: context.tTheme.textColorPlaceholder,
      foregroundColor: context.tTheme.textColorAnti,
      disabledBackgroundColor:
          context.tTheme.textColorPlaceholder.withValues(alpha: 0.35),
      disabledForegroundColor:
          context.tTheme.textColorAnti.withValues(alpha: 0.55),
      minimumSize: const Size.square(32),
      tapTargetSize: MaterialTapTargetSize.padded,
      padding: EdgeInsets.zero,
    );
    final style = fallbackStyle
        .merge(IconButtonTheme.of(context).style)
        .merge(theme?.controlStyle);
    return SizedBox(
      width: widget.scrollDirection == Axis.horizontal ? double.infinity : null,
      height: widget.scrollDirection == Axis.vertical ? double.infinity : null,
      child: Flex(
        direction: widget.scrollDirection,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            tooltip: localizations.previousPageTooltip,
            onPressed: canGoBack
                ? () => unawaited(
                      _previous(kThemeAnimationDuration, Curves.easeInOut),
                    )
                : null,
            style: style,
            iconSize: theme?.controlIconSize ?? 18,
            icon: widget.previousIcon ?? Icon(previousIcon),
          ),
          IconButton(
            tooltip: localizations.nextPageTooltip,
            onPressed: canGoForward
                ? () => unawaited(
                      _next(kThemeAnimationDuration, Curves.easeInOut),
                    )
                : null,
            style: style,
            iconSize: theme?.controlIconSize ?? 18,
            icon: widget.nextIcon ?? Icon(nextIcon),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _autoplayTimer?.cancel();
    _operationEpoch++;
    _controller._detach();
    if (_ownsController) {
      _controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }
}
