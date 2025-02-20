import 'package:flutter/material.dart';

import '../../theme/td_colors.dart';
import '../../theme/td_spacers.dart';
import '../../theme/td_theme.dart';
import '../cell/td_cell.dart';
import '../cell/td_cell_group.dart';
import '../cell/td_cell_style.dart';
import 'td_drawer.dart';

typedef TDDrawerItemClickCallback = void Function(int index, TDDrawerItem item);

/// 抽屉内容组件
/// 可用于Scaffold中的drawer属性
class TDDrawerWidget extends StatelessWidget {
  const TDDrawerWidget({
    super.key,
    this.footer,
    this.items,
    this.contentWidget,
    this.title,
    this.titleWidget,
    this.onItemClick,
    this.width = 280,
    this.style,
    this.hover = true,
    this.backgroundColor,
    this.bordered = true,
    this.isShowLastBordered = true,
  });

  /// 抽屉的底部
  final Widget? footer;

  /// 抽屉里的列表项
  final List<TDDrawerItem>? items;

  /// 自定义内容，优先级高于[items]/[footer]/[title]
  final Widget? contentWidget;

  /// 抽屉的标题
  final String? title;

  /// 抽屉的标题组件
  final Widget? titleWidget;

  /// 点击抽屉里的列表项触发
  final TDDrawerItemClickCallback? onItemClick;

  /// 宽度
  final double? width;

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

  @override
  Widget build(BuildContext context) {
    var content = contentWidget;
    if (content == null) {
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
      content = Column(
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
      );
    }
    return Container(
      color: backgroundColor ?? Colors.white,
      width: width ?? 280,
      height: double.infinity,
      child: content,
    );
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