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
import '../text/t_text_style_scope.dart';
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

/// 弹出层入口。
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
final class TPopup {
  // 私有构造器：工具类仅暴露静态方法，无外部调用，标记为覆盖率例外（不可达死代码）。
  const TPopup._(); // coverage:ignore-line

  /// 打开浮层，返回用于关闭、重新打开和查询状态的 [TPopupHandle]。
  ///
  /// | 调用情况 | 行为 |
  /// | --- | --- |
  /// | 重复调用 | 每次创建独立浮层，可叠加展示 |
  /// | 参数与方向不匹配 | 抛出 [FlutterError] |
  ///
  /// [context] 用于查找 [Navigator] 并获取局部主题。
  ///
  /// [options] 浮层配置。
  ///
  /// [navigatorContext] 承载浮层的导航上下文；未指定时使用 [context]。
  ///
  /// [useRootNavigator] 是否使用根 [Navigator]。
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
      TPopupPlacement.center => theme?.centerSize?.width,
      TPopupPlacement.top || TPopupPlacement.bottom => null,
    };
    final themedHeight = switch (options.placement) {
      TPopupPlacement.top || TPopupPlacement.bottom => theme?.edgeHeight,
      TPopupPlacement.center => theme?.centerSize?.height,
      TPopupPlacement.left || TPopupPlacement.right => null,
    };
    final resolvedOptions = options.copyWith(
      width: options.width ?? themedWidth,
      height: options.height ?? themedHeight,
      radius: options.radius ?? theme?.panelRadius,
      backgroundColor: options.backgroundColor ?? theme?.panelBackgroundColor,
      overlay: _resolveOverlay(options.overlay, theme),
      animationDuration:
          options.animationDuration ?? const Duration(milliseconds: 240),
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
    if (overlay == null) {
      if (themeColor == null) {
        return null;
      }
      return TPopupOverlayConfig(color: themeColor);
    }
    if (overlay.color != null) {
      return overlay;
    }
    return TPopupOverlayConfig(
      showOverlay: overlay.showOverlay,
      color: overlay.color ?? themeColor,
      preventTap: overlay.preventTap,
      closeOnClick: overlay.closeOnClick,
      onClick: overlay.onClick,
    );
  }
}
