part of 't_popup.dart';

/// [TPopup.show] 的返回值，用于控制同一份 [TPopupOptions] 的多次打开与关闭。
///
/// **示例**
///
/// ```dart
/// final handle = TPopup.show(
///   context,
///   options: TPopupOptions.bottom(child: panel),
/// );
/// handle.close();
/// handle.open(); // 可省略 context，复用已缓存的 Navigator
/// ```
class TPopupHandle {
  TPopupHandle._({
    required this.options,
    this.navigatorContext,
    this.useRootNavigator = false,
  });

  /// 创建时传入的配置；每次 [open] 会按 [TPopupOptions.placement] 裁剪无效字段后使用。
  final TPopupOptions options;

  /// 与 [TPopup.show] 的 [navigatorContext] 相同。
  final BuildContext? navigatorContext;

  /// 与 [TPopup.show] 的 [useRootNavigator] 相同。
  final bool useRootNavigator;

  _PopupNavigatorRoute<dynamic>? _route;
  NavigatorState? _lastNavigator;
  bool _isClosed = false;

  /// 浮层是否仍在展示（路由在栈中且未进入关闭流程）。
  bool get isShowing => _route != null && !_isClosed;

  /// 打开或重新打开浮层。
  ///
  /// [context] 可选。首次调用须能解析 [Navigator]（传入 [context] 或依赖
  /// [navigatorContext]）；后续可省略以复用缓存的 [NavigatorState]。
  ///
  /// 已展示时调用无副作用。Navigator 已销毁且未提供新 [context] 时，debug 下 assert，
  /// release 下静默返回。
  void open([BuildContext? context]) {
    if (isShowing) {
      return;
    }
    final navigator = _resolveNavigator(context);
    if (navigator == null) {
      assert(
        false,
        'TPopupHandle.open: cannot resolve Navigator. '
        'Either pass a valid context or ensure the handle was created '
        'with a still-mounted navigatorContext.',
      );
      return;
    }

    options.assertPlacementParams();
    final normalized = options.normalized();

    _isClosed = false;
    _lastNavigator = navigator;

    _PopupNavigatorRoute<dynamic>? route;

    void closeWithTrigger(TPopupTrigger trigger, [Object? result]) {
      if (!isShowing) {
        return;
      }
      _markClosing();
      route?.fireCloseStart(trigger);
      navigator.pop(result);
    }

    route = _PopupNavigatorRoute<dynamic>(
      options: normalized,
      onCloseWithTrigger: closeWithTrigger,
    );
    _route = route;

    _PopupTracker.push(navigator, this);

    navigator.push(route).whenComplete(() {
      _PopupTracker.remove(navigator, this);
      _detachRoute();
    });
  }

  /// 关闭当前展示的浮层；[TPopupOptions.onVisibleChange] 的 [TPopupTrigger] 为
  /// [TPopupTrigger.api]。
  ///
  /// [result] 可选，作为 [Navigator.pop] 的返回值。
  ///
  /// 已关闭或未展示时调用无副作用。嵌套浮层须使用对应层的 handle 关闭。
  void close([Object? result]) {
    if (!isShowing) {
      return;
    }
    _markClosing();
    _route?.fireCloseStart(TPopupTrigger.api);
    _route!.navigator?.pop(result);
  }

  NavigatorState? _resolveNavigator(BuildContext? context) {
    final ctx = context ?? navigatorContext;
    if (ctx != null) {
      return Navigator.maybeOf(ctx, rootNavigator: useRootNavigator);
    }
    final cached = _lastNavigator;
    if (cached != null && cached.mounted) {
      return cached;
    }
    return null;
  }

  void _markClosing() {
    _isClosed = true;
  }

  void _detachRoute() {
    _isClosed = true;
    _route = null;
  }
}
