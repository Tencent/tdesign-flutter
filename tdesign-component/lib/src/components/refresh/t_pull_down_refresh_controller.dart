import 'package:easy_refresh/easy_refresh.dart' show EasyRefreshController;
import 'package:meta/meta.dart';

/// `TPullDownRefresh` 的外部刷新控制器。
///
/// 使用 Flutter 惯用的控制器模式，从页面外部通过 [refresh] 主动触发一次刷新。
/// 刷新完成时机由 `TPullDownRefresh.onRefresh` 返回的 Future 统一决定。
///
/// ## 生命周期（所有权）
///
/// 底层 [EasyRefreshController] 的所有权归 `TPullDownRefresh` 的 State 独占管理：
/// State 在 `initState` 中创建、在 `dispose` 中释放。本控制器不拥有需要调用方
/// 释放的资源，因此不提供公开 `dispose()`。
class TPullDownRefreshController {
  EasyRefreshController? _controller;

  TPullDownRefreshController();

  /// 由 `TPullDownRefresh` 内部绑定。
  @internal
  void bind(EasyRefreshController controller) {
    _controller = controller;
  }

  /// 解绑。
  @internal
  void unbind() {
    _controller = null;
  }

  /// 从页面外部主动触发一次下拉刷新。
  Future<void> refresh() async {
    await _controller?.callRefresh();
  }
}
