import 'package:flutter/material.dart';

import '_popup_route.dart';
import 't_popup_options.dart';
import 't_popup_types.dart';

export 't_popup_options.dart';
export 't_popup_types.dart';

part 't_popup_handle.dart';
part 't_popup_tracker.dart';

/// 弹出层命名空间：五向滑入 / 居中弹出，支持蒙层、bottom 操作栏、center 下方关闭。
///
/// 仅提供静态入口 [show]；返回的 [TPopupHandle] 控制本次浮层的显隐。
///
/// ```dart
/// final handle = TPopup.show(
///   context,
///   options: TPopupOptions(
///     placement: TPopupPlacement.bottom,
///     title: '标题',
///     child: MyPanel(),
///   ),
/// );
///
/// // 关闭后再开（同一 handle）
/// handle.close();
/// handle.open(context);
/// ```
///
/// 字段说明见 [TPopupOptions]；按 [TPopupPlacement] 只有部分参数生效（无效参数会在
/// [TPopupOptions.normalized] 中裁掉）。
final class TPopup {
  const TPopup._();

  /// 命令式打开浮层并压入独立路由。
  ///
  /// 返回 [TPopupHandle]：可用 [TPopupHandle.close] / [TPopupHandle.open] 控制显隐；
  /// [TPopupHandle.isShowing] 可查询是否仍在展示。
  ///
  /// 同一按钮在页面 context 上重复调用时，若已有展示中的 Popup 会返回已有 handle（防连点）。
  ///
  /// - [navigatorContext]：指定使用哪个 [Navigator]，默认用 `context`。
  /// - [useRootNavigator]：是否使用根 [Navigator]（嵌套导航场景）。
  static TPopupHandle show(
    BuildContext context, {
    required TPopupOptions options,
    BuildContext? navigatorContext,
    bool useRootNavigator = false,
  }) {
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

    final handle = TPopupHandle._(
      options: options,
      navigatorContext: navigatorContext,
      useRootNavigator: useRootNavigator,
    );
    handle.open(context);
    return handle;
  }
}
