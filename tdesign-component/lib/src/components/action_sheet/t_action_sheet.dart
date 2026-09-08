import 'package:flutter/material.dart';

import '../../util/context_extension.dart';
import '../popup/t_popup.dart';
import 't_action_sheet_grid.dart';
import 't_action_sheet_item.dart';
import 't_action_sheet_list.dart';
import 't_action_sheet_theme_data.dart';
import 't_action_sheet_types.dart';

export 't_action_sheet_item.dart';
export 't_action_sheet_types.dart';

enum _TActionSheetLayout { list, grid }

/// 动作面板命令式入口
final class TActionSheet {
  const TActionSheet._();

  /// 显示列表动作面板
  /// [context] 用于查找承载弹层的 Navigator。
  /// [items] 列表中的动作项目。
  /// [align] 项目文字对齐方式。
  /// [cancelText] 取消按钮文字。
  /// [subtitle] 面板副标题；为 null 或空字符串时不展示。
  /// [showCancel] 是否显示取消按钮。
  /// [showOverlay] 是否显示蒙层。
  /// [closeOnOverlayClick] 点击蒙层是否关闭。
  /// [useSafeArea] 是否避让系统安全区。
  /// [onCancel] 点击取消时回调。
  /// [onClosed] 面板关闭后回调。
  /// [onSelected] 点击动作时回调。
  static TPopupHandle showList<T>(
    BuildContext context, {
    required List<TActionSheetItem<T>> items,
    TActionSheetAlign align = TActionSheetAlign.center,
    String? cancelText,
    String? subtitle,
    bool showCancel = true,
    bool showOverlay = true,
    bool closeOnOverlayClick = true,
    bool useSafeArea = true,
    VoidCallback? onCancel,
    VoidCallback? onClosed,
    TActionSheetOnSelected<T>? onSelected,
  }) {
    return _show(
      context,
      layout: _TActionSheetLayout.list,
      items: items,
      align: align,
      cancelText: cancelText,
      subtitle: subtitle,
      showCancel: showCancel,
      showOverlay: showOverlay,
      closeOnOverlayClick: closeOnOverlayClick,
      useSafeArea: useSafeArea,
      onCancel: onCancel,
      onClosed: onClosed,
      onSelected: onSelected,
    );
  }

  /// 显示宫格动作面板
  /// [context] 用于查找承载弹层的 Navigator。
  /// [items] 宫格中的动作项目。
  /// [cancelText] 取消按钮文字。
  /// [subtitle] 面板副标题；为 null 或空字符串时不展示。
  /// [showCancel] 是否显示取消按钮。
  /// [showOverlay] 是否显示蒙层。
  /// [closeOnOverlayClick] 点击蒙层是否关闭。
  /// [useSafeArea] 是否避让系统安全区。
  /// [layout] 普通、分页或横向滚动宫格布局。
  /// [itemHeight] 宫格项目高度。
  /// [onCancel] 点击取消时回调。
  /// [onClosed] 面板关闭后回调。
  /// [onSelected] 点击动作时回调。
  static TPopupHandle showGrid<T>(
    BuildContext context, {
    required List<TActionSheetItem<T>> items,
    TActionSheetGridLayout layout = const TActionSheetGridLayout.fixed(),
    String? cancelText,
    String? subtitle,
    bool showCancel = true,
    bool showOverlay = true,
    bool closeOnOverlayClick = true,
    bool useSafeArea = true,
    double? itemHeight,
    VoidCallback? onCancel,
    VoidCallback? onClosed,
    TActionSheetOnSelected<T>? onSelected,
  }) {
    return _show(
      context,
      layout: _TActionSheetLayout.grid,
      items: items,
      cancelText: cancelText,
      subtitle: subtitle,
      showCancel: showCancel,
      showOverlay: showOverlay,
      closeOnOverlayClick: closeOnOverlayClick,
      useSafeArea: useSafeArea,
      gridLayout: layout,
      itemHeight: itemHeight,
      onCancel: onCancel,
      onClosed: onClosed,
      onSelected: onSelected,
    );
  }

  static TPopupHandle _show<T>(
    BuildContext context, {
    required _TActionSheetLayout layout,
    required List<TActionSheetItem<T>> items,
    TActionSheetAlign? align,
    String? cancelText,
    String? subtitle,
    bool showCancel = true,
    bool showOverlay = true,
    bool closeOnOverlayClick = true,
    bool useSafeArea = true,
    TActionSheetGridLayout gridLayout = const TActionSheetGridLayout.fixed(),
    double? itemHeight,
    VoidCallback? onCancel,
    VoidCallback? onClosed,
    TActionSheetOnSelected<T>? onSelected,
  }) {
    final theme = Theme.of(context).extension<TActionSheetThemeData>();
    final effectiveAlign = align ?? TActionSheetAlign.center;
    final effectiveCancelText = cancelText ?? context.resource.cancel;
    final effectiveItemHeight = itemHeight ?? theme?.gridItemHeight ?? 96;
    final popupHeight = switch (layout) {
      _TActionSheetLayout.list => TActionSheetList.preferredPopupHeight(
        context,
        items: items,
        subtitle: subtitle,
        showCancel: showCancel,
      ),
      _TActionSheetLayout.grid => TActionSheetGrid.preferredPopupHeight(
        context,
        subtitle: subtitle,
        layout: gridLayout,
        itemHeight: effectiveItemHeight,
        showCancel: showCancel,
      ),
    };

    final child = switch (layout) {
      _TActionSheetLayout.list => TActionSheetList<T>(
        items: items,
        align: effectiveAlign,
        cancelText: effectiveCancelText,
        subtitle: subtitle,
        showCancel: showCancel,
        onCancel: onCancel,
        onSelected: onSelected,
        // 命令式入口由 Popup 统一避让安全区，避免 List 重复添加底部内边距。
        useSafeArea: false,
      ),
      _TActionSheetLayout.grid => TActionSheetGrid<T>(
        items: items,
        layout: gridLayout,
        cancelText: effectiveCancelText,
        subtitle: subtitle,
        showCancel: showCancel,
        itemHeight: effectiveItemHeight,
        onCancel: onCancel,
        onSelected: onSelected,
        // 命令式入口由 Popup 统一避让安全区，避免 Grid 重复添加底部内边距。
        useSafeArea: false,
      ),
    };

    return TPopup.show(
      context,
      options: TPopupOptions.bottom(
        height: popupHeight,
        overlay: TPopupOverlayConfig(
          showOverlay: showOverlay,
          closeOnClick: showOverlay && closeOnOverlayClick,
          color: showOverlay ? theme?.barrierColor : Colors.transparent,
        ),
        radius: theme?.panelRadius,
        useSafeArea: useSafeArea,
        onClosed: onClosed,
        child: child,
      ),
    );
  }
}
