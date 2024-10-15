import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'td_action_sheet_grid.dart';
import 'td_action_sheet_list.dart';

typedef VoidCallback = void Function();
typedef ActionSheetTriggerSource = void Function();
typedef TDActionSheetItemCallback = void Function(
    TDActionSheetItem item, int index);

enum TDActionSheetTheme { list, grid }
enum TDActionSheetAlign { center, left, right }

class TDActionSheetItem {
  TDActionSheetItem({
    required this.label,
    this.textStyle,
    this.icon,
    this.badge,
    this.disabled = false,
  });

  final String label;
  final TextStyle? textStyle;
  final Widget? icon;
  final TDBadge? badge;
  final bool disabled;
}

class TDActionSheet {
  TDActionSheet(
    this.context, {
    this.align = TDActionSheetAlign.center,
    this.cancelText = '取消',
    this.count = 8,
    this.description,
    required this.items,
    this.showCancel = true,
    this.showPagination = false,
    this.theme = TDActionSheetTheme.list,
    this.visible = false,
    this.onCancel,
    this.onClose,
    this.onSelected,
  }) {
    if (visible) {
      show();
    }
  }

  /// 上下文
  final BuildContext context;

  /// 对齐方式
  final TDActionSheetAlign align;

  /// 取消按钮的文本
  final String cancelText;

  /// 每页显示的项目数
  final int count;

  /// 描述文本
  final String? description;

  /// ActionSheet的项目列表
  final List<TDActionSheetItem> items;

  /// 是否显示取消按钮
  final bool showCancel;

  /// 是否显示分页
  final bool showPagination;

  /// 主题样式
  final TDActionSheetTheme theme;

  /// 是否立即显示
  final bool visible;

  /// 取消按钮的回调函数
  final VoidCallback? onCancel;

  /// 关闭时的回调函数
  final ActionSheetTriggerSource? onClose;

  /// 选择项目时的回调函数
  final TDActionSheetItemCallback? onSelected;
  
  static TDSlidePopupRoute? _actionSheetRoute;

  /// 显示 ActionSheet
  void show() {
    if (_actionSheetRoute != null) {
      return;
    }
    _actionSheetRoute = _createRoute();
    Navigator.of(context).push(_actionSheetRoute!).then((_) {
      _deleteRoute();
    });
  }

  /// 创建路由
  TDSlidePopupRoute _createRoute() {
    return TDSlidePopupRoute(
      slideTransitionFrom: SlideTransitionFrom.bottom,
      isDismissible: true,
      modalBarrierColor: Colors.black54,
      builder: (context) {
        if (theme == TDActionSheetTheme.list) {
          return TDActionSheetList(
            items: items,
            align: align,
            cancelText: cancelText,
            description: description,
            showCancel: showCancel,
            onCancel: onCancel,
            onSelected: onSelected,
          );
        } else if (theme == TDActionSheetTheme.grid) {
          return TDActionSheetGrid(
            items: items,
            onSelected: onSelected,
            showCancel: showCancel,
            showPagination: showPagination,
            cancelText: cancelText,
            description: description,
            count: count,
            onCancel: onCancel,
          );
        }
        return Container();
      },
    );
  }

  /// 删除路由
  void _deleteRoute() {
    _actionSheetRoute = null;
    if (onClose != null) {
      onClose!();
    }
  }
}
