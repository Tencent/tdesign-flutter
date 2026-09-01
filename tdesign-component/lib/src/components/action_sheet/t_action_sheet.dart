import 'package:flutter/material.dart';

import '../../util/context_extension.dart';
import '../popup/t_popup.dart';
import 't_action_sheet_grid.dart';
import 't_action_sheet_group.dart';
import 't_action_sheet_item.dart';
import 't_action_sheet_list.dart';
import 't_action_sheet_theme_data.dart';
import 't_action_sheet_types.dart';

export 't_action_sheet_item.dart';
export 't_action_sheet_types.dart';

enum _TActionSheetLayout { list, grid, group }

/// 动作面板命令式入口
final class TActionSheet {
  const TActionSheet._();

  /// 显示列表动作面板
  /// [context] 用于查找承载弹层的 Navigator。
  /// [items] 列表中的动作项目。
  /// [align] 项目文字对齐方式。
  /// [cancelText] 取消按钮文字。
  /// [subtitle] 面板副标题。
  /// [showCancel] 是否显示取消按钮。
  /// [showOverlay] 是否显示蒙层。
  /// [closeOnOverlayClick] 点击蒙层是否关闭。
  /// [useSafeArea] 是否避让系统安全区。
  /// [onCancel] 点击取消时回调。
  /// [onClosed] 面板关闭后回调。
  /// [onChanged] 点击动作时回调。
  static TPopupHandle showList(
    BuildContext context, {
    required List<TActionSheetItem> items,
    TActionSheetAlign? align,
    String? cancelText,
    String? subtitle,
    bool showCancel = true,
    bool showOverlay = true,
    bool closeOnOverlayClick = true,
    bool useSafeArea = true,
    VoidCallback? onCancel,
    VoidCallback? onClosed,
    TActionSheetOnChanged? onChanged,
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
      onChanged: onChanged,
    );
  }

  /// 显示宫格动作面板
  /// [context] 用于查找承载弹层的 Navigator。
  /// [items] 宫格中的动作项目。
  /// [align] 项目对齐方式。
  /// [cancelText] 取消按钮文字。
  /// [subtitle] 面板副标题。
  /// [showCancel] 是否显示取消按钮。
  /// [showOverlay] 是否显示蒙层。
  /// [closeOnOverlayClick] 点击蒙层是否关闭。
  /// [useSafeArea] 是否避让系统安全区。
  /// [showPagination] 是否显示分页指示器。
  /// [scrollable] 是否允许滚动。
  /// [count] 每页项目数。
  /// [rows] 宫格行数。
  /// [itemHeight] 项目高度。
  /// [itemMinWidth] 项目最小宽度。
  /// [onCancel] 点击取消时回调。
  /// [onClosed] 面板关闭后回调。
  /// [onChanged] 点击动作时回调。
  static TPopupHandle showGrid(
    BuildContext context, {
    required List<TActionSheetItem> items,
    TActionSheetAlign? align,
    String? cancelText,
    String? subtitle,
    bool showCancel = true,
    bool showOverlay = true,
    bool closeOnOverlayClick = true,
    bool useSafeArea = true,
    bool showPagination = false,
    bool scrollable = false,
    int? count,
    int? rows,
    double? itemHeight,
    double? itemMinWidth,
    VoidCallback? onCancel,
    VoidCallback? onClosed,
    TActionSheetOnChanged? onChanged,
  }) {
    return _show(
      context,
      layout: _TActionSheetLayout.grid,
      items: items,
      align: align,
      cancelText: cancelText,
      subtitle: subtitle,
      showCancel: showCancel,
      showOverlay: showOverlay,
      closeOnOverlayClick: closeOnOverlayClick,
      useSafeArea: useSafeArea,
      showPagination: showPagination,
      scrollable: scrollable,
      count: count,
      rows: rows,
      itemHeight: itemHeight,
      itemMinWidth: itemMinWidth,
      onCancel: onCancel,
      onClosed: onClosed,
      onChanged: onChanged,
    );
  }

