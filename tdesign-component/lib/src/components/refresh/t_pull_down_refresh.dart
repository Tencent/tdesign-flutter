import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../loading/t_loading.dart';
import '../loading/t_loading_theme_data.dart';
import '../text/t_text.dart';
import 't_pull_down_refresh_controller.dart';
import 't_pull_down_refresh_texts.dart';

/// TDesign 下拉刷新组件。
///
/// 以**最小、Flutter 惯用**的 API 封装 [EasyRefresh]，对齐官方
/// （小程序 / mobile-vue）PullDownRefresh 的行为表现：
/// 下拉 → 松手 → 刷新 → 完成四态，支持触底加载、超时、
/// 四态文案自定义与受控刷新。
///
/// 典型用法：
/// ```dart
/// TPullDownRefresh(
///   onRefresh: () async {
///     await _fetchData();
///   },
///   child: ListView.builder(...),
/// )
/// ```
class TPullDownRefresh extends StatefulWidget {
  /// 必填：滚动内容（对应官方默认 slot）。
  ///
  /// 必须为**有界、可滚动**的内容（如 `ListView` / `GridView` / `CustomScrollView`）。
  /// 若内容自身不可滚动，请用 `SizedBox` 等为其指定固定高度，否则下拉 / 触底
  /// 手势无法生效。
  final Widget child;

  /// 下拉触发刷新回调（对应官方 `refresh` 事件）。
  ///
  /// 为空时禁用下拉刷新。返回的 Future 完成后自动展示完成态并复位。
  ///
  /// 若回调同步抛错或返回的 Future 失败，刷新任务会**正常结束（不悬挂）**，
  /// 错误通过 `FlutterError.reportError` 上报（不吞掉），但不会作为未捕获异常
  /// 中断 easy_refresh 的动画流程。若需在失败时做业务处理，请在回调内部自行
  /// try/catch。
  final FutureOr<void> Function()? onRefresh;

  /// 触底加载回调（对应官方 `scrolltolower` 事件）。
  ///
  /// 非空时自动启用，触底达到 [lowerThreshold] 时触发；Footer 本身不增加
  /// TDesign 未定义的可见样式。
  ///
  /// 返回的 `Future` 完成后自动结束加载态。与 [onRefresh] 一致，本回调若同步
  /// 抛错或返回的 `Future` 失败，
  /// 加载任务会**正常结束（不悬挂）**，错误经 `FlutterError.reportError` 上报
  /// （不吞掉）。若需在失败时做业务处理，请在回调内部自行 try/catch。
  final FutureOr<void> Function()? onLoadMore;

  /// 距离底部多少逻辑像素时触发加载（默认 50，对齐官方 `lowerThreshold`）。
  final double lowerThreshold;

  /// 外部主动刷新控制器。
  ///
  /// 通过 [TPullDownRefreshController.refresh] 从页面外部触发刷新。刷新完成时机
  /// 始终由 [onRefresh] 返回的 Future 决定。
  /// 底层 [EasyRefreshController] 由 State 创建并释放；外部控制器仅持有引用，
  /// 无需也不能重复 dispose（详见 [TPullDownRefreshController] 文档）。
  final TPullDownRefreshController? controller;

  /// 四态提示语；为空时回退 l10n（默认中文与官方 `loadingTexts` 一致）。
  final TPullDownRefreshTexts? texts;

  /// 刷新超时时长（**默认 3 秒**）；超过时长仍未完成 [onRefresh] 时自动结束刷新，
  /// 并通过 [onStateChanged] 上报 [TPullDownRefreshState.timeout]。
  ///
  /// 默认启用 3 秒超时；传入 `null` 可关闭超时。
  /// `timeout` 状态仅在超时瞬间上报一次，随后立即结束刷新并复位，无专属渲染文案。
  final Duration? refreshTimeout;

  /// Header 容器高度 = 触发阈值（默认 50，对齐官方 `loadingBarHeight`）。
  final double loadingBarHeight;

  /// 最大下拉高度（默认 80，对齐官方 `maxBarHeight`）。
  final double maxBarHeight;

  /// 刷新完成提示的展示时长（默认 500ms，对齐官方 `successDuration`）。
  final Duration successDuration;

  /// 刷新状态变化回调（对应官方 `change`/`onChange` 事件）。
  ///
  /// 值域为 [TPullDownRefreshState]。仅在状态**跳变**时回调（已去重），
  /// 且通过异步调度触发，**不会**在 build 期间同步调用，可在回调中安全
  /// `setState`。
  final ValueChanged<TPullDownRefreshState>? onStateChanged;

