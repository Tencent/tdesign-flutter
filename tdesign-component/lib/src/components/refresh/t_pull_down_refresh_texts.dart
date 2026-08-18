import 'package:flutter/widgets.dart';

/// 下拉刷新提示语。
///
/// 对应官方（小程序 / mobile-vue）`loadingTexts: string[]` 数组，
/// 覆盖「下拉刷新 / 松手刷新 / 正在刷新 / 刷新完成」四个阶段，
/// 外加触底加载的「没有更多了（no-more）」结束文案。
class TPullDownRefreshTexts {
  /// 下拉未达阈值时的提示语（官方默认「下拉刷新」）。
  final String pullToRefresh;

  /// 下拉已达阈值、松手即刷新的提示语（官方默认「松手刷新」）。
  final String releaseToRefresh;

  /// 刷新进行中的提示语（官方默认「正在刷新」）。
  final String refreshing;

  /// 刷新完成时的提示语（官方默认「刷新完成」）。
  final String refreshComplete;

  /// 触底加载、无更多数据时 footer 的结束提示语（默认 `/`）。
  ///
  /// 仅在启用触底加载（`TPullDownRefresh.enableLoadMore`）且加载进入
  /// 结束态时展示。
  final String noMore;

  /// 构造文案。
  const TPullDownRefreshTexts({
    required this.pullToRefresh,
    required this.releaseToRefresh,
    required this.refreshing,
    required this.refreshComplete,
    this.noMore = '/',
  });
}

/// 下拉刷新状态。
enum TPullDownRefreshState {
  /// 未触发（初始 / 完成复位后）。
  inactive,

  /// 下拉中，未达到触发阈值。
  dragging,

  /// 已达阈值、松手即触发刷新。
  ready,

  /// 刷新进行中。
  refreshing,

  /// 刷新完成、展示完成态。
  done,

  /// 刷新超时。
  timeout,
}
