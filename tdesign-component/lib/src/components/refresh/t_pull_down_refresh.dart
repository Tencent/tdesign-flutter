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
/// 下拉 → 松手 → 刷新 → 完成四态，支持触底加载、禁用、超时、
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
  /// 若内容自身不可滚动，请用 `SizedBox` 等为其指定固定高度。
  final Widget child;

  /// 下拉触发刷新回调（对应官方 `refresh` 事件）。
  ///
  /// 为空时禁用下拉刷新。返回的 Future 完成后自动展示完成态并复位；
  /// 也可通过 [controller] 接管完成时机。
  ///
  /// 若回调同步抛错或返回的 Future 失败，刷新任务会**正常结束（不悬挂）**，
  /// 错误通过 `FlutterError.reportError` 上报（不吞掉），但不会作为未捕获异常
  /// 中断 easy_refresh 的动画流程。若需在失败时做业务处理，请在回调内部自行
  /// try/catch。
  final FutureOr<void> Function()? onRefresh;

  /// 触底加载回调（对应官方 `scrolltolower` 事件）。
  ///
  /// 仅在 [enableLoadMore] 为 true 且本参数非空时启用。启用后会展示
  /// 一个与组件职责相符的可见 footer（加载指示器），滚动到底时触发。
  /// 同 [onRefresh]，回调抛错 / Future 失败时不悬挂加载、错误经
  /// `FlutterError.reportError` 上报。

  /// 是否启用触底加载（默认 false）。
  ///
  /// 置为 true 且 [onLoadMore] 非空时，滚动容器触底会触发加载，并展示
  /// 加载中的 footer 指示器。加载结束可通过 [controller] 或返回 Future。
  final bool enableLoadMore;

  /// 是否禁用下拉刷新（默认 false；禁用后仍保留滚动）。
  final bool disabled;

  /// 受控刷新 / 加载控制器。
  ///
  /// 通过 [TPullDownRefreshController.refresh] 等外部触发 / 结束刷新。
  /// 其生命周期由本组件独占管理：底层 [EasyRefreshController] 由 State
  /// 创建并释放，外部控制器仅持有引用，不应重复 dispose（详见
  /// [TPullDownRefreshController] 文档）。
  final TPullDownRefreshController? controller;

  /// 四态提示语；为空时回退 l10n（默认中文与官方 `loadingTexts` 一致）。
  final TPullDownRefreshTexts? texts;

  /// 刷新超时时长（**默认 3 秒**）；超过时长仍未完成 [onRefresh] 时自动结束刷新，
  /// 并触发 [onTimeout]（可为空）。
  ///
  /// 默认启用 3 秒超时；传入 `null` 可关闭超时。
  /// `timeout` 状态仅在超时瞬间上报一次，随后立即结束刷新并复位，无专属渲染文案。
  final Duration? refreshTimeout;

  /// 刷新超时回调。
  final VoidCallback? onTimeout;

  /// Header 容器高度 = 触发阈值（默认 50，对齐官方 `loadingBarHeight`）。
  final double loadingBarHeight;

  /// 最大下拉高度（默认 80，对齐官方 `maxBarHeight`）。
  final double maxBarHeight;

  /// loading 指示器样式（对应官方 `loadingProps`）。
  final TLoadingThemeData? loadingTheme;

  /// Header 背景色。
  final Color? backgroundColor;

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
    this.enableLoadMore = false,
    this.disabled = false,
    this.controller,
    this.texts,
    this.refreshTimeout = const Duration(milliseconds: 3000),
    this.onTimeout,
    this.loadingBarHeight = 50,
    this.maxBarHeight = 80,
    this.loadingTheme,
    this.backgroundColor,
    this.onStateChanged,
  });

  @override
  State<TPullDownRefresh> createState() => _TPullDownRefreshState();
}

class _TPullDownRefreshState extends State<TPullDownRefresh> {
  EasyRefreshController? _easyController;
  Timer? _timeoutTimer;
  TPullDownRefreshState? _lastReportedState;

  bool get _refreshEnabled =>
      widget.onRefresh != null && !widget.disabled;

