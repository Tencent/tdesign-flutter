import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../../tdesign_flutter.dart';

/// TDesign刷新头部
/// 结合EasyRefresh类实现下拉刷新,继承自Header类，字段含义与父类一致
class TDRefreshHeader extends Header {

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
    this.backgroundColor,
  }) : super(
    extent: extent,
    triggerDistance: triggerDistance,
    float: float,
    completeDuration: completeDuration,
    enableHapticFeedback: enableHapticFeedback,
    enableInfiniteRefresh: enableInfiniteRefresh,
    overScroll: overScroll,
  );

  /// Key
  final Key? key;

  /// loading样式
  final TDLoadingIcon loadingIcon;

  /// 背景颜色
  final Color? backgroundColor;

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
    return TGIconHeaderWidget(
      key: key,
      loadingIcon: loadingIcon,
        backgroundColor: backgroundColor,
        refreshState: refreshState,
        refreshIndicatorExtent: refreshIndicatorExtent
    );
  }
}



/// 刷新头部组件
class TGIconHeaderWidget extends StatefulWidget {


  /// loading样式
  final TDLoadingIcon loadingIcon;

  /// 背景颜色
  final Color? backgroundColor;

  /// 刷新状态
  final RefreshMode refreshState;

  /// 下拉高度
  final double refreshIndicatorExtent;

  const TGIconHeaderWidget({
    Key? key,
    this.backgroundColor,
    required this.refreshState,
    required this.refreshIndicatorExtent,
    required this.loadingIcon,
  }) : super(key: key);

  @override
  TGIconHeaderWidgetState createState() {
    return TGIconHeaderWidgetState();
  }
}

class TGIconHeaderWidgetState extends State<TGIconHeaderWidget> with TickerProviderStateMixin {

  RefreshMode get _refreshState => widget.refreshState;

  Widget _buildLoading() => TDLoading(
    size: TDLoadingSize.medium,
    icon: widget.loadingIcon,
    iconColor: TDTheme.of(context).brandNormalColor,
    axis: Axis.horizontal,
    text: '正在刷新',
    textColor: TDTheme.of(context).fontGyColor3,
  );

  Widget _buildInitial(BoxConstraints constraint) {
    return Opacity(
      opacity: min(constraint.maxHeight / 28, 1),
      child: Container(
        alignment: Alignment.center,
        child: constraint.maxHeight < 48.0
            ? Container()
            : TDText('松开刷新',font: TDTheme.of(context).fontBodyMedium, textColor: TDTheme.of(context).fontGyColor3,),
        color: widget.backgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var isRefresh = _refreshState == RefreshMode.refresh ||
        _refreshState == RefreshMode.armed;

    var isInitial = _refreshState == RefreshMode.inactive || _refreshState == RefreshMode.drag;

    return Stack(
      children: <Widget>[
        Positioned(
          top: 0.0,
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: LayoutBuilder(
            builder: (_, constraint) => Container(
                alignment: Alignment.center,
                height: widget.refreshIndicatorExtent,
                color: widget.backgroundColor,
                child: Visibility(
                  child: Container(
                    child: _buildLoading(),
                  ),
                  visible: isRefresh,
                  replacement: Visibility(
                    child: _buildInitial(constraint),
                    visible: isInitial,
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
