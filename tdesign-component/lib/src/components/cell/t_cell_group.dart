import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import 't_cell.dart';
import 't_cell_theme_data.dart';

/// 单元格包装构建器。
typedef TCellGroupBuilder = Widget Function(
  BuildContext context,
  TCell cell,
  int index,
);

/// 单元格组。
class TCellGroup extends StatelessWidget {
  const TCellGroup({
    required this.cells,
    this.title,
    this.variant,
    this.builder,
    this.scrollable = false,
    super.key,
  });

  /// 单元格列表。
  final List<TCell> cells;

  /// 组标题。
  final Widget? title;

  /// 组视觉形态；未设置时读取 Theme。
  final TCellGroupVariant? variant;

  /// 自定义单元格外层构建器。
  final TCellGroupBuilder? builder;

  /// 是否使用可滚动列表。
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TCellThemeData>();
    final resolvedVariant =
        variant ?? theme?.groupVariant ?? TCellGroupVariant.standard;
    final children = [
      for (var index = 0; index < cells.length; index++)
        _withDivider(
          context,
          theme,
          builder?.call(context, cells[index], index) ?? cells[index],
          index,
        ),
    ];
    final list = scrollable
        ? ListView(children: children)
        : Column(mainAxisSize: MainAxisSize.min, children: children);
    final content = Container(
      padding: resolvedVariant == TCellGroupVariant.card
          ? theme?.cardPadding ?? const EdgeInsets.symmetric(horizontal: 16)
          : null,
      decoration: BoxDecoration(
        border: theme?.groupBordered ?? false
            ? Border.all(
                color: theme?.groupBorderColor ??
                    context.tTheme.componentStrokeColor,
              )
            : null,
        borderRadius: resolvedVariant == TCellGroupVariant.card
            ? theme?.cardBorderRadius ?? BorderRadius.circular(8)
            : null,
      ),
      clipBehavior: resolvedVariant == TCellGroupVariant.card
          ? Clip.antiAlias
          : Clip.none,
      child: list,
    );
    return Column(
      mainAxisSize: scrollable ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: theme?.titlePadding ?? const EdgeInsets.all(16),
            child: DefaultTextStyle.merge(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: theme?.groupTitleStyle ??
                  TextStyle(
                    color: context.tTheme.textColorPrimary,
                    fontSize: context.tTheme.fontBodyMedium?.size ?? 14,
                    height: context.tTheme.fontBodyMedium?.height,
                    fontWeight: context.tTheme.fontBodyMedium?.fontWeight ??
                        FontWeight.w400,
                  ),
              child: title!,
            ),
          ),
        if (scrollable) Expanded(child: content) else content,
      ],
    );
  }

  Widget _withDivider(
    BuildContext context,
    TCellThemeData? theme,
    Widget child,
    int index,
  ) {
    final isLast = index == cells.length - 1;
    if (isLast && !(theme?.showLastDivider ?? false)) {
      return child;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        Divider(
          height: 0.5,
          thickness: 0.5,
          indent: 16,
          color: theme?.borderColor ?? context.tTheme.componentStrokeColor,
        ),
      ],
    );
  }
}