  /// 显示分组动作面板
  /// [context] 用于查找承载弹层的 Navigator。
  /// [items] 分组中的动作项目。
  /// [align] 项目对齐方式。
  /// [cancelText] 取消按钮文字。
  /// [showCancel] 是否显示取消按钮。
  /// [showOverlay] 是否显示蒙层。
  /// [closeOnOverlayClick] 点击蒙层是否关闭。
  /// [useSafeArea] 是否避让系统安全区。
  /// [itemHeight] 项目高度。
  /// [itemMinWidth] 项目最小宽度。
  /// [onCancel] 点击取消时回调。
  /// [onClosed] 面板关闭后回调。
  /// [onChanged] 点击动作时回调。
  static TPopupHandle showGroup(
    BuildContext context, {
    required List<TActionSheetItem> items,
    TActionSheetAlign? align,
    String? cancelText,
    bool showCancel = true,
    bool showOverlay = true,
    bool closeOnOverlayClick = true,
    bool useSafeArea = true,
    double? itemHeight,
    double? itemMinWidth,
    VoidCallback? onCancel,
    VoidCallback? onClosed,
    TActionSheetOnChanged? onChanged,
  }) {
    return _show(
      context,
      layout: _TActionSheetLayout.group,
      items: items,
      align: align,
      cancelText: cancelText,
      showCancel: showCancel,
      showOverlay: showOverlay,
      closeOnOverlayClick: closeOnOverlayClick,
      useSafeArea: useSafeArea,
      itemHeight: itemHeight,
      itemMinWidth: itemMinWidth,
      onCancel: onCancel,
      onClosed: onClosed,
      onChanged: onChanged,
    );
  }

  static TPopupHandle _show(
    BuildContext context, {
    required _TActionSheetLayout layout,
    required List<TActionSheetItem> items,
    TActionSheetAlign? align,
    String? cancelText,
    String? subtitle,
    bool showCancel = true,
    bool showOverlay = true,
    bool closeOnOverlayClick = true,
    bool useSafeArea = true,
    bool showPagination = false,
    bool scrollable = false,
    int? count,
    int? rows,
    double? itemHeight,
    double? itemMinWidth,
    VoidCallback? onCancel,
    VoidCallback? onClosed,
    TActionSheetOnChanged? onChanged,
  }) {
    final theme = Theme.of(context).extension<TActionSheetThemeData>();
    final effectiveAlign =
        align ?? theme?.defaultAlign ?? TActionSheetAlign.center;
    final effectiveCancelText = cancelText ?? context.resource.cancel;
    final effectiveCount = count ?? theme?.count ?? 8;
    final effectiveRows = rows ?? theme?.rows ?? 2;
    final effectiveItemHeight = itemHeight ?? theme?.itemHeight ?? 96;
    final effectiveItemMinWidth = itemMinWidth ?? theme?.itemMinWidth ?? 80;
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
        rows: effectiveRows,
        itemHeight: effectiveItemHeight,
        showPagination: showPagination,
        showCancel: showCancel,
      ),
      _TActionSheetLayout.group => null,
    };

    final child = switch (layout) {
      _TActionSheetLayout.list => TActionSheetList(
        items: items,
        align: effectiveAlign,
        cancelText: effectiveCancelText,
        subtitle: subtitle,
        showCancel: showCancel,
        onCancel: onCancel,
        onChanged: onChanged,
        // 命令式入口由 Popup 统一避让安全区，避免 List 重复添加底部内边距。
        useSafeArea: false,
      ),
      _TActionSheetLayout.grid => TActionSheetGrid(
        items: items,
        align: effectiveAlign,
        cancelText: effectiveCancelText,
        subtitle: subtitle,
        showCancel: showCancel,
        showPagination: showPagination,
        scrollable: scrollable,
        count: effectiveCount,
        rows: effectiveRows,
        itemHeight: effectiveItemHeight,
        itemMinWidth: effectiveItemMinWidth,
        onCancel: onCancel,
        onChanged: onChanged,
        // 命令式入口由 Popup 统一避让安全区，避免 Grid 重复添加底部内边距。
        useSafeArea: false,
      ),
      _TActionSheetLayout.group => TActionSheetGroup(
        items: items,
        align: effectiveAlign,
        cancelText: effectiveCancelText,
        showCancel: showCancel,
        itemHeight: effectiveItemHeight,
        itemMinWidth: effectiveItemMinWidth,
        onCancel: onCancel,
        onChanged: onChanged,
        // 命令式入口由 Popup 统一避让安全区，避免 Group 重复添加底部内边距。
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