  bool get _loadMoreEnabled =>
      widget.onLoadMore != null && widget.enableLoadMore;

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
        widget.onTimeout?.call();
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
    FlutterError.reportError(FlutterErrorDetails(
      exception: e,
      stack: st,
      library: 'TPullDownRefresh',
      context: ErrorDescription('下拉刷新回调 onRefresh 执行失败'),
    ));
  }

  FutureOr<void> _handleLoadMore() {
    final result = widget.onLoadMore?.call();
    final future = result is Future ? result : null;
    if (future != null) {
      return future;
    }
    return result;
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
        ? _TPullDownRefreshFooter(
            texts: _effectiveTexts(context),
            loadingTheme: widget.loadingTheme,
            backgroundColor: widget.backgroundColor,
          )
        : null;
    return EasyRefresh(
      controller: _easyController,
      header: _refreshEnabled
          ? _TPullDownRefreshHeader(
              extent: widget.loadingBarHeight,
              triggerDistance: widget.loadingBarHeight,
              maxOverOffset: widget.maxBarHeight,
              texts: _effectiveTexts(context),
              loadingTheme: widget.loadingTheme,
              backgroundColor: widget.backgroundColor,
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
  final TLoadingThemeData? loadingTheme;
  final Color? backgroundColor;
  final ValueChanged<TPullDownRefreshState>? onStateChanged;

  _TPullDownRefreshHeader({
    required double extent,
    required double triggerDistance,
    required double maxOverOffset,
    required this.texts,
    this.loadingTheme,
    this.backgroundColor,
    this.onStateChanged,
  })  : _extent = extent,
        assert(triggerDistance > 0),
        assert(extent >= 0),
        assert(maxOverOffset >= triggerDistance),
        super(
          triggerOffset: triggerDistance,
          clamping: true,
          processedDuration: const Duration(milliseconds: 500),
          maxOverOffset: maxOverOffset,
        );

  @override
  Widget build(BuildContext context, IndicatorState state) {
    final stateType = _toState(state.mode);
    // 状态上报在 State 中统一去重 + 异步调度。
    onStateChanged?.call(stateType);

    final showLoading = state.mode == IndicatorMode.processing;
    final showComplete = state.mode == IndicatorMode.processed ||
        state.mode == IndicatorMode.done;
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
        color: backgroundColor,
        child: showLoading
            ? Theme(
                data: Theme.of(context).mergeExtension(
                  loadingTheme ??
                      TLoadingThemeData(
                        iconColor: context.tTheme.brandNormalColor,
                        axis: Axis.horizontal,
                        textColor: context.tTheme.textColorPlaceholder,
                      ),
                ),
                child: TLoading(
                  size: TLoadingSize.medium,
                  text: text,
                ),
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

/// TDesign 下拉刷新 Footer（内部实现）：触底加载指示器。
class _TPullDownRefreshFooter extends Footer {
  final TPullDownRefreshTexts texts;
  final TLoadingThemeData? loadingTheme;
  final Color? backgroundColor;

  _TPullDownRefreshFooter({
    required this.texts,
    this.loadingTheme,
    this.backgroundColor,
  }) : super(
        // Footer 默认 infiniteOffset=0（非 null），而 Indicator 断言
        // `infiniteOffset == null || !clamping`，故触底加载 Footer 不能开启
        // clamping，必须置 false，否则运行期抛「Cannot scroll indefinitely when clamping」。
        triggerOffset: 50,
        clamping: false,
      );

  @override
  Widget build(BuildContext context, IndicatorState state) {
    final loading = state.mode == IndicatorMode.processing ||
        state.mode == IndicatorMode.armed ||
        state.mode == IndicatorMode.ready;
    final noMore = state.mode == IndicatorMode.done;

    Widget child;
    if (loading) {
      child = Theme(
        data: Theme.of(context).mergeExtension(
          loadingTheme ??
              TLoadingThemeData(
                iconColor: context.tTheme.brandNormalColor,
                axis: Axis.horizontal,
                textColor: context.tTheme.textColorPlaceholder,
              ),
        ),
        child: TLoading(
          size: TLoadingSize.medium,
          text: texts.refreshing,
        ),
      );
    } else if (noMore) {
      child = TText(
        texts.refreshComplete,
        font: context.tTheme.fontBodyMedium,
        textColor: context.tTheme.textColorPlaceholder,
      );
    } else {
      child = TText(
        texts.pullToRefresh,
        font: context.tTheme.fontBodyMedium,
        textColor: context.tTheme.textColorPlaceholder,
      );
    }

    return Container(
      alignment: Alignment.center,
      height: 50,
      color: backgroundColor,
      child: child,
    );
  }
}
