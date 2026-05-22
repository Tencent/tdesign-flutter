part of 't_popup.dart';

/// [TPopup.show] 的返回值：可查询展示状态，并多次 [open] / [close]。
///
/// 保存此对象；关闭后再次 [open] 会按创建时的 [TPopupOptions] 重新压入路由。
///
/// ```dart
/// final handle = TPopup.show(context, options: opts);
/// handle.close();
/// if (!handle.isShowing) {
///   handle.open(context);
/// }
/// ```
class TPopupHandle {
  TPopupHandle._({
    required this.options,
    this.navigatorContext,
    this.useRootNavigator = false,
  });

  /// 打开/再次打开时使用的配置（每次 [open] 会 [TPopupOptions.normalized]）。
  final TPopupOptions options;

  /// 与 [TPopup.show] 相同：指定 Navigator 的 context。
  final BuildContext? navigatorContext;

  /// 与 [TPopup.show] 相同：是否使用根 Navigator。
  final bool useRootNavigator;

  TPopupNavigatorRoute<dynamic>? _route;
  bool _isClosed = false;

  /// 浮层是否仍在展示（路由在栈中且未进入关闭流程）。
  bool get isShowing => _route != null && !_isClosed;

  /// 打开或重新打开浮层。
  ///
  /// 已展示时调用无副作用。关闭后再次调用会压入新的 [TPopupNavigatorRoute]。
  void open(BuildContext context) {
    if (isShowing) {
      return;
    }
    // 先用「原始」配置做 debug 期参数校验（保留 sentinel 与用户传值差异），
    // 再 normalize 给路由使用（normalize 会按 placement 强制清空无效字段）。
    options.assertPlacementParams();
    final normalized = options.normalized();

    final navigator = _navigatorOf(context);
    _isClosed = false;

    TPopupNavigatorRoute<dynamic>? route;

    void closeWithTrigger(TPopupTrigger trigger, [Object? result]) {
      if (!isShowing) {
        return;
      }
      _markClosing();
      route?.fireCloseStart(trigger);
      navigator.pop(result);
    }

    route = TPopupNavigatorRoute<dynamic>(
      options: normalized,
      onCloseWithTrigger: closeWithTrigger,
    );
    _route = route;

    TPopupTracker.push(navigator, this);

    navigator.push(route).whenComplete(() {
      TPopupTracker.remove(navigator, this);
      _detachRoute();
    });
  }

  /// 关闭当前展示的浮层（[TPopupTrigger.programmatic]）。
  ///
  /// 已关闭或未展示时调用无副作用。嵌套多层时须用**对应层**的 handle 关闭。
  void close([Object? result]) {
    if (!isShowing) {
      return;
    }
    _markClosing();
    _route?.fireCloseStart(TPopupTrigger.programmatic);
    _navigatorOfForClose().pop(result);
  }

  NavigatorState _navigatorOf(BuildContext context) {
    final navContext = navigatorContext ?? context;
    return Navigator.of(
      navContext,
      rootNavigator: useRootNavigator,
    );
  }

  /// [close] 不依赖外部 context，使用路由所在 Navigator。
  NavigatorState _navigatorOfForClose() {
    return _route!.navigator!;
  }

  void _markClosing() {
    _isClosed = true;
  }

  void _detachRoute() {
    _isClosed = true;
    _route = null;
  }
}
