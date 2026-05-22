import 'package:flutter/material.dart';

import '../../util/context_extension.dart';
import '../popup/t_popup.dart';
import 't_action_sheet.dart';
import 't_action_sheet_grid.dart';
import 't_action_sheet_group.dart';
import 't_action_sheet_list.dart';

export 't_action_sheet_item.dart';

typedef TActionSheetItemCallback = void Function(
    TActionSheetItem item, int index);

enum TActionSheetTheme { list, grid, group }

enum TActionSheetAlign { center, left, right }

/// 动作面板
class TActionSheet {
  TActionSheet(
    this.context, {
    this.align = TActionSheetAlign.center,
    this.cancelText,
    this.count = 8,
    this.rows = 2,
    this.itemHeight = 96.0,
    this.itemMinWidth = 80.0,
    this.description,
    required this.items,
    this.showCancel = true,
    this.showPagination = false,
    this.scrollable = false,
    this.theme = TActionSheetTheme.list,
    this.visible = false,
    this.onCancel,
    this.onClose,
    this.onSelected,
    this.showOverlay = true,
    this.closeOnOverlayClick = true,
    this.useSafeArea = true,
  }) {
    if (visible) {
      show();
    }
  }

  /// 上下文
  final BuildContext context;

  /// 对齐方式
  final TActionSheetAlign align;

  /// 取消按钮的文本
  final String? cancelText;

  /// 每页显示的项目数
  /// 当[theme]等于[TActionSheetTheme.grid]且[showPagination]为true时有效
  final int count;

  /// 显示的行数
  /// 当[theme]等于[TActionSheetTheme.grid]时有效
  final int rows;

  /// 项目的行高
  /// 当[theme]等于[TActionSheetTheme.grid]或[theme]等于[TActionSheetTheme.group]时有效
  final double itemHeight;

  /// 项目的最小宽度
  /// 当[theme]等于[TActionSheetTheme.grid]且[scrollable]为true时有效
  /// 或当[theme]等于[TActionSheetTheme.group]时有效
  final double itemMinWidth;

  /// 描述文本
  /// 当[theme]等于[TActionSheetTheme.grid]或[theme]等于[TActionSheetTheme.list]时有效
  final String? description;

  /// ActionSheet的项目列表
  final List<TActionSheetItem> items;

  /// 是否显示取消按钮
  final bool showCancel;

  /// 是否显示遮罩层
  final bool showOverlay;

  /// 点击蒙层时是否关闭
  final bool closeOnOverlayClick;

  /// 主题样式
  final TActionSheetTheme theme;

  /// 是否立即显示
  final bool visible;

  /// 是否显示分页
  /// 当[theme]等于[TActionSheetTheme.grid]时有效
  final bool showPagination;

  /// 是否可以横向滚动
  /// 当[theme]等于[TActionSheetTheme.grid]且[showPagination]为false时有效
  final bool scrollable;

  /// 取消按钮的回调函数
  final VoidCallback? onCancel;

  /// 关闭时的回调函数
  final VoidCallback? onClose;

  /// 选择项目时的回调函数
  final TActionSheetItemCallback? onSelected;

  /// 使用安全区域
  final bool useSafeArea;

  static TPopupHandle? _actionSheetHandle;

  /// 显示列表类型面板
  static void showListActionSheet(
    BuildContext context, {
    required List<TActionSheetItem> items,
    TActionSheetAlign align = TActionSheetAlign.center,
    String? cancelText,
    bool showCancel = true,
    VoidCallback? onCancel,
    TActionSheetItemCallback? onSelected,
    bool showOverlay = true,
    bool closeOnOverlayClick = true,
    VoidCallback? onClose,
    bool useSafeArea = true,
  }) {
    _createRoute(
      context,
      theme: TActionSheetTheme.list,
      items: items,
      align: align,
      cancelText: cancelText,
      showCancel: showCancel,
      onSelected: onSelected,
      onCancel: onCancel,
      showOverlay: showOverlay,
      closeOnOverlayClick: closeOnOverlayClick,
      onClose: onClose,
      useSafeArea: useSafeArea,
    );
  }

  /// 显示宫格类型面板
  static void showGridActionSheet(
    BuildContext context, {
    required List<TActionSheetItem> items,
    TActionSheetAlign align = TActionSheetAlign.center,
    String? cancelText,
    bool showCancel = true,
    TActionSheetItemCallback? onSelected,
    bool showOverlay = true,
    bool closeOnOverlayClick = true,
    int count = 8,
    int rows = 2,
    double itemHeight = 96.0,
    double itemMinWidth = 80.0,
    bool scrollable = false,
    bool showPagination = false,
    VoidCallback? onCancel,
    String? description,
    VoidCallback? onClose,
    bool useSafeArea = true,
  }) {
    _createRoute(
      context,
      theme: TActionSheetTheme.grid,
      items: items,
      align: align,
      cancelText: cancelText,
      showCancel: showCancel,
      onSelected: onSelected,
      onCancel: onCancel,
      showOverlay: showOverlay,
      closeOnOverlayClick: closeOnOverlayClick,
      count: count,
      rows: rows,
      itemHeight: itemHeight,
      itemMinWidth: itemMinWidth,
      scrollable: scrollable,
      showPagination: showPagination,
      description: description,
      onClose: onClose,
      useSafeArea: useSafeArea,
    );
  }

