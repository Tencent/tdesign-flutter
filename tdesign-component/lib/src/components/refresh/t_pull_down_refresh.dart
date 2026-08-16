import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

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
  /// Key
  final Key? key;

  /// 必填：滚动内容（对应官方默认 slot）。
  final Widget child;

  /// 下拉触发刷新回调（对应官方 `refresh` 事件）。
  ///
  /// 为空时禁用下拉刷新。返回的 Future 完成后自动展示完成态并复位；
  /// 也可通过 [controller] 接管完成时机。
  final FutureOr<void> Function()? onRefresh;

  /// 触底加载回调（对应官方 `scrolltolower` 事件）。
  ///
  /// 仅在 [enableLoadMore] 为 true 且本参数非空时启用。
  final FutureOr<void> Function()? onLoadMore;

  /// 是否启用触底加载（默认 false）。
  final bool enableLoadMore;

  /// 是否禁用下拉刷新（默认 false；禁用后仍保留滚动）。
  final bool disabled;

  /// 受控刷新 / 加载控制器。
  ///
  /// 通过 [TPullDownRefreshController.refresh] 等外部触发 / 结束刷新。
  final TPullDownRefreshController? controller;

  /// 四态提示语；为空时回退 l10n（默认中文与官方 `loadingTexts` 一致）。
  final TPullDownRefreshTexts? texts;

  /// 刷新超时时长；超过时长仍未完成 [onRefresh] 时触发 [onTimeout] 并结束刷新。
  ///
  /// 为空时不启用超时（默认行为与现状一致）。
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
  final ValueChanged<TPullDownRefreshState>? onStateChanged;

  /// 构造 [TPullDownRefresh]。
  const TPullDownRefresh({
    this.key,
    required this.child,
    this.onRefresh,
    this.onLoadMore,
    this.enableLoadMore = false,
    this.disabled = false,
    this.controller,
    this.texts,
    this.refreshTimeout,
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

  void _handleStateChanged(TPullDownRefreshState state) {
    widget.onStateChanged?.call(state);
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
        _easyController?.finishRefresh(force: true);
      });
    }
    final result = widget.onRefresh?.call();
    final future = result is Future ? result : null;
    if (future != null) {
      return future.whenComplete(() {
        _timeoutTimer?.cancel();
        _handleStateChanged(TPullDownRefreshState.done);
      });
    }
    // 同步返回：视为立即完成。
    _timeoutTimer?.cancel();
    _handleStateChanged(TPullDownRefreshState.done);
    return result;
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
    final mode = state.mode;
    final stateType = _toState(mode);
    onStateChanged?.call(stateType);

    final showLoading = mode == IndicatorMode.processing;
    final showComplete = mode == IndicatorMode.processed ||
        mode == IndicatorMode.done;
    final showText = !showLoading && !showComplete;

    String text;
    if (showLoading) {
      text = texts.refreshing;
    } else if (showComplete) {
      text = texts.refreshComplete;
    } else if (mode == IndicatorMode.ready || mode == IndicatorMode.armed) {
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
