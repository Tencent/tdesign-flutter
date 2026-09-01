/// TDesign 弹出层（Popup）组件库。
///
/// 对外 API：
/// * [TPopup] — 命令式打开浮层
/// * [TPopupOptions] — 配置（推荐命名工厂）
/// * [TPopupHandle] — 显隐控制
/// * [TPopupPlacement]、[TPopupTrigger] — 方向与关闭来源
/// * [TPopupHeaderBuilder]、[TPopupSlotBuilder]、[TPopupVisibleChangeCallback] — 构建器类型
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import 't_popup_theme_data.dart';

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

/// 弹出层入口：五向滑入 / 居中弹出，支持蒙层、可选 bottom 头部和
/// 可选 center 面板外下方关闭区。
///
/// 通过 [show] 命令式打开；返回 [TPopupHandle] 用于关闭与再次打开。
/// 多次调用 [show] 会继续压入新的浮层路由，可用于叠加展示。
///
/// **示例**
///
/// ```dart
/// final handle = TPopup.show(
///   context,
///   options: TPopupOptions.bottom(
///     headerBuilder: (context, close) => TPopupHeader(
///       title: const Text('标题'),
///     ),
///     child: MyPanel(),
///   ),
/// );
/// handle.close();
/// handle.open();
/// ```
///
/// 配置项见 [TPopupOptions]；方向见 [TPopupPlacement]。
final class TPopup {
  // 私有构造器：工具类仅暴露静态方法，无外部调用，标记为覆盖率例外（不可达死代码）。
  const TPopup._(); // coverage:ignore-line

  /// 打开浮层并压入独立 [PopupRoute]。
  ///
  /// [context] 用于查找 [Navigator] 并展示浮层。
  ///
  /// [options] 浮层配置；方向固定时推荐 [TPopupOptions.bottom] 等命名工厂。
  ///
  /// 返回 [TPopupHandle]，可用 [TPopupHandle.close]、[TPopupHandle.open]、
  /// [TPopupHandle.isShowing] 控制与查询。
  /// 重复调用会继续 push 新的浮层；若需互斥请在业务层管理。
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
    final theme = Theme.of(context).extension<TPopupThemeData>();
    final themedWidth = switch (options.placement) {
      TPopupPlacement.left || TPopupPlacement.right => theme?.drawerWidth,
      TPopupPlacement.center when !options.shrinkWrap =>
        theme?.centerSize?.width,
      TPopupPlacement.center => null,
      TPopupPlacement.top || TPopupPlacement.bottom => null,
    };
    final themedHeight = switch (options.placement) {
      TPopupPlacement.top || TPopupPlacement.bottom => theme?.edgeHeight,
      TPopupPlacement.center when !options.shrinkWrap =>
        theme?.centerSize?.height,
      TPopupPlacement.center => null,
      TPopupPlacement.left || TPopupPlacement.right => null,
    };
    final resolvedOptions = options.copyWith(
      width: options.width ?? themedWidth,
      height: options.height ?? themedHeight,
      radius: options.radius ?? theme?.panelRadius,
      backgroundColor: options.backgroundColor ?? theme?.panelBackgroundColor,
      overlay: _resolveOverlay(options.overlay, theme),
      animationDuration:
          options.animationDuration ??
          theme?.transitionDuration ??
          const Duration(milliseconds: 240),
    );
    final handle = TPopupHandle._(
      options: resolvedOptions,
      navigatorContext: navigatorContext,
      useRootNavigator: useRootNavigator,
      themeContext: context,
    );
    handle.open(navContext);
    return handle;
  }

  /// 将 theme 的 barrier 值合并进 overlay 配置。
  static TPopupOverlayConfig? _resolveOverlay(
    TPopupOverlayConfig? overlay,
    TPopupThemeData? theme,
  ) {
    final themeColor = theme?.barrierColor;
    final themeOpacity = theme?.barrierOpacity;
    if (overlay == null) {
      if (themeColor == null && themeOpacity == null) {
        return null;
      }
      return TPopupOverlayConfig(color: themeColor, opacity: themeOpacity);
    }
    if (overlay.color != null && overlay.opacity != null) {
      return overlay;
    }
    return TPopupOverlayConfig(
      showOverlay: overlay.showOverlay,
      color: overlay.color ?? themeColor,
      opacity: overlay.opacity ?? themeOpacity,
      preventTap: overlay.preventTap,
      closeOnClick: overlay.closeOnClick,
      onClick: overlay.onClick,
    );
  }
}
