import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../empty/t_empty.dart';
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
class TTable<T> extends StatefulWidget {
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
    this.maxHeight,
    this.onCellTap,
    this.onScroll,
    super.key,
  })  : assert(columns.length > 0),
        assert(maxHeight == null || maxHeight > 0),
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

  /// 是否在表体上显示加载遮罩。
  final bool loading;

  /// 自定义加载内容。
  final Widget? loadingWidget;

  /// 空数据内容。
  final Widget? empty;

  /// 表格底部内容。
  final Widget? footer;

  /// 是否显示表头。
  final bool showHeader;

  /// 表体的最大可视高度；内容超过此高度时在表体内滚动。
  final double? maxHeight;

  /// 单元格点击回调。
  final TTableCellTap<T>? onCellTap;

  /// 垂直滚动通知。
  final ValueChanged<ScrollNotification>? onScroll;

  @override
  State<TTable<T>> createState() => _TTableState<T>();
}

class _TTableState<T> extends State<TTable<T>> {
  static const _loadingBodyHeight = 96.0;

  final _horizontalScroll = _TableScrollCoordinator();

  bool get _selectable => widget.selectionMode == TTableSelectionMode.multiple;

  @override
  void dispose() {
    _horizontalScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TTableThemeData>();
    final rows = _sortedData();
    final left = widget.columns
        .where((column) => column.fixed == TTableColumnFixed.left)
        .toList();
    final center = widget.columns
        .where((column) => column.fixed == TTableColumnFixed.none)
        .toList();
    final right = widget.columns
        .where((column) => column.fixed == TTableColumnFixed.right)
        .toList();

    return SizedBox(
      width: theme?.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showHeader)
            _buildHeader(context, theme, rows, left, center, right),
          _buildBody(context, theme, rows, left, center, right),
          if (widget.footer != null) widget.footer!,
        ],
      ),
    );
  }

  List<T> _sortedData() {
    final rows = List<T>.of(widget.data);
    final currentSort = widget.sort;
    if (currentSort == null) {
      return rows;
    }
    final column = widget.columns
        .where((candidate) => candidate.id == currentSort.columnId)
        .firstOrNull;
    final comparator = column?.comparator;
    if (comparator == null) {
      return rows;
    }
    rows.sort(currentSort.direction == TTableSortDirection.ascending
        ? comparator
        : (a, b) => comparator(b, a));
    return rows;
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
                controller: _horizontalScroll.headerController,
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

  Widget _buildBody(
    BuildContext context,
    TTableThemeData? theme,
    List<T> rows,
    List<TTableColumn<T>> left,
    List<TTableColumn<T>> center,
    List<TTableColumn<T>> right,
  ) {
    var content = rows.isEmpty
        ? widget.loading
            ? const SizedBox.shrink()
            : _buildEmpty(context)
        : _buildRows(context, theme, rows, left, center, right);
    if (widget.maxHeight != null && rows.isNotEmpty) {
      content = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: widget.maxHeight!),
        child: content,
      );
    }
    if (widget.loading && rows.isEmpty) {
      content = SizedBox(height: _loadingBodyHeight, child: content);
    }
    if (!widget.loading) {
      return content;
    }
    return Stack(
      fit: StackFit.passthrough,
      children: [
        content,
        Positioned.fill(
          child: AbsorbPointer(
            child: ColoredBox(
              color: (theme?.backgroundColor ?? context.tTheme.bgColorContainer)
                  .withValues(alpha: 0.72),
              child: Center(
                child:
                    widget.loadingWidget ?? const CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty(BuildContext context) => Center(
      child: widget.empty ?? TEmpty(emptyText: context.resource.emptyData));

  Widget _buildRows(
    BuildContext context,
    TTableThemeData? theme,
    List<T> rows,
    List<TTableColumn<T>> left,
    List<TTableColumn<T>> center,
    List<TTableColumn<T>> right,
  ) {
    final body = ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
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
                    controller: _horizontalScroll.rowController(index),
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
    if (widget.onScroll == null) {
      return body;
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis == Axis.vertical) {
          widget.onScroll!(notification);
        }
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
    final active = widget.sort?.columnId == column.id;
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: column.header),
        if (column.comparator != null)
          Icon(
            active && widget.sort?.direction == TTableSortDirection.descending
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
      child: column.comparator == null
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
      child: widget.onCellTap == null
          ? content
          : InkWell(
              onTap: () => widget.onCellTap!(rowIndex, row, column),
              child: content,
            ),
    );
  }

  Widget _cellFrame(
    BuildContext context,
    TTableThemeData? theme,
    double width,
    TTableColumnAlign align, {
    required Widget child,
  }) {
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
        border: _cellBorder(context, theme),
      ),
      child: child,
    );
  }

  Widget _buildSelectAll(BuildContext context, List<T> rows) {
    final selectableRows = <T>{
      for (var index = 0; index < rows.length; index++)
        if (widget.rowSelectable?.call(rows[index], index) ?? true) rows[index],
    };
    final selectedCount =
        selectableRows.intersection(widget.selectedRows).length;
    return _selectionFrame(
      context,
      value:
          selectableRows.isNotEmpty && selectedCount == selectableRows.length,
      tristate: selectedCount > 0 && selectedCount < selectableRows.length,
      enabled: selectableRows.isNotEmpty,
      onChanged: (checked) {
        final next = Set<T>.of(widget.selectedRows);
        if (checked == true) {
          next.addAll(selectableRows);
        } else {
          next.removeAll(selectableRows);
        }
        widget.onSelectionChanged!(next);
      },
    );
  }

  Widget _buildRowSelection(BuildContext context, T row, int index) {
    final enabled = widget.rowSelectable?.call(row, index) ?? true;
    return _selectionFrame(
      context,
      value: widget.selectedRows.contains(row),
      enabled: enabled,
      onChanged: (checked) {
        final next = Set<T>.of(widget.selectedRows);
        if (checked == true) {
          next.add(row);
        } else {
          next.remove(row);
        }
        widget.onSelectionChanged!(next);
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
    return Container(
      width: 48,
      height: double.infinity,
      decoration: BoxDecoration(border: _cellBorder(context, null)),
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

  Border _cellBorder(BuildContext context, TTableThemeData? theme) {
    final resolvedTheme =
        theme ?? Theme.of(context).extension<TTableThemeData>();
    final side = BorderSide(
      color: resolvedTheme?.borderColor ?? context.tTheme.componentStrokeColor,
      width: 0.5,
    );
    return resolvedTheme?.bordered ?? false
        ? Border.all(color: side.color, width: side.width)
        : Border(bottom: side);
  }

  void _requestSort(TTableColumn<T> column) {
    if (widget.onSortChanged == null) {
      return;
    }
    final currentSort = widget.sort;
    final TTableSort? nextSort;
    if (currentSort == null || currentSort.columnId != column.id) {
      nextSort = TTableSort(
        columnId: column.id,
        direction: TTableSortDirection.ascending,
      );
    } else if (currentSort.direction == TTableSortDirection.ascending) {
      nextSort = TTableSort(
        columnId: column.id,
        direction: TTableSortDirection.descending,
      );
    } else {
      nextSort = null;
    }
    widget.onSortChanged!(nextSort);
  }
}

/// 让表头和每个表体行共享横向偏移的私有协调器。
class _TableScrollCoordinator {
  final Map<int, ScrollController> _rowControllers = {};
  late final ScrollController headerController = _createController();

  double _offset = 0;
  bool _syncing = false;

  ScrollController rowController(int index) =>
      _rowControllers.putIfAbsent(index, _createController);

  ScrollController _createController() {
    final controller = ScrollController(initialScrollOffset: _offset);
    controller.addListener(() => _synchronize(controller));
    return controller;
  }

  void _synchronize(ScrollController source) {
    if (_syncing || !source.hasClients) {
      return;
    }
    _syncing = true;
    _offset = source.offset;
    for (final controller in [headerController, ..._rowControllers.values]) {
      if (identical(controller, source) || !controller.hasClients) {
        continue;
      }
      final target = _offset.clamp(
        controller.position.minScrollExtent,
        controller.position.maxScrollExtent,
      );
      if (controller.offset != target) {
        controller.jumpTo(target);
      }
    }
    _syncing = false;
  }

  void dispose() {
    headerController.dispose();
    for (final controller in _rowControllers.values) {
      controller.dispose();
    }
  }
}
