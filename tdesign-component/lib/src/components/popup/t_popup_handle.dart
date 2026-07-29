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
    required this.themeContext,
    this.navigatorContext,
    this.useRootNavigator = false,
  });

  /// 创建时传入的配置；每次 [open] 会按 [TPopupOptions.placement] 裁剪无效字段后使用。
  final TPopupOptions options;

  /// 用于捕获调用点局部 Theme 的 context。
  final BuildContext themeContext;

  /// 与 [TPopup.show] 的 [navigatorContext] 相同。
  final BuildContext? navigatorContext;

  /// 与 [TPopup.show] 的 [useRootNavigator] 相同。
  final bool useRootNavigator;

  _PopupNavigatorRoute<dynamic>? _route;
  NavigatorState? _lastNavigator;
  bool _isClosed = false;
  int _openEpoch = 0;
  Completer<Object?>? _resultCompleter;

  /// 当前这次打开结束后的路由结果。
  ///
  /// 每次 [open] 都会创建新的 Future；应在对应的 [open] 之后读取。
  Future<Object?> get result =>
      (_resultCompleter ??= Completer<Object?>()).future;

  /// 浮层是否仍在展示（路由在栈中且未进入关闭流程）。
  ///
  /// 额外校验 [Route.isActive]：当路由被外部移除（如 Navigator 被销毁或
  /// 路由被直接 pop）时，[_route] 引用可能残留，此时应视为未展示，
  /// 避免句柄常驻为“展示中”而阻断后续 open。
  bool get isShowing =>
      _route != null && !_isClosed && (_route?.isActive ?? false);

  /// 打开或重新打开浮层。
  ///
  /// [context] 可选。首次调用须能解析 [Navigator]（传入 [context] 或依赖
  /// [navigatorContext]）；后续可省略，优先复用缓存的 [NavigatorState]。
  ///
  /// 已展示时调用无副作用。Navigator 已销毁且未提供新 [context] 时，debug 下 assert，
  /// release 下静默返回。
  ///
  /// 配置非法时会直接抛出 [FlutterError]，debug / release 行为一致。
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
        ? InheritedTheme.capture(
            from: captureFrom,
            to: navigator.context,
          )
        : null;

    _isClosed = false;
    _lastNavigator = navigator;

    _PopupNavigatorRoute<dynamic>? route;

    void closeWithTrigger(TPopupTrigger trigger) {
      final currentRoute = route;
      if (!isShowing || currentRoute == null) {
        return;
      }
      _closeRoute(
        navigator: navigator,
        route: currentRoute,
        trigger: trigger,
      );
    }

    route = _PopupNavigatorRoute<dynamic>(
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
    _route = route;

    _PopupTracker.push(navigator, this);

    navigator.push(route).then((result) {
      if (!resultCompleter.isCompleted) {
        resultCompleter.complete(result);
      }
    }).whenComplete(() {
      _PopupTracker.remove(navigator, this);
      final completedRoute = route;
      if (completedRoute != null) {
        _detachRoute(completedRoute);
      }
    });
  }

  /// 关闭当前展示的浮层；[TPopupOptions.onVisibleChange] 的 [TPopupTrigger] 为
  /// [TPopupTrigger.api]。
  ///
  /// 已关闭或未展示时调用无副作用。
  /// 嵌套浮层场景下会关闭当前 handle 对应的那一层，而不会误关栈顶其它浮层。
  void close([Object? result]) {
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
    if (identical(_PopupTracker.top(navigator), this)) {
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
