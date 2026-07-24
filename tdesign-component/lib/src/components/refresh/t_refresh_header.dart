import 'dart:math';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart' as physics;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../loading/t_loading.dart';
import '../loading/t_loading_theme_data.dart';
import '../text/t_text.dart';
import 't_refresh_theme_data.dart';

/// TDesign刷新头部
/// 结合EasyRefresh类实现下拉刷新,继承自Header类，字段含义与父类一致
class TRefreshHeader extends Header {
  TRefreshHeader({
    this.key,

    /// Header 容器高度。
    double? extent,

    /// 触发刷新任务的偏移量。
    double? triggerDistance,

    /// 是否启用越界钳制。
    bool? clamping,

    /// 是否悬浮展示刷新头。
    bool? float,

    /// 刷新完成后的处理动画时长。
    Duration? processedDuration,

    /// 完成状态停留时长。
    Duration? completeDuration,

    /// 是否启用震动反馈；为空时使用 [enableHapticFeedback]。
    bool? hapticFeedback,
    this.enableHapticFeedback = true,

    /// 无限刷新触发偏移量。
    double? infiniteOffset,
    this.enableInfiniteRefresh = false,

    /// 无限刷新是否允许越界命中。
    bool? infiniteHitOver,

    /// 是否允许越界滚动。
    bool? overScroll,

    /// 自定义 loading 图标样式。
    TLoadingIcon? loadingIcon,

    /// Header 背景颜色。
    Color? backgroundColor,

    /// 回弹弹簧配置。
    physics.SpringDescription? spring,

    /// 横向回弹弹簧配置。
    physics.SpringDescription? horizontalSpring,

    /// ready 状态的弹簧构建器。
    SpringBuilder? readySpringBuilder,

    /// 横向 ready 状态的弹簧构建器。
    SpringBuilder? horizontalReadySpringBuilder,

    /// 弹簧是否允许回弹。
    bool springRebound = true,

    /// 越界滚动摩擦系数。
    FrictionFactor? frictionFactor,

    /// 横向越界滚动摩擦系数。
    FrictionFactor? horizontalFrictionFactor,

    /// 是否计算安全区。
    bool safeArea = false,

    /// 滚动自身到达边界时是否判定越界。
    bool? hitOver,

    /// 刷新头位置。
    IndicatorPosition position = IndicatorPosition.above,

    /// 二楼触发偏移量。
    double? secondaryTriggerOffset,

    /// 二楼打开速度。
    double secondaryVelocity = kDefaultSecondaryVelocity,

    /// 二楼尺寸。
    double? secondaryDimension,

    /// 二楼关闭触发偏移量。
    double secondaryCloseTriggerOffset = kDefaultSecondaryCloseTriggerOffset,

    /// 不可见时是否仍发送通知。
    bool notifyWhenInvisible = false,

    /// 指示器状态监听器。
    IndicatorStateListenable? listenable,

    /// 到达触发距离时是否立即触发。
    bool triggerWhenReach = false,

    /// 释放时是否立即触发。
    bool triggerWhenRelease = false,

    /// 释放时是否立即触发且不等待任务完成。
    bool triggerWhenReleaseNoWait = false,

    /// 最大越界滚动距离。
    double maxOverOffset = double.infinity,
  })  : finalExtent = extent ?? 48.0,
        finalTriggerDistance = triggerDistance ?? 48.0,
        finalFloat = float ?? false,
        finalCompleteDuration = completeDuration,
        finalOverScroll = overScroll ?? true,
        finalLoadingIcon = loadingIcon,
        finalBackgroundColor = backgroundColor,
        assert((triggerDistance ?? 48.0) > 0.0),
        assert((extent ?? 48.0) >= 0.0, 'extent must be non-negative'),
        assert(
            (clamping ?? float ?? false) ||
                (triggerDistance ?? 48.0) >= (extent ?? 48.0),
            'The refresh indicator cannot take more space in its final state '
            'than the amount initially created by overscrolling.'),
        super(
          triggerOffset: triggerDistance ?? 48.0,
          clamping: clamping ?? float ?? false,
          processedDuration: processedDuration ??
              completeDuration ??
              const Duration(seconds: 1),
          hapticFeedback: hapticFeedback ?? enableHapticFeedback,
          infiniteOffset: enableInfiniteRefresh ? infiniteOffset : null,
          infiniteHitOver: infiniteHitOver ?? overScroll ?? true,
          spring: spring,
          horizontalSpring: horizontalSpring,
          readySpringBuilder: readySpringBuilder,
          horizontalReadySpringBuilder: horizontalReadySpringBuilder,
          springRebound: springRebound,
          frictionFactor: frictionFactor,
          horizontalFrictionFactor: horizontalFrictionFactor,
          safeArea: safeArea,
          hitOver: hitOver,
          position: position,
          secondaryTriggerOffset: secondaryTriggerOffset,
          secondaryVelocity: secondaryVelocity,
          secondaryDimension: secondaryDimension,
          secondaryCloseTriggerOffset: secondaryCloseTriggerOffset,
          notifyWhenInvisible: notifyWhenInvisible,
          listenable: listenable,
          triggerWhenReach: triggerWhenReach,
          triggerWhenRelease: triggerWhenRelease,
          triggerWhenReleaseNoWait: triggerWhenReleaseNoWait,
          maxOverOffset: maxOverOffset,
        );

