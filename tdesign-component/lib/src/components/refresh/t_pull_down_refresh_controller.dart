import 'package:easy_refresh/easy_refresh.dart';
import 'package:meta/meta.dart';

/// `TPullDownRefresh` 的受控控制器。
///
/// 对应官方（小程序 / mobile-vue）受控 `value` 语义，用 Flutter 惯用的
/// 控制器模式表达：外部可通过 [refresh] / [loadMore] 触发，通过
/// [finishRefresh] / [finishLoadMore] 结束。
///
/// ## 生命周期（所有权）
///
/// 底层 [EasyRefreshController] 的所有权归 `TPullDownRefresh` 的 State 独占管理：
/// State 在 `initState` 中创建、在 `dispose` 中释放。本控制器仅持有对其的**弱引用**，
/// 因此 **不要** 在本控制器上调用 [dispose] 去释放底层 controller——那会导致与 State 的
/// 双重释放。外部使用完成后无需调用 [dispose]，只需置空引用交由 GC 回收；
/// 若确需手动释放，本控制器的 [dispose] 仅解绑、不释放底层对象。
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

  /// 外部触发一次下拉刷新（对应官方受控 `value=true`）。
  Future<void> refresh() async {
    await _controller?.callRefresh();
  }

  /// 外部触发一次触底加载（对应官方受控触底加载）。
  Future<void> loadMore() async {
    await _controller?.callLoad();
  }

  /// 结束当前刷新任务（对应官方受控 `value=false`）。
  ///
  /// 仅在外部接管刷新完成时才需要调用；若通过 `onRefresh` 回调返回
  /// Future 完成刷新，则无需手动调用。
  void finishRefresh() {
    _controller?.finishRefresh(IndicatorResult.success, true);
  }

  /// 结束当前触底加载任务。
  void finishLoadMore() {
    _controller?.finishLoad(IndicatorResult.success, true);
  }

  /// 复位 Header / Footer 指示器状态。
  void reset() {
    _controller?.resetHeader();
    _controller?.resetFooter();
  }

  /// 解绑底层引用。
  ///
  /// 仅将内部持有的底层 [EasyRefreshController] 引用置空，**不会** dispose 底层对象
  /// （底层对象的生命周期由 `TPullDownRefresh` 的 State 独占管理），因此调用本方法
  /// 不会导致双重释放。若组件仍在挂载，调用后可继续创建/复用本控制器。
  void dispose() {
    _controller = null;
  }
}
