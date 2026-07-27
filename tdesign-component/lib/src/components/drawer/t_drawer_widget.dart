import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../cell/t_cell.dart';
import '../cell/t_cell_group.dart';
import '../cell/t_cell_theme_data.dart';
import 't_drawer.dart';
import 't_drawer_theme_data.dart';

typedef TDrawerItemClickCallback = void Function(int index, TDrawerItem item);

/// 抽屉内容组件
/// 可用于 Scaffold 中的 drawer 属性
class TDrawerWidget extends StatelessWidget {
  const TDrawerWidget({
    super.key,
    this.footer,
    this.items,
    this.child,
    this.title,
    this.onItemClick,
    this.width,
    this.style,
    this.hover,
    this.backgroundColor,
    this.bordered,
    this.isShowLastBordered,
  });

  /// 抽屉的底部
  final Widget? footer;

  /// 抽屉里的列表项
  final List<TDrawerItem>? items;

  /// 自定义内容，优先级高于[items]/[footer]/[title]
  final Widget? child;

  /// 抽屉的标题组件
  final Widget? title;

  /// 点击抽屉里的列表项触发
  final TDrawerItemClickCallback? onItemClick;

  /// 宽度
  final double? width;

  /// 列表自定义样式
  final TCellThemeData? style;

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
    final drawerTheme = Theme.of(context).extension<TDrawerThemeData>();
    final effectiveWidth = width ?? drawerTheme?.width ?? 280;
    final effectiveHover = hover ?? drawerTheme?.hover ?? true;
    final effectiveBackgroundColor = backgroundColor ??
        drawerTheme?.backgroundColor ??
        context.tTheme.bgColorContainer;
    final effectiveBordered = bordered ?? drawerTheme?.bordered ?? true;
    final effectiveShowLastBordered =
        isShowLastBordered ?? drawerTheme?.isShowLastBordered ?? true;
    final effectiveStyle = style ?? drawerTheme?.style;
    var content = child;
    if (content == null) {
      final inheritedCellTheme = Theme.of(context).extension<TCellThemeData>();
      final cellStyle =
          (effectiveStyle ?? inheritedCellTheme ?? const TCellThemeData())
              .copyWith(
        groupBordered: effectiveBordered,
        showLastDivider: effectiveShowLastBordered,
      );
      var cells = items
          ?.asMap()
          .map(
            (index, item) => MapEntry(
              index,
              TCell(
                title: item.content ??
                    (item.title == null
                        ? null
                        : Text(
                            item.title!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                prefix: item.icon,
                enableFeedback: effectiveHover,
                onTap: () {
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
            child: Theme(
              data: Theme.of(context).mergeExtension(cellStyle),
              child: TCellGroup(
                title: title,
                scrollable: true,
                cells: cells ?? [],
              ),
            ),
          ),
          if (footer != null)
            Container(
              padding: EdgeInsets.all(context.tTheme.spacer16),
              child: footer,
            ),
        ],
      );
    }

    return Container(
      color: effectiveBackgroundColor,
      width: effectiveWidth,
      height: double.infinity,
      child: content,
    );
  }
}

/// 抽屉里的列表项
class TDrawerItem {
  TDrawerItem({this.title, this.icon, this.content});

  /// 每列标题
  final String? title;

  /// 每列图标
  final Widget? icon;

  /// 完全自定义
  final Widget? content;
}
