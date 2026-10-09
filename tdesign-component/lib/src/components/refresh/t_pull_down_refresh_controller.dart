import 'package:meta/meta.dart';

/// `TPullDownRefresh` 的外部刷新控制器。
///
/// 使用 Flutter 惯用的控制器模式，从页面外部通过 [refresh] 主动触发一次刷新。
/// 返回的 Future 会在本次刷新成功、回调失败或超时复位后完成；它不返回业务结果。
/// 回调异常仍由 `TPullDownRefresh` 通过 `FlutterError.reportError` 上报。
///
/// ## 生命周期（所有权）
///
/// 刷新资源由 `TPullDownRefresh` 随挂载和卸载管理；本控制器不拥有
/// 需要调用方释放的资源，因此无需也不提供公开 `dispose()`。
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
  ///
  /// ## 返回值
  /// 刷新流程结束时完成；业务失败或超时也会完成，未挂载或无刷新回调时立即完成。
  Future<void> refresh() async {
    await _refresh?.call();
  }
}
