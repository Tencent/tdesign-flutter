import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';
import 't_table_col.dart';
import 't_table_theme_data.dart';
import 't_table_types.dart';

/// 单元格点击回调。
typedef TTableCellTap<T> = void Function(
  int rowIndex,
  T row,
  TTableColumn<T> column,
);

/// 强类型、受控排序与选择的表格组件。
class TTable<T> extends StatelessWidget {
  const TTable({
    required this.columns,
    required this.data,
    this.selectionMode = TTableSelectionMode.none,
    this.selectedRows = const {},
    this.onSelectionChanged,
    this.rowSelectable,
    this.sort,
    this.onSortChanged,
    this.loading = false,
    this.loadingWidget,
    this.empty,
    this.footer,
    this.showHeader = true,
    this.onCellTap,
    this.onScroll,
    super.key,
  })  : assert(columns.length > 0),
        assert(selectionMode == TTableSelectionMode.none ||
            onSelectionChanged != null);

  /// 列配置。
  final List<TTableColumn<T>> columns;

  /// 行数据。
  final List<T> data;

  /// 行选择模式。
  final TTableSelectionMode selectionMode;

  /// 当前受控选中行。
  final Set<T> selectedRows;

  /// 请求更新选中行集合。
  final ValueChanged<Set<T>>? onSelectionChanged;

  /// 判断指定行是否可选。
  final bool Function(T row, int index)? rowSelectable;

  /// 当前受控排序值。
  final TTableSort? sort;

  /// 请求更新排序值。
  final ValueChanged<TTableSort?>? onSortChanged;

  /// 是否显示加载状态。
  final bool loading;

  /// 自定义加载内容。
  final Widget? loadingWidget;

  /// 空数据内容。
  final Widget? empty;

  /// 表格底部内容。
  final Widget? footer;

  /// 是否显示表头。
  final bool showHeader;

  /// 单元格点击回调。
  final TTableCellTap<T>? onCellTap;

  /// 垂直滚动通知。
  final ValueChanged<ScrollNotification>? onScroll;

  bool get _selectable => selectionMode == TTableSelectionMode.multiple;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TTableThemeData>();
    final rows = _sortedData();
    final left = columns
        .where((column) => column.fixed == TTableColumnFixed.left)
        .toList();
    final center = columns
        .where((column) => column.fixed == TTableColumnFixed.none)
        .toList();
    final right = columns
        .where((column) => column.fixed == TTableColumnFixed.right)
        .toList();
    final content = loading
        ? _buildLoading()
        : rows.isEmpty
            ? _buildEmpty()
            : _buildRows(context, theme, rows, left, center, right);