  /// 构造 [TPullDownRefresh]。
  const TPullDownRefresh({
    super.key,
    required this.child,
    this.onRefresh,
    this.onLoadMore,
    this.lowerThreshold = 50,
    this.controller,
    this.texts,
    this.refreshTimeout = const Duration(milliseconds: 3000),
    this.loadingBarHeight = 50,
    this.maxBarHeight = 80,
    this.successDuration = const Duration(milliseconds: 500),
    this.onStateChanged,
  }) : assert(lowerThreshold > 0);

  @override
  State<TPullDownRefresh> createState() => _TPullDownRefreshState();
}

class _TPullDownRefreshState extends State<TPullDownRefresh> {
  EasyRefreshController? _easyController;
  Timer? _timeoutTimer;
  TPullDownRefreshState? _lastReportedState;

  bool get _refreshEnabled => widget.onRefresh != null;

  bool get _loadMoreEnabled => widget.onLoadMore != null;

  @override
  void initState() {
    super.initState();
    _easyController = EasyRefreshController();
    widget.controller?.bind(_easyController!);
  }

  @override
  void didUpdateWidget(TPullDownRefresh oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.unbind();
      widget.controller?.bind(_easyController!);
    }
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    widget.controller?.unbind();
    _easyController?.dispose();
    super.dispose();
  }

  /// 上报状态变化：去重 + 异步调度，避免 build 期同步回调与重复上报。
  void _handleStateChanged(TPullDownRefreshState state) {
    if (_lastReportedState == state) {
      return;
    }
    _lastReportedState = state;
    final cb = widget.onStateChanged;
    if (cb == null) {
      return;
    }
    // 异步调度，避免在 build / 布局期间同步触发回调（防止 setState 报错）。
    scheduleMicrotask(() {
      if (mounted) {
        cb(state);
      }
    });
  }

  void _finishRefreshAndReport() {
    _timeoutTimer?.cancel();
    if (mounted) {
      _handleStateChanged(TPullDownRefreshState.done);
    }
  }

  FutureOr<void> _handleRefresh() {
    final timeout = widget.refreshTimeout;
    if (timeout != null) {
      _timeoutTimer?.cancel();
      _timeoutTimer = Timer(timeout, () {
        if (!mounted) {
          return;
        }
        _handleStateChanged(TPullDownRefreshState.timeout);
        _easyController?.finishRefresh(IndicatorResult.success, true);
      });
    }
    try {
      final result = widget.onRefresh?.call();
      final future = result is Future ? result : null;
      if (future != null) {
        // Future 成功 / 失败都会结束刷新（whenComplete）；失败时通过
        // FlutterError.reportError 上报（不吞掉、不悬挂），避免作为未捕获异常
        // 中断 easy_refresh 的动画流程。
        return future.then<void>(
          (_) => _finishRefreshAndReport(),
          onError: (Object e, StackTrace st) {
            _finishRefreshAndReport();
            _reportRefreshError(e, st);
            return null;
          },
        );
      }
      // 同步返回：视为立即完成。
      _finishRefreshAndReport();
      return result;
    } catch (e, st) {
      // 同步抛错：结束刷新避免悬挂，并通过 FlutterError.reportError 上报。
      _finishRefreshAndReport();
      _reportRefreshError(e, st);
      return null;
    }
  }

  void _reportRefreshError(Object e, StackTrace st) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: e,
        stack: st,
        library: 'TPullDownRefresh',
        context: ErrorDescription('下拉刷新回调 onRefresh 执行失败'),
      ),
    );
  }

  void _reportLoadMoreError(Object e, StackTrace st) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: e,
        stack: st,
        library: 'TPullDownRefresh',
        context: ErrorDescription('触底加载回调 onLoadMore 执行失败'),
      ),
    );
  }

  /// 处理触底加载回调，与 [_handleRefresh] 一致地保证：
  /// 回调抛错 / Future 失败时**不悬挂**加载任务，且错误经
  /// `FlutterError.reportError` 上报（不吞掉，也不作为未捕获异常
  /// 中断 easy_refresh 的动画流程）。
  FutureOr<void> _handleLoadMore() {
    try {
      final result = widget.onLoadMore?.call();
      final future = result is Future ? result : null;
      if (future != null) {
        // Future 失败时经 FlutterError.reportError 上报，不悬挂加载。
        return future.then<void>(
          (_) {},
          onError: (Object e, StackTrace st) {
            _reportLoadMoreError(e, st);
            return null;
          },
        );
      }
      // 同步返回：视为立即完成。
      return result;
    } catch (e, st) {
      // 同步抛错：上报错误，不悬挂加载。
      _reportLoadMoreError(e, st);
      return null;
    }
  }

  TPullDownRefreshTexts _effectiveTexts(BuildContext context) {
    final t = widget.texts;
    if (t != null) {
      return t;
    }
    final resource = context.resource;
    return TPullDownRefreshTexts(
      pullToRefresh: resource.pullToRefresh,
      releaseToRefresh: resource.releaseRefresh,
      refreshing: resource.refreshing,
      refreshComplete: resource.completeRefresh,
    );
  }

  @override
  Widget build(BuildContext context) {
    final footer = _loadMoreEnabled
        ? _TPullDownRefreshFooter(triggerOffset: widget.lowerThreshold)
        : null;
    return EasyRefresh(
      controller: _easyController,
      header: _refreshEnabled
          ? _TPullDownRefreshHeader(
              extent: widget.loadingBarHeight,
              triggerDistance: widget.loadingBarHeight,
              maxOverOffset: widget.maxBarHeight,
              successDuration: widget.successDuration,
              texts: _effectiveTexts(context),
              onStateChanged: _handleStateChanged,
            )
          : null,
      footer: footer,
      onRefresh: _refreshEnabled ? _handleRefresh : null,
      onLoad: _loadMoreEnabled ? _handleLoadMore : null,
      child: widget.child,
    );
  }
}

