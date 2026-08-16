import 'package:easy_refresh/easy_refresh.dart';
import 'package:meta/meta.dart';

/// [TPullDownRefresh] 的受控控制器。
///
/// 对应官方（小程序 / mobile-vue）受控 `value` 语义，用 Flutter 惯用的
/// 控制器模式表达：外部可通过 [refresh] / [loadMore] 触发，通过
/// [finishRefresh] / [finishLoadMore] 结束。
class TPullDownRefreshController {
  EasyRefreshController? _controller;

  TPullDownRefreshController();

  /// 由 [TPullDownRefresh] 内部绑定。
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
    _controller?.finishRefresh(force: true);
  }

  /// 结束当前触底加载任务。
  void finishLoadMore() {
    _controller?.finishLoad(force: true);
  }

  /// 复位 Header / Footer 指示器状态。
  void reset() {
    _controller?.resetHeader();
    _controller?.resetFooter();
  }

  /// 释放控制器。
  void dispose() {
    _controller?.dispose();
    _controller = null;
  }
}
