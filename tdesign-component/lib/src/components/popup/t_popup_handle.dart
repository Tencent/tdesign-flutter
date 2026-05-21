part of 't_popup.dart';

/// [TPopup.show] 返回的句柄，用于查询展示状态与程序化关闭。
class TPopupHandle {
  TPopupHandle._({
    required void Function(TPopupTrigger trigger, [Object? result])
        onCloseWithTrigger,
    TPopupNavigatorRoute<dynamic>? route,
  })  : _route = route,
        _onCloseWithTrigger = onCloseWithTrigger;

  TPopupNavigatorRoute<dynamic>? _route;
  final void Function(TPopupTrigger trigger, [Object? result])
      _onCloseWithTrigger;
  bool _isClosed = false;

  /// 浮层是否仍在展示（路由在栈中且未进入关闭流程）。
  bool get isShowing => _route != null && !_isClosed;

  /// 以 [TPopupTrigger.programmatic] 关闭浮层，可向 Navigator 传递 [result]。
  ///
  /// 优先于 [TPopup.close]：不依赖 context 的 Navigator 解析。
  void close([Object? result]) {
    if (!isShowing) {
      return;
    }
    _onCloseWithTrigger(TPopupTrigger.programmatic, result);
  }

  void _markClosing() {
    _isClosed = true;
  }

  void _detachRoute() {
    _isClosed = true;
    _route = null;
  }
}