/// TDesign 下拉刷新 Header（内部实现）。
class _TPullDownRefreshHeader extends Header {
  final double _extent;
  final TPullDownRefreshTexts texts;
  final ValueChanged<TPullDownRefreshState>? onStateChanged;

  _TPullDownRefreshHeader({
    required double extent,
    required double triggerDistance,
    required double maxOverOffset,
    required Duration successDuration,
    required this.texts,
    this.onStateChanged,
  }) : _extent = extent,
       assert(triggerDistance > 0),
       assert(extent >= 0),
       assert(maxOverOffset >= triggerDistance),
       super(
         triggerOffset: triggerDistance,
         // 与小程序 Demo 一致：下拉时让 ScrollView 产生真实 overscroll，
         // 刷新头和页面内容一起向下移动。clamping=true 会把内容固定在原位，
         // 只在其上方绘制刷新头，不符合 PullDownRefresh 的交互表现。
         clamping: false,
         processedDuration: successDuration,
         maxOverOffset: maxOverOffset,
       );

  @override
  Widget build(BuildContext context, IndicatorState state) {
    final stateType = _toState(state.mode);
    // 状态上报在 State 中统一去重 + 异步调度。
    onStateChanged?.call(stateType);

    final showLoading = state.mode == IndicatorMode.processing;
    final showComplete =
        state.mode == IndicatorMode.processed ||
        state.mode == IndicatorMode.done;
    final inheritedLoadingTheme = Theme.of(
      context,
    ).extension<TLoadingThemeData>();
    String text;
    if (showLoading) {
      text = texts.refreshing;
    } else if (showComplete) {
      text = texts.refreshComplete;
    } else if (state.mode == IndicatorMode.ready ||
        state.mode == IndicatorMode.armed) {
      text = texts.releaseToRefresh;
    } else {
      text = texts.pullToRefresh;
    }

    return SizedBox(
      width: double.infinity,
      height: state.offset,
      child: Container(
        alignment: Alignment.center,
        height: _extent,
        color: context.tTheme.bgColorContainer,
        child: showLoading
            ? Theme(
                data: Theme.of(context).mergeExtension(
                  (inheritedLoadingTheme ?? const TLoadingThemeData()).copyWith(
                    axis: Axis.horizontal,
                  ),
                ),
                child: TLoading(size: TLoadingSize.medium, text: text),
              )
            : TText(
                text,
                font: context.tTheme.fontBodyMedium,
                textColor: context.tTheme.textColorPlaceholder,
              ),
      ),
    );
  }

  TPullDownRefreshState _toState(IndicatorMode mode) {
    switch (mode) {
      case IndicatorMode.inactive:
      case IndicatorMode.done:
        return TPullDownRefreshState.inactive;
      case IndicatorMode.drag:
        return TPullDownRefreshState.dragging;
      case IndicatorMode.armed:
      case IndicatorMode.ready:
        return TPullDownRefreshState.ready;
      case IndicatorMode.processing:
        return TPullDownRefreshState.refreshing;
      case IndicatorMode.processed:
        return TPullDownRefreshState.done;
      default:
        return TPullDownRefreshState.inactive;
    }
  }
}

/// 触底加载检测 Footer（内部实现）。
///
/// 小程序 `scrolltolower` 只提供事件，不定义可见 Footer，因此这里不绘制
/// loading/no-more 文案，避免引入跨端不存在的视觉表现。
class _TPullDownRefreshFooter extends Footer {
  _TPullDownRefreshFooter({required double triggerOffset})
    : super(
        // Footer 默认 infiniteOffset=0（非 null），而 Indicator 断言
        // `infiniteOffset == null || !clamping`，故触底加载 Footer 不能开启
        // clamping，必须置 false，否则运行期抛「Cannot scroll indefinitely when clamping」。
        triggerOffset: triggerOffset,
        clamping: false,
      );

  @override
  Widget build(BuildContext context, IndicatorState state) {
    return SizedBox(height: state.offset);
  }
}