  /// Key
  final Key? key;

  /// Header 容器高度
  final double finalExtent;

  /// 触发刷新任务的偏移量
  final double finalTriggerDistance;

  /// 是否悬浮
  final bool finalFloat;

  /// 完成延时
  final Duration? finalCompleteDuration;

  /// 越界滚动
  final bool finalOverScroll;

  /// loading 样式
  final TLoadingIcon? finalLoadingIcon;

  /// 背景颜色
  final Color? finalBackgroundColor;

  /// 是否启用震动反馈。
  final bool enableHapticFeedback;

  /// 是否启用无限刷新。
  final bool enableInfiniteRefresh;

  @override
  Widget build(BuildContext context, IndicatorState state) {
    // 不能为水平方向
    assert(
      state.axisDirection == AxisDirection.down ||
          state.axisDirection == AxisDirection.up, // coverage:ignore-line
      'Widget cannot be horizontal',
    );
    final theme = Theme.of(context).extension<TRefreshThemeData>();
    return TGIconHeaderWidget(
      key: key,
      loadingIcon:
          finalLoadingIcon ?? theme?.loadingIcon ?? TLoadingIcon.circle,
      backgroundColor: finalBackgroundColor ?? theme?.backgroundColor,
      state: state,
      refreshIndicatorExtent: finalExtent,
    );
  }
}

/// 刷新头部组件
class TGIconHeaderWidget extends StatefulWidget {
  /// loading样式
  final TLoadingIcon loadingIcon;

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

class TGIconHeaderWidgetState extends State<TGIconHeaderWidget>
    with TickerProviderStateMixin {
  IndicatorMode get _refreshState => widget.state.mode;

  double get _offset => widget.state.offset;

  double get _actualTriggerOffset => widget.state.actualTriggerOffset;

  bool get _reverse => widget.state.reverse;

  double get _safeOffset => widget.state.safeOffset;

  Widget _buildLoading() => Theme(
        data: Theme.of(context).mergeExtension(
          TLoadingThemeData(
            iconColor: context.tTheme.brandNormalColor,
            axis: Axis.horizontal,
            textColor: context.tTheme.textColorPlaceholder,
          ),
        ),
        child: TLoading(
          size: TLoadingSize.medium,
          icon: widget.loadingIcon,
          text: context.resource.refreshing,
        ),
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
                ? -(_actualTriggerOffset -
                        _offset +
                        (_reverse ? _safeOffset : -_safeOffset)) /
                    2
                : (!_reverse ? _safeOffset : 0), // coverage:ignore-line
            bottom: _offset < _actualTriggerOffset
                ? null
                : (_reverse ? _safeOffset : 0), // coverage:ignore-line
            height:
                _offset < _actualTriggerOffset ? _actualTriggerOffset : null,
            child: Container(
              alignment: Alignment.center,
              height: widget.refreshIndicatorExtent,
              color: widget.backgroundColor,
              child: Visibility(
                child: Container(
                  child: _buildLoading(),
                ),
                visible: _refreshState == IndicatorMode.processing ||
                    _refreshState == IndicatorMode.ready,
                replacement: Visibility(
                  visible: _refreshState != IndicatorMode.inactive,
                  child: TText(
                    _refreshState == IndicatorMode.drag
                        ? context.resource.pullToRefresh // coverage:ignore-line
                        : _refreshState == IndicatorMode.processed ||
                                _refreshState == IndicatorMode.done
                            ? context.resource
                                .completeRefresh // coverage:ignore-line
                            : context.resource.releaseRefresh,
                    font: context.tTheme.fontBodyMedium,
                    textColor: context.tTheme.textColorPlaceholder,
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
