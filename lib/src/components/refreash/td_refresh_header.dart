import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../../td_export.dart';

/// TDesign刷新头部
class TDRefreshHeader extends Header {
  /// Key
  final Key? key;

  final TDLoadingIcon loadingIcon;

  TDRefreshHeader({
    this.key,
    double extent = 48.0,
    double triggerDistance = 48.0,
    bool float = false,
    Duration? completeDuration,
    bool enableHapticFeedback = true,
    bool enableInfiniteRefresh = false,
    bool overScroll = true,
    this.loadingIcon = TDLoadingIcon.circle,
  }) : super(
          extent: extent,
          triggerDistance: triggerDistance,
          float: float,
          completeDuration: completeDuration,
          enableHapticFeedback: enableHapticFeedback,
          enableInfiniteRefresh: enableInfiniteRefresh,
          overScroll: overScroll,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      RefreshMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration? completeDuration,
      bool enableInfiniteRefresh,
      bool success,
      bool noMore) {
    // 不能为水平方向
    assert(
        axisDirection == AxisDirection.down ||
            axisDirection == AxisDirection.up,
        'Widget cannot be horizontal');

    return TDLoadingWidget(
      key: key,
      size: TDLoadingSize.medium,
      icon: loadingIcon,
      iconColor: TDTheme.of(context).brandColor8,
    );
  }
}
