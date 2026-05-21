import 'package:flutter/material.dart';

import '_popup_route.dart';
import 't_popup_options.dart';
import 't_popup_types.dart';

export 't_popup_options.dart';
export 't_popup_types.dart';

part 't_popup_handle.dart';
part 't_popup_tracker.dart';

/// 弹出层：五向滑入 / 居中弹出，支持蒙层、bottom 操作栏、center 下方关闭。
///
/// ## 怎么用
///
/// **命令式（推荐）** — 先组配置，再 `show`，用返回的 [TPopupHandle] 关闭：
///
/// ```dart
/// final handle = TPopup(
///   options: TPopupOptions(
///     placement: TPopupPlacement.bottom,
///     title: '标题',
///     child: MyPanel(),
///   ),
/// ).show(context);
///
/// // 关闭这一层（须保留 handle，不要用 context 猜栈顶）
/// handle.close();
/// ```
///
/// **声明式** — 包住子树，`initialVisible: true` 时首帧自动 [show]；[build] 只渲染 [options.child]：
///
/// ```dart
/// TPopup(
///   options: TPopupOptions(child: body),
///   initialVisible: true,
/// )
/// ```
///
/// 字段说明见 [TPopupOptions]；按 [TPopupPlacement] 只有部分参数生效（无效参数会在
/// [TPopupOptions.normalized] 中裁掉）。
class TPopup extends StatefulWidget {
  const TPopup({
    super.key,
    required this.options,
    this.initialVisible = false,
    this.navigatorContext,
    this.useRootNavigator = false,
  });

  /// 浮层内容与行为配置，见 [TPopupOptions]。
  final TPopupOptions options;

  /// 为 true 时，挂载后首帧自动调用 [show]（仅声明式）。
  final bool initialVisible;

  /// 指定使用哪个 [Navigator]；默认 [show] 传入的 `context` 所在 Navigator。
  final BuildContext? navigatorContext;

  /// 为 true 时使用根 [Navigator]（嵌套导航场景）。
  final bool useRootNavigator;

  /// 打开浮层并压入独立路由。
  ///
  /// 返回 [TPopupHandle]：用 [TPopupHandle.close] 关闭**本次**打开的层；
  /// [TPopupHandle.isShowing] 可查询是否仍在展示。
  ///
  /// 同一按钮在页面 context 上重复调用时，若已有展示中的 Popup 会返回已有 handle（防连点）。
  TPopupHandle show(BuildContext context) {
    final normalized = options.normalized();
    normalized.assertPlacementParams();

    final navContext = navigatorContext ?? context;
    final navigator = Navigator.of(
      navContext,
      rootNavigator: useRootNavigator,
    );

    final existing = TPopupTracker.top(navigator);
    if (existing != null &&
        existing.isShowing &&
        ModalRoute.of(context) is! TPopupNavigatorRoute) {
      return existing;
    }

    TPopupNavigatorRoute<dynamic>? route;
    late TPopupHandle handle;

    void closeWithTrigger(TPopupTrigger trigger, [Object? result]) {
      if (!handle.isShowing) {
        return;
      }
      handle._markClosing();
      route?.fireCloseStart(trigger);
      navigator.pop(result);
    }

    route = TPopupNavigatorRoute<dynamic>(
      options: normalized,
      onCloseWithTrigger: closeWithTrigger,
    );

    handle = TPopupHandle._(
      route: route,
      onCloseWithTrigger: closeWithTrigger,
    );

    TPopupTracker.push(navigator, handle);

    navigator.push(route).whenComplete(() {
      TPopupTracker.remove(navigator, handle);
      handle._detachRoute();
    });

    return handle;
  }

  @override
  State<TPopup> createState() => _TPopupState();
}

class _TPopupState extends State<TPopup> {
  TPopupHandle? _handle;

  @override
  void initState() {
    super.initState();
    if (widget.initialVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _open());
    }
  }

  @override
  void dispose() {
    _handle?.close();
    super.dispose();
  }

  void _open() {
    if (_handle?.isShowing == true) {
      return;
    }
    _handle = widget.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.options.child;
  }
}