    final header = showHeader
        ? _buildHeader(context, theme, rows, left, center, right)
        : null;
    Widget table;
    if (theme?.height != null) {
      table = SizedBox(
        height: theme!.height,
        child: Column(
          children: [
            if (header != null) header,
            Expanded(child: content),
            if (footer != null) footer!,
          ],
        ),
      );
    } else {
      table = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null) header,
          content,
          if (footer != null) footer!,
        ],
      );
    }
    return SizedBox(width: theme?.width, child: table);
  }

  List<T> _sortedData() {
    final rows = List<T>.of(data);
    final currentSort = sort;
    if (currentSort == null) {
      return rows;
    }
    TTableColumn<T>? column;
    for (final candidate in columns) {
      if (candidate.id == currentSort.columnId) {
        column = candidate;
        break;
      }
    }
    final comparator = column?.comparator;
    if (comparator == null) {
      return rows;
    }
    rows.sort(currentSort.direction == TTableSortDirection.ascending
        ? comparator
        : (a, b) => comparator(b, a));
    return rows;
  }

  Widget _buildLoading() {
    return Center(
      child: loadingWidget ?? const CircularProgressIndicator(),
    );
  }

  Widget _buildEmpty() {
    return Center(child: empty ?? const SizedBox.shrink());
  }

  Widget _buildHeader(
    BuildContext context,
    TTableThemeData? theme,
    List<T> rows,
    List<TTableColumn<T>> left,
    List<TTableColumn<T>> center,
    List<TTableColumn<T>> right,
  ) {
    return SizedBox(
      height: theme?.headerHeight ?? 48,
      child: ColoredBox(
        color: theme?.headerColor ?? context.tTheme.bgColorSecondaryContainer,
        child: Row(
          children: [
            if (_selectable) _buildSelectAll(context, rows),
            ...left.map((column) => _buildHeaderCell(context, theme, column)),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: center
                      .map((column) => _buildHeaderCell(context, theme, column))
                      .toList(),
                ),
              ),
            ),
            ...right.map((column) => _buildHeaderCell(context, theme, column)),
          ],
        ),
      ),
    );
  }

  Widget _buildRows(
    BuildContext context,
    TTableThemeData? theme,
    List<T> rows,
    List<TTableColumn<T>> left,
    List<TTableColumn<T>> center,
    List<TTableColumn<T>> right,
  ) {
    final body = ListView.builder(
      shrinkWrap: theme?.height == null,
      itemCount: rows.length,
      itemBuilder: (context, index) {
        final row = rows[index];
        final striped = (theme?.stripe ?? false) && index.isOdd;
        return SizedBox(
          height: theme?.rowHeight ?? 48,
          child: ColoredBox(
            color: striped
                ? theme?.stripeColor ?? context.tTheme.bgColorSecondaryContainer
                : theme?.backgroundColor ?? context.tTheme.bgColorContainer,
            child: Row(
              children: [
                if (_selectable) _buildRowSelection(context, row, index),
                ...left.map(
                  (column) => _buildCell(context, theme, row, index, column),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: center
                          .map((column) =>
                              _buildCell(context, theme, row, index, column))
                          .toList(),
                    ),
                  ),
                ),
                ...right.map(
                  (column) => _buildCell(context, theme, row, index, column),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (onScroll == null) {
      return body;
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        onScroll!(notification);
        return false;
      },
      child: body,
    );
  }

  Widget _buildHeaderCell(
    BuildContext context,
    TTableThemeData? theme,
    TTableColumn<T> column,
  ) {
    final active = sort?.columnId == column.id;
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: column.header),
        if (column.comparator != null)
          Icon(
            active && sort?.direction == TTableSortDirection.descending
                ? Icons.arrow_downward
                : Icons.arrow_upward,
            size: 16,
          ),
      ],
    );
    return _cellFrame(
      context,
      theme,
      column.width,
      column.align,
      column.comparator == null
          ? content
          : InkWell(onTap: () => _requestSort(column), child: content),
    );
  }

  Widget _buildCell(
    BuildContext context,
    TTableThemeData? theme,
    T row,
    int rowIndex,
    TTableColumn<T> column,
  ) {
    final content = column.cellBuilder(context, row, rowIndex);
    return _cellFrame(
      context,
      theme,
      column.width,
      column.align,
      onCellTap == null
          ? content
          : InkWell(
              onTap: () => onCellTap!(rowIndex, row, column),
              child: content,
            ),
    );
  }

  Widget _cellFrame(
    BuildContext context,
    TTableThemeData? theme,
    double width,
    TTableColumnAlign align,
    Widget child,
  ) {
    final alignment = switch (align) {
      TTableColumnAlign.left => Alignment.centerLeft,
      TTableColumnAlign.center => Alignment.center,
      TTableColumnAlign.right => Alignment.centerRight,
    };
    return Container(
      width: width,
      height: double.infinity,
      alignment: alignment,
      padding: theme?.cellPadding ?? const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: theme?.bordered ?? false
            ? Border.all(
                color:
                    theme?.borderColor ?? context.tTheme.componentStrokeColor,
                width: 0.5,
              )
            : null,
      ),
      child: child,
    );
  }

  Widget _buildSelectAll(BuildContext context, List<T> rows) {
    final selectableRows = <T>{
      for (var index = 0; index < rows.length; index++)
        if (rowSelectable?.call(rows[index], index) ?? true) rows[index],
    };
    final selectedCount = selectableRows.intersection(selectedRows).length;
    return _selectionFrame(
      context,
      value:
          selectableRows.isNotEmpty && selectedCount == selectableRows.length,
      tristate: selectedCount > 0 && selectedCount < selectableRows.length,
      enabled: selectableRows.isNotEmpty,
      onChanged: (checked) {
        final next = Set<T>.of(selectedRows);
        if (checked == true) {
          next.addAll(selectableRows);
        } else {
          next.removeAll(selectableRows);
        }
        onSelectionChanged!(next);
      },
    );
  }

  Widget _buildRowSelection(BuildContext context, T row, int index) {
    final enabled = rowSelectable?.call(row, index) ?? true;
    return _selectionFrame(
      context,
      value: selectedRows.contains(row),
      enabled: enabled,
      onChanged: (checked) {
        final next = Set<T>.of(selectedRows);
        if (checked == true) {
          next.add(row);
        } else {
          next.remove(row);
        }
        onSelectionChanged!(next);
      },
    );
  }

  Widget _selectionFrame(
    BuildContext context, {
    required bool value,
    required bool enabled,
    required ValueChanged<bool?> onChanged,
    bool tristate = false,
  }) {
    return SizedBox(
      width: 48,
      height: double.infinity,
      child: CheckboxTheme(
        data: const CheckboxThemeData(
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Center(
          child: Checkbox(
            value: tristate ? null : value,
            tristate: tristate,
            onChanged: enabled ? onChanged : null,
          ),
        ),
      ),
    );
  }

  void _requestSort(TTableColumn<T> column) {
    if (onSortChanged == null) {
      return;
    }
    final nextDirection = sort?.columnId == column.id &&
            sort?.direction == TTableSortDirection.ascending
        ? TTableSortDirection.descending
        : TTableSortDirection.ascending;
    onSortChanged!(TTableSort(columnId: column.id, direction: nextDirection));
  }
}
