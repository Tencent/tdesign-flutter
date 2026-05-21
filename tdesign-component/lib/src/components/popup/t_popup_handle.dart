part of 't_popup.dart';

/// [TPopup.show] 的返回值，表示**一次**打开操作。
///
/// 保存此对象并在需要时调用 [close]；不要依赖 `context` 推断要关哪一层。
///
/// ```dart
/// final handle = TPopup(options: opts).show(context);
/// if (handle.isShowing) {
///   handle.close('result'); // 可选 result 传给 Navigator.pop
/// }
/// ```
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

  /// 本次 [TPopup.show] 对应的浮层是否仍在展示。
  bool get isShowing => _route != null && !_isClosed;

  /// 关闭本次 [TPopup.show] 打开的浮层（[TPopupTrigger.programmatic]）。
  ///
  /// 已关闭或未展示时调用无副作用。嵌套多层时须用**对应层**的 handle 关闭。
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
