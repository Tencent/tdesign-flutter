import 'package:flutter/material.dart';

import '../../theme/td_colors.dart';
import '../../theme/td_spacers.dart';
import '../../theme/td_theme.dart';
import '../cell/td_cell.dart';
import '../cell/td_cell_group.dart';
import '../cell/td_cell_style.dart';
import '../icon/td_icons.dart';
import '../popup/td_popup_route.dart';

typedef TDDrawerItemClickCallback = void Function(int index, TDDrawerItem item);

/// 抽屉方向
enum TDDrawerPlacement { left, right }

/// 抽屉组件
class TDDrawer {
  TDDrawer(
    this.context, {
    this.closeOnOverlayClick,
    this.footer,
    this.items,
    this.placement,
    this.showOverlay,
    this.title,
    this.titleWidget,
    this.visible,
    this.onClose,
    this.onItemClick,
    this.width = 280,
    this.drawerTop,
    this.style,
    this.hover = true,
    this.backgroundColor,
    this.bordered = true,
    this.isShowLastBordered = true,
  }) {
    if (visible == true) {
      show();
    }
  }

  /// 上下文
  final BuildContext context;

  /// 点击蒙层时是否关闭抽屉
  final bool? closeOnOverlayClick;

  /// 抽屉的底部
  final Widget? footer;

  /// 抽屉里的列表项
  final List<TDDrawerItem>? items;

  /// 抽屉方向
  final TDDrawerPlacement? placement;

  /// 是否显示遮罩层
  final bool? showOverlay;

  /// 抽屉的标题
  final String? title;

  /// 抽屉的标题组件
  final Widget? titleWidget;

  /// 组件是否可见
  final bool? visible;

  /// 关闭时触发
  final VoidCallback? onClose;

  /// 点击抽屉里的列表项触发
  final TDDrawerItemClickCallback? onItemClick;

  /// 宽度
  final double? width;

  /// 距离顶部的距离
  final double? drawerTop;

  /// 列表自定义样式
  final TDCellStyle? style;

  /// 是否开启点击反馈
  final bool? hover;

  /// 组件背景颜色
  final Color? backgroundColor;

  /// 是否显示边框
  final bool? bordered;

  /// 是否显示最后一行分割线
  final bool? isShowLastBordered;

  static TDSlidePopupRoute? _drawerRoute;

  void show() {
    if (_drawerRoute != null) {
      return; // 如果抽屉已经显示了，就不要再显示
    }
    _drawerRoute = TDSlidePopupRoute(
      slideTransitionFrom: (placement ?? TDDrawerPlacement.right) == TDDrawerPlacement.right
          ? SlideTransitionFrom.right
          : SlideTransitionFrom.left,
      isDismissible: (showOverlay ?? true) ? (closeOnOverlayClick ?? true) : false,
      modalBarrierColor: (showOverlay ?? true) ? null : Colors.transparent,
      modalTop: drawerTop,
      builder: (context) {
        var cellStyle = style;
        if (cellStyle == null) {
          cellStyle = TDCellStyle.cellStyle(context);
          cellStyle.leftIconColor = TDTheme.of(context).fontGyColor1;
        }
        var cells = items
            ?.asMap()
            .map(
              (index, item) => MapEntry(
                index,
                TDCell(
                  titleWidget: item.content,
                  title: item.title,
                  leftIconWidget: item.icon,
                  hover: hover,
                  bordered: bordered,
                  onClick: (cell) {
                    if (onItemClick == null) {
                      return;
                    }
                    onItemClick!(index, items![index]);
                  },
                ),
              ),
            )
            .values
            .toList();
        return Container(
          color: backgroundColor ?? Colors.white,
          width: width ?? 280,
          height: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: TDCellGroup(
                  title: title,
                  titleWidget: titleWidget,
                  style: cellStyle,
                  scrollable: true,
                  isShowLastBordered: isShowLastBordered,
                  cells: cells ?? [],
                ),
              ),
              if (footer != null)
                Container(
                  padding: EdgeInsets.all(TDTheme.of(context).spacer16),
                  child: footer,
                ),
            ],
          ),
        );
      },
    );
    Navigator.of(context).push(_drawerRoute!).then((_) {
      // 当抽屉关闭时，将_drawerRoute置为null
      _deleteRouter();
    });
  }

  @mustCallSuper
  void close() {
    if (_drawerRoute != null) {
      Navigator.of(context).pop();
      // _deleteRouter();
    }
  }

  void _deleteRouter() {
    _drawerRoute = null;
    onClose?.call();
  }
}

/// 抽屉里的列表项
class TDDrawerItem {
  TDDrawerItem({this.title, this.icon, this.content});

  /// 每列标题
  final String? title;

  /// 每列图标
  final Widget? icon;

  /// 完全自定义
  final Widget? content;
}
