import 'dart:math';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';

/// TDesign刷新头部
/// 结合EasyRefresh类实现下拉刷新,继承自Header类，字段含义与父类一致
class TDRefreshHeader extends Header {
  TDRefreshHeader({
    this.key,
    this.extent = 48.0,
    double? triggerOffset,
    this.triggerDistance = 48.0,
    bool? clamping,
    this.float = false,
    Duration? processedDuration,
    this.completeDuration,
    bool? hapticFeedback,
    this.enableHapticFeedback = true,
    this.infiniteOffset,
    this.enableInfiniteRefresh = false,
    bool? infiniteHitOver,
    this.overScroll = true,
    this.loadingIcon = TDLoadingIcon.circle,
    this.backgroundColor,
    super.spring,
    super.horizontalSpring,
    super.readySpringBuilder,
    super.horizontalReadySpringBuilder,
    super.springRebound,
    super.frictionFactor,
    super.horizontalFrictionFactor,
    super.safeArea = false,
    super.hitOver,
    super.position,
    super.secondaryTriggerOffset,
    super.secondaryVelocity,
    super.secondaryDimension,
    super.secondaryCloseTriggerOffset,
    super.notifyWhenInvisible,
    super.listenable,
    super.triggerWhenReach,
    super.triggerWhenRelease,
    super.triggerWhenReleaseNoWait,
    super.maxOverOffset,
  })  : assert((triggerOffset ?? triggerDistance) > 0.0),
        assert(extent != null && extent >= 0.0),
        assert(
            extent != null && ((clamping ?? float) || (triggerOffset ?? triggerDistance) >= extent),
            'The refresh indicator cannot take more space in its final state '
            'than the amount initially created by overscrolling.'),
        super(
          triggerOffset: triggerOffset ?? triggerDistance,
          clamping: clamping ?? float,
          processedDuration: processedDuration ?? completeDuration ?? const Duration(seconds: 1),
          hapticFeedback: hapticFeedback ?? enableHapticFeedback,
          infiniteOffset: enableInfiniteRefresh ? infiniteOffset : null,
          infiniteHitOver: infiniteHitOver ?? overScroll,
        );

  /// Key
  final Key? key;

  /// loading样式
  final TDLoadingIcon loadingIcon;

  /// 背景颜色
  final Color? backgroundColor;

  /// Header容器高度
  final double? extent;

  /// 触发刷新任务的偏移量，同[triggerOffset]
  final double triggerDistance;

  /// 是否悬浮
  final bool float;

  /// 完成延时
  final Duration? completeDuration;

  /// 开启震动反馈
  final bool enableHapticFeedback;

  /// 是否开启无限刷新
  final bool enableInfiniteRefresh;

  /// 无限刷新偏移量
  @override
  final double? infiniteOffset;

  /// 越界滚动([enableInfiniteRefresh]为true或[infiniteOffset]有值时生效)
  final bool overScroll;

  @override
  Widget build(BuildContext context, IndicatorState state) {
    // 不能为水平方向
    assert(
      state.axisDirection == AxisDirection.down || state.axisDirection == AxisDirection.up,
      'Widget cannot be horizontal',
    );
    return TGIconHeaderWidget(
      key: key,
      loadingIcon: loadingIcon,
      backgroundColor: backgroundColor,
      state: state,
      refreshIndicatorExtent: extent ?? state.triggerOffset,
    );
  }
}

/// 刷新头部组件
class TGIconHeaderWidget extends StatefulWidget {
  /// loading样式
  final TDLoadingIcon loadingIcon;

  /// 背景颜色
  final Color? backgroundColor;

  /// Indicator properties and state.
  final IndicatorState state;

  /// header高度
  final double refreshIndicatorExtent;

  const TGIconHeaderWidget({
    Key? key,
    this.backgroundColor,
    required this.state,
    required this.refreshIndicatorExtent,
    required this.loadingIcon,
  }) : super(key: key);

  @override
  TGIconHeaderWidgetState createState() {
    return TGIconHeaderWidgetState();
  }
}

class TGIconHeaderWidgetState extends State<TGIconHeaderWidget> with TickerProviderStateMixin {
  IndicatorMode get _refreshState => widget.state.mode;
  double get _offset => widget.state.offset;
  double get _actualTriggerOffset => widget.state.actualTriggerOffset;
  bool get _reverse => widget.state.reverse;
  double get _safeOffset => widget.state.safeOffset;

  Widget _buildLoading() => TDLoading(
        size: TDLoadingSize.medium,
        icon: widget.loadingIcon,
        iconColor: TDTheme.of(context).brandNormalColor,
        axis: Axis.horizontal,
        text: context.resource.refreshing,
        textColor: TDTheme.of(context).fontGyColor3,
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _offset,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: _offset < _actualTriggerOffset
                ? -(_actualTriggerOffset - _offset + (_reverse ? _safeOffset : -_safeOffset)) / 2
                : (!_reverse ? _safeOffset : 0),
            bottom: _offset < _actualTriggerOffset ? null : (_reverse ? _safeOffset : 0),
            height: _offset < _actualTriggerOffset ? _actualTriggerOffset : null,
            child: Container(
              alignment: Alignment.center,
              height: widget.refreshIndicatorExtent,
              color: widget.backgroundColor,
              child: Visibility(
                child: Container(
                  child: _buildLoading(),
                ),
                visible: _refreshState == IndicatorMode.processing || _refreshState == IndicatorMode.ready,
                replacement: Visibility(
                  visible: _refreshState != IndicatorMode.inactive,
                  child: TDText(
                    _refreshState == IndicatorMode.drag
                        ? context.resource.pullToRefresh
                        : _refreshState == IndicatorMode.processed || _refreshState == IndicatorMode.done
                            ? context.resource.completeRefresh
                            : context.resource.releaseRefresh,
                    font: TDTheme.of(context).fontBodyMedium,
                    textColor: TDTheme.of(context).fontGyColor3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
