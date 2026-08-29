import 'package:meta/meta.dart';

/// `TPullDownRefresh` 的外部刷新控制器。
///
/// 使用 Flutter 惯用的控制器模式，从页面外部通过 [refresh] 主动触发一次刷新。
/// 返回的 Future 会在本次刷新成功、回调失败或超时复位后完成；它不返回业务结果。
/// 回调异常仍由 `TPullDownRefresh` 通过 `FlutterError.reportError` 上报。
///
/// ## 生命周期（所有权）
///
/// 底层刷新控制器的所有权归 `TPullDownRefresh` 的 State 独占管理：
/// State 在 `initState` 中创建、在 `dispose` 中释放。本控制器不拥有需要调用方
/// 释放的资源，因此不提供公开 `dispose()`。
class TPullDownRefreshController {
  Future<void> Function()? _refresh;

  TPullDownRefreshController();

  /// 由 `TPullDownRefresh` 内部绑定。
  @internal
  void bind(Future<void> Function() refresh) {
    _refresh = refresh;
  }

  /// 解绑。
  @internal
  void unbind() {
    _refresh = null;
  }

  /// 从页面外部主动触发一次下拉刷新。
  ///
  /// `await refresh()` 表示这次刷新流程已经结束，不代表业务一定成功；
  /// 成功、回调失败和超时都会完成 Future。组件未挂载或未配置刷新回调
  /// 时，该方法立即完成。
  Future<void> refresh() async {
    await _refresh?.call();
  }
}