  /// 显示分组类型面板
  static void showGroupActionSheet(
    BuildContext context, {
    required List<TActionSheetItem> items,
    TActionSheetAlign align = TActionSheetAlign.left,
    String? cancelText,
    bool showCancel = true,
    TActionSheetItemCallback? onSelected,
    bool showOverlay = true,
    bool closeOnOverlayClick = true,
    double itemHeight = 96.0,
    double itemMinWidth = 80.0,
    VoidCallback? onCancel,
    VoidCallback? onClose,
    bool useSafeArea = true,
  }) {
    _createRoute(
      context,
      theme: TActionSheetTheme.group,
      items: items,
      align: align,
      cancelText: cancelText,
      showCancel: showCancel,
      onSelected: onSelected,
      onCancel: onCancel,
      showOverlay: showOverlay,
      closeOnOverlayClick: closeOnOverlayClick,
      itemHeight: itemHeight,
      itemMinWidth: itemMinWidth,
      onClose: onClose,
      useSafeArea: useSafeArea,
    );
  }

  /// 显示动作面板
  void show() {
    TActionSheet._createRoute(
      context,
      theme: theme,
      items: items,
      align: align,
      cancelText: cancelText,
      showCancel: showCancel,
      onSelected: onSelected,
      onCancel: onCancel,
      showOverlay: showOverlay,
      closeOnOverlayClick: closeOnOverlayClick,
      count: count,
      rows: rows,
      itemHeight: itemHeight,
      itemMinWidth: itemMinWidth,
      scrollable: scrollable,
      showPagination: showPagination,
      description: description,
      onClose: onClose,
      useSafeArea: useSafeArea,
    );
  }

  void open() {
    show();
  }

  @mustCallSuper
  void close() {
    _actionSheetHandle?.close();
  }

  /// 创建路由
  static void _createRoute(
    BuildContext context, {
    required TActionSheetTheme theme,
    required List<TActionSheetItem> items,
    TActionSheetAlign align = TActionSheetAlign.center,
    String? cancelText,
    bool showCancel = true,
    TActionSheetItemCallback? onSelected,
    bool showOverlay = true,
    bool closeOnOverlayClick = true,
    int count = 8,
    int rows = 2,
    double itemHeight = 96.0,
    double itemMinWidth = 80.0,
    bool scrollable = false,
    bool showPagination = false,
    VoidCallback? onCancel,
    String? description,
    VoidCallback? onClose,
    bool useSafeArea = true,
  }) {
    if (_actionSheetHandle?.isShowing == true) {
      return;
    }

    cancelText = cancelText ?? context.resource.cancel;

    Widget sheetChild;
    switch (theme) {
      case TActionSheetTheme.list:
        sheetChild = TActionSheetList(
          items: items,
          align: align,
          cancelText: cancelText,
          description: description,
          showCancel: showCancel,
          onCancel: onCancel,
          onSelected: onSelected,
          useSafeArea: useSafeArea,
        );
        break;
      case TActionSheetTheme.grid:
        sheetChild = TActionSheetGrid(
          items: items,
          align: align,
          onSelected: onSelected,
          showCancel: showCancel,
          showPagination: showPagination,
          scrollable: scrollable,
          cancelText: cancelText,
          description: description,
          count: count,
          rows: rows,
          onCancel: onCancel,
          itemHeight: itemHeight,
          itemMinWidth: itemMinWidth,
          useSafeArea: useSafeArea,
        );
        break;
      case TActionSheetTheme.group:
        sheetChild = TActionSheetGroup(
          items: items,
          align: align,
          cancelText: cancelText,
          showCancel: showCancel,
          onCancel: onCancel,
          onSelected: onSelected,
          itemHeight: itemHeight,
          itemMinWidth: itemMinWidth,
          useSafeArea: useSafeArea,
        );
        break;
    }

    _actionSheetHandle = TPopup.show(
      context,
      options: TPopupOptions.bottom(
        cancelBuilder: null,
        confirmBuilder: null,
        showOverlay: showOverlay,
        closeOnOverlayClick: showOverlay && closeOnOverlayClick,
        overlayColor: showOverlay ? null : Colors.transparent,
        onClosed: onClose,
        child: sheetChild,
      ),
    );
  }
}
