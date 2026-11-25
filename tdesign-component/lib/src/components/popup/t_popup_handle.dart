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
/// handle.open(); // 可省略 context；destroyOnClose 为 false 时复用内容 State
/// ```
class TPopupHandle {
  TPopupHandle._({
    required this.options,
    required this.themeContext,
    this.navigatorContext,
    this.useRootNavigator = false,
    bool reusable = true,
  }) : _reusable = reusable;

  /// [TPopup.show] 合并显式配置与 [TPopupThemeData] 后的配置；重新 [open] 不重新解析已合并的主题值，并按 [TPopupOptions.placement] 裁剪无效字段。
  final TPopupOptions options;

  /// 用于捕获调用点局部 Theme 的 context。
  final BuildContext themeContext;

  /// 与 [TPopup.show] 的 [navigatorContext] 相同。
  final BuildContext? navigatorContext;

  /// 与 [TPopup.show] 的 [useRootNavigator] 相同。
  final bool useRootNavigator;

  // Drawer has no reopen entry and keeps its legacy one-shot lifecycle.
  final bool _reusable;
  _PopupNavigatorRoute<dynamic>? _route;
  NavigatorState? _lastNavigator;
  _PopupRetention? _retention;
  bool _isClosed = false;
  int _openEpoch = 0;
  Completer<Object?>? _resultCompleter;

  /// 本次打开的路由结果；关闭时完成，不等待关闭动画结束，动画完成通知见 [TPopupOptions.onClosed]。
  ///
  /// 每次成功 [open] 都会创建新的 Future；应在对应的 [open] 之后读取。
  Future<Object?> get result =>
      (_resultCompleter ??= Completer<Object?>()).future;

  /// 浮层仍在路由栈中且未开始关闭时为 true。
  bool get isShowing =>
      _route != null && !_isClosed && (_route?.isActive ?? false);

  /// 使用创建句柄时的 [options] 打开或重新打开浮层。
  ///
  /// 不更新配置或创建独立会话；更换配置请调用 [TPopup.show]。
  ///
  /// destroyOnClose 为 false 时，同一 Navigator 内复用保留的内容 State；
  /// 切换 Navigator 时创建新 State。每次 TPopup.show 创建独立会话。
  ///
  /// | 状态 | 行为 |
  /// | --- | --- |
  /// | 已展示 | 不重复打开 |
  /// | Navigator 可用 | 打开浮层，创建新的 [result] Future |
  /// | 无可用 Navigator | debug 触发断言，release 返回 |
  /// | 参数与方向不匹配 | debug / release 均抛出 [FlutterError] |
  ///
  /// [context] 导航上下文；未指定或无效时依次尝试缓存的 Navigator、[navigatorContext]。有效时重新捕获此处的内容 Theme，否则使用 [themeContext]；不重新解析 [options] 中已合并的 Popup 主题值。
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

    final validationError = options._validatePlacementParams();
    if (validationError != null) {
      _throwPopupOptionsValidationError(validationError);
    }
    final normalized = options.normalized();
    final onClosed = normalized.onClosed;
    final openEpoch = ++_openEpoch;
    final resultCompleter = Completer<Object?>();
    _resultCompleter = resultCompleter;
    final captureFrom = context?.mounted == true ? context! : themeContext;
    final capturedThemes = captureFrom.mounted
        ? TOverlayThemes.capture(from: captureFrom, to: navigator.context)
        : null;

    if (_retention != null && !identical(_retention!.navigator, navigator)) {
      _retention!.release();
      _retention = null;
    }
    if (_reusable && !options.destroyOnClose && _retention == null) {
      late final _PopupRetention retention;
      retention = _PopupRetention(navigator, () {
        if (identical(_retention, retention)) {
          _retention = null;
        }
      });
      _retention = retention;
    }
    _isClosed = false;
    _lastNavigator = navigator;

    _PopupNavigatorRoute<dynamic>? route;
    var tracked = true;
    void untrack() {
      if (tracked) {
        tracked = false;
        _PopupTracker.remove(navigator, this);
      }
    }

    void closeWithTrigger(TPopupTrigger trigger) {
      final currentRoute = route;
      if (!isShowing || currentRoute == null) {
        return;
      }
      _closeRoute(navigator: navigator, route: currentRoute, trigger: trigger);
    }

    route = _PopupNavigatorRoute<dynamic>(
      retention: _retention,
      maintainWhenCovered: _reusable || !options.destroyOnClose,
      onDisposed: () {
        untrack();
        final disposedRoute = route;
        if (disposedRoute != null) {
          _detachRoute(disposedRoute);
        }
      },
      options: normalized.copyWith(
        onClosed: () {
          if (_openEpoch == openEpoch) {
            onClosed?.call();
          }
        },
      ),
      onCloseWithTrigger: closeWithTrigger,
      capturedThemes: capturedThemes,
    );
    _retention?.activate(route);
    _route = route;

    _PopupTracker.push(navigator, this);

    navigator
        .push(route)
        .then((result) {
          if (!resultCompleter.isCompleted) {
            resultCompleter.complete(result);
          }
        })
        .whenComplete(() {
          untrack();
          final completedRoute = route;
          if (completedRoute != null) {
            _detachRoute(completedRoute);
          }
        });
  }

  /// 关闭此句柄对应的浮层，触发源为 [TPopupTrigger.api]。
  ///
  /// | 状态 | 行为 |
  /// | --- | --- |
  /// | 未展示或已开始关闭 | 不执行操作 |
  /// | 位于栈顶 | 返回上一层，执行关闭动画 |
  /// | 位于其他浮层下方 | 直接移除此层，保留其他浮层 |
  void close([
    /// 关闭浮层时返回的业务结果；通过该句柄的 result Future 接收。
    Object? result,
  ]) {
    final route = _route;
    final navigator = route?.navigator ?? _lastNavigator;
    if (!isShowing || route == null || navigator == null) {
      return;
    }
    _closeRoute(
      navigator: navigator,
      route: route,
      trigger: TPopupTrigger.api,
      result: result,
    );
  }

  NavigatorState? _resolveNavigator(BuildContext? context) {
    final explicitNavigator = _navigatorFromContext(context);
    if (explicitNavigator != null) {
      return explicitNavigator;
    }
    final cached = _lastNavigator;
    if (cached != null && cached.mounted) {
      return cached;
    }
    return _navigatorFromContext(navigatorContext);
  }

  NavigatorState? _navigatorFromContext(BuildContext? context) {
    if (context == null || !context.mounted) {
      return null;
    }
    return Navigator.maybeOf(context, rootNavigator: useRootNavigator);
  }

  void _markClosing() {
    _isClosed = true;
  }

  void _closeRoute({
    required NavigatorState navigator,
    required _PopupNavigatorRoute<dynamic> route,
    required TPopupTrigger trigger,
    Object? result,
  }) {
    _markClosing();
    route.fireCloseStart(trigger);
    if (route.isCurrent) {
      navigator.pop(result);
      return;
    }
    navigator.removeRoute(route, result);
  }

  void _detachRoute(_PopupNavigatorRoute<dynamic> route) {
    if (!identical(_route, route)) {
      return;
    }
    _isClosed = true;
    _route = null;
  }
}
