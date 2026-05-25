/// TDesign 弹出层（Popup）组件库。
///
/// 对外 API：
/// * [TPopup] — 命令式打开浮层
/// * [TPopupOptions] — 配置（推荐命名工厂）
/// * [TPopupHandle] — 显隐控制
/// * [TPopupPlacement]、[TPopupTrigger] — 方向与关闭来源
/// * [TPopupHeaderBuilder]、[TPopupSlotBuilder]、[TPopupVisibleChangeCallback] — 构建器类型
library;

import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../../util/t_toolbar_pressable.dart';
import '../icon/t_icons.dart';
import '../text/t_text.dart';

part '_popup_center_close.dart';
part '_popup_header.dart';
part '_popup_layout.dart';
part '_popup_route.dart';
part '_popup_shell.dart';
part '_popup_tracker.dart';
part 't_popup_handle.dart';
part 't_popup_inset.dart';
part 't_popup_options.dart';
part 't_popup_types.dart';

/// 弹出层入口：五向滑入 / 居中弹出，支持蒙层、bottom 操作栏、center 下方关闭。
///
/// 通过 [show] 命令式打开；返回 [TPopupHandle] 用于关闭与再次打开。
///
/// **示例**
///
/// ```dart
/// final handle = TPopup.show(
///   context,
///   options: TPopupOptions.bottom(
///     titleWidget: const Text('标题'),
///     child: MyPanel(),
///   ),
/// );
/// handle.close();
/// handle.open();
/// ```
///
/// 配置项见 [TPopupOptions]；方向见 [TPopupPlacement]。
final class TPopup {
  const TPopup._();

  /// 打开浮层并压入独立 [PopupRoute]。
  ///
  /// [context] 用于查找 [Navigator] 并展示浮层。
  ///
  /// [options] 浮层配置；方向固定时推荐 [TPopupOptions.bottom] 等命名工厂。
  ///
  /// 返回 [TPopupHandle]，可用 [TPopupHandle.close]、[TPopupHandle.open]、
  /// [TPopupHandle.isShowing] 控制与查询。
  ///
  /// [navigatorContext] 可选，指定承载浮层的 [Navigator] 的 context，默认 [context]。
  ///
  /// [useRootNavigator] 为 true 时使用根 [Navigator]（嵌套导航场景）。
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

    final handle = TPopupHandle._(
      options: options,
      navigatorContext: navigatorContext,
      useRootNavigator: useRootNavigator,
    );
    handle.open(context);
    return handle;
  }
}
