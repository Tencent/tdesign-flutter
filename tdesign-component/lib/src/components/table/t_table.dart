import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../checkbox/t_check_box.dart';
import '../empty/t_empty.dart';
import '../icon/t_icon.dart';
import '../loading/t_loading.dart';
import 't_table_col.dart';
import 't_table_theme_data.dart';
import 't_table_types.dart';

/// 行点击回调。
typedef TTableRowTap<T> = void Function(int rowIndex, T row);

/// 强类型、受控排序与选择的表格组件。
///
/// ```dart
/// TTable<Map<String, Object>>(
///   data: const [
///     {'id': 1, 'name': 'Alice'},
///     {'id': 2, 'name': 'Bob'},
///   ],
///   rowKey: (row) => row['id']!,
///   columns: [
///     TTableColumn(
///       id: 'name',
///       header: const Text('Name'),
///       minWidth: 120,
///       cellBuilder: (_, row, __) => Text(row['name']! as String),
///     ),
///   ],
///   onCellTap: (cell) => debugPrint('${cell.columnIndex}: ${cell.row}'),
/// )
/// ```
class TTable<T> extends StatefulWidget {
  const TTable({
    required this.columns,
    required this.data,
    this.rowKey,
    this.cellSpanBuilder,
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
    this.height,
    this.maxHeight,
    this.bordered,
    this.stripe,
    this.onCellTap,
    this.onRowTap,
    this.onScroll,
    super.key,
  }) : assert(columns.length > 0),
       assert(height == null || height > 0),
       assert(maxHeight == null || maxHeight > 0),
       assert(height == null || maxHeight == null),
       assert(
         selectionMode == TTableSelectionMode.none ||
             onSelectionChanged != null,
       );

  /// 列配置。
  final List<TTableColumn<T>> columns;

  /// 行数据。
  final List<T> data;

  /// 返回行数据的稳定唯一标识。
  ///
  /// 为空时直接使用行对象及其 `==`、`hashCode` 语义。提供后，受控选择会按
  /// key 匹配、替换和移除行，并稳定标识单元格子树，使数据刷新或排序后新建的
  /// 行对象仍能命中同一业务行。同一份 [data] 中的 key 必须唯一；未提供时单元格
  /// 子树按可见行位置标识。
  final TTableRowKey<T>? rowKey;

  /// 返回逻辑单元格的行列跨度。
  ///
  /// 为空时所有单元格跨度均为 `1 × 1`。该回调仅为尚未被其他合并区域覆盖的
  /// 坐标调用；返回 `null` 等同于 [TTableCellSpan] 的默认值。跨度不得越界、重叠，
  /// 也不得跨越左固定区、水平滚动区和右固定区。
  final TTableCellSpanBuilder<T>? cellSpanBuilder;

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

  /// 表格固定高度。
  ///
  /// 表头和 [footer] 占用空间后，剩余高度作为表体的垂直滚动视口。与
  /// [maxHeight] 互斥；为空时表格随内容自然增长。
  final double? height;

  /// 表体的最大可视高度；内容超过此高度时在表体内滚动。
  final double? maxHeight;

  /// 是否显示完整单元格边框。
  ///
  /// 为空时读取 [TTableThemeData.bordered]，最后回退为 `false`。
  final bool? bordered;

  /// 是否为奇数数据行显示斑马纹背景。
  ///
  /// 为空时读取 [TTableThemeData.stripe]，最后回退为 `false`。
  final bool? stripe;

  /// 单元格点击回调，context 同时提供行列索引、行数据和列配置。
  final TTableCellTap<T>? onCellTap;

  /// 行点击回调。
  ///
  /// 点击普通单元格时，会在 [onCellTap] 之后调用该回调；点击选择控件时不触发。
  final TTableRowTap<T>? onRowTap;

  /// 垂直滚动通知。
  final ValueChanged<ScrollNotification>? onScroll;

  @override
  State<TTable<T>> createState() => _TTableState<T>();
}

class _TTableState<T> extends State<TTable<T>> {
  static const _loadingBodyHeight = 96.0;
  static const _selectionColumnWidth = 48.0;
  static const _defaultColumnWidth = 120.0;
  static const _defaultRowHeight = 38.0;
  static const _defaultHeaderHeight = 38.0;

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
    assert(_debugValidateRowKeys(rows));
    final naturalWidth =
        widget.columns.fold<double>(
          0,
          (total, column) =>
              total +
              (column.width == null
                  ? (column.minWidth ?? _defaultColumnWidth)
                  : _resolvedExplicitWidth(column)),
        ) +
        (_selectable ? _selectionColumnWidth : 0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            theme?.width ??
            (constraints.hasBoundedWidth ? constraints.maxWidth : naturalWidth);
        final resolvedColumns = _resolveColumns(width);
        final left = resolvedColumns
            .where((column) => column.value.fixed == TTableColumnFixed.left)
            .toList();
        final center = resolvedColumns
            .where((column) => column.value.fixed == TTableColumnFixed.none)
            .toList();
        final right = resolvedColumns
            .where((column) => column.value.fixed == TTableColumnFixed.right)
            .toList();
        final grid = _resolveGrid(rows, resolvedColumns);
        final children = <Widget>[
          if (widget.showHeader)
            _buildHeader(context, theme, rows, left, center, right),
          if (widget.height != null)
            Expanded(
              child: _buildBody(
                context,
                theme,
                rows,
                grid,
                left,
                center,
                right,
              ),
            )
          else
            _buildBody(context, theme, rows, grid, left, center, right),
          if (widget.footer != null) widget.footer!,
        ];
        return SizedBox(
          width: width,
          height: widget.height,
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        );
      },
    );
  }

  List<_ResolvedTableColumn<T>> _resolveColumns(double tableWidth) {
    final availableWidth =
        (tableWidth - (_selectable ? _selectionColumnWidth : 0)).clamp(
          0.0,
          double.infinity,
        );
    final explicitWidth = widget.columns.fold<double>(
      0,
      (total, column) =>
          total + (column.width == null ? 0 : _resolvedExplicitWidth(column)),
    );
    final flexibleColumns = widget.columns
        .where((column) => column.width == null)
        .toList();
    final flexibleWidths = _resolveFlexibleWidths(
      flexibleColumns,
      availableWidth - explicitWidth,
    );
    var flexibleIndex = 0;
    return [
      for (var index = 0; index < widget.columns.length; index++)
        if (widget.columns[index].width != null)
          _ResolvedTableColumn(
            widget.columns[index],
            index,
            _resolvedExplicitWidth(widget.columns[index]),
          )
        else
          _ResolvedTableColumn(
            widget.columns[index],
            index,
            flexibleWidths[flexibleIndex++],
          ),
    ];
  }

  double _resolvedExplicitWidth(TTableColumn<T> column) {
    final width = column.width!;
    final minWidth = column.minWidth;
    return minWidth != null && minWidth > width ? minWidth : width;
  }

  List<double> _resolveFlexibleWidths(
    List<TTableColumn<T>> columns,
    double availableWidth,
  ) {
    if (columns.isEmpty) {
      return const [];
    }
    final widths = <double>[for (final column in columns) column.minWidth ?? 0];
    final unresolved = <int>{
      for (var index = 0; index < columns.length; index++) index,
    };
    var remaining = availableWidth;
    while (unresolved.isNotEmpty) {
      final share = remaining > 0
          ? remaining / unresolved.length
          : _defaultColumnWidth;
      final constrained = unresolved
          .where((index) => widths[index] > share)
          .toList();
      if (constrained.isEmpty) {
        for (final index in unresolved) {
          widths[index] = share;
        }
        break;
      }
      for (final index in constrained) {
        remaining -= widths[index];
        unresolved.remove(index);
      }
    }
    return widths;
  }

  _ResolvedTableGrid<T> _resolveGrid(
    List<T> rows,
    List<_ResolvedTableColumn<T>> columns,
  ) {
    final occupied = List.generate(
      rows.length,
      (_) => List<bool>.filled(columns.length, false),
    );
    final cells = <_ResolvedTableCell<T>>[];
    for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) {
      for (var columnIndex = 0; columnIndex < columns.length; columnIndex++) {
        if (occupied[rowIndex][columnIndex]) {
          continue;
        }
        final context = TTableCellContext<T>(
          row: rows[rowIndex],
          rowIndex: rowIndex,
          column: columns[columnIndex].value,
          columnIndex: columnIndex,
        );
        final span =
            widget.cellSpanBuilder?.call(context) ?? const TTableCellSpan();
        _validateSpan(
          span,
          rowIndex,
          columnIndex,
          rows.length,
          columns,
          occupied,
        );
        for (
          var targetRow = rowIndex;
          targetRow < rowIndex + span.rowSpan;
          targetRow++
        ) {
          for (
            var targetColumn = columnIndex;
            targetColumn < columnIndex + span.columnSpan;
            targetColumn++
          ) {
            occupied[targetRow][targetColumn] = true;
          }
        }
        cells.add(_ResolvedTableCell(context, span));
      }
    }
    return _ResolvedTableGrid(rowCount: rows.length, cells: cells);
  }

  void _validateSpan(
    TTableCellSpan span,
    int rowIndex,
    int columnIndex,
    int rowCount,
    List<_ResolvedTableColumn<T>> columns,
    List<List<bool>> occupied,
  ) {
    if (span.rowSpan <= 0 || span.columnSpan <= 0) {
      throw FlutterError('TTableCellSpan 的 rowSpan 和 columnSpan 必须大于 0。');
    }
    if (rowIndex + span.rowSpan > rowCount ||
        columnIndex + span.columnSpan > columns.length) {
      throw FlutterError(
        'TTableCellSpan 不能超出表格范围：起点 ($rowIndex, $columnIndex)，'
        '跨度 (${span.rowSpan}, ${span.columnSpan})。',
      );
    }
    final fixed = columns[columnIndex].value.fixed;
    for (
      var targetColumn = columnIndex;
      targetColumn < columnIndex + span.columnSpan;
      targetColumn++
    ) {
      if (columns[targetColumn].value.fixed != fixed) {
        throw FlutterError('TTableCellSpan 不能跨越固定列区域与水平滚动区域。');
      }
    }
    for (
      var targetRow = rowIndex;
      targetRow < rowIndex + span.rowSpan;
      targetRow++
    ) {
      for (
        var targetColumn = columnIndex;
        targetColumn < columnIndex + span.columnSpan;
        targetColumn++
      ) {
        if (occupied[targetRow][targetColumn]) {
          throw FlutterError(
            'TTableCellSpan 与已有合并区域重叠：($targetRow, $targetColumn)。',
          );
        }
      }
    }
  }

  bool _debugValidateRowKeys(List<T> rows) {
    if (widget.rowKey == null) {
      return true;
    }
    final keys = <Object?>{};
    for (final row in rows) {
      final key = _rowIdentity(row);
      if (!keys.add(key)) {
        throw FlutterError('TTable.rowKey 必须为每行返回唯一值，重复值：$key。');
      }
    }
    return true;
  }

  Object? _rowIdentity(T row) => widget.rowKey?.call(row) ?? row;

  Object? _rowElementIdentity(T row, int rowIndex) =>
      widget.rowKey?.call(row) ?? rowIndex;

  bool _isRowSelected(T row) {
    final key = _rowIdentity(row);
    return widget.selectedRows.any((selected) => _rowIdentity(selected) == key);
  }

  Set<T> _withoutRowKeys(Set<T> rows, Set<Object?> keys) => {
    for (final row in rows)
      if (!keys.contains(_rowIdentity(row))) row,
  };

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
    rows.sort(
      currentSort.direction == TTableSortDirection.ascending
          ? comparator
          : (a, b) => comparator(b, a),
    );
    return rows;
  }

  Widget _buildHeader(
    BuildContext context,
    TTableThemeData? theme,
    List<T> rows,
    List<_ResolvedTableColumn<T>> left,
    List<_ResolvedTableColumn<T>> center,
    List<_ResolvedTableColumn<T>> right,
  ) {
    return SizedBox(
      height: theme?.headerHeight ?? _defaultHeaderHeight,
      child: ColoredBox(
        color: theme?.headerColor ?? context.tTheme.bgColorContainer,
        child: Row(
          children: [
            if (_selectable) _buildSelectAll(context, rows),
            for (var index = 0; index < left.length; index++)
              _buildHeaderCell(
                context,
                theme,
                left[index],
                trailingBoundary: index == left.length - 1,
              ),
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
            for (var index = 0; index < right.length; index++)
              _buildHeaderCell(
                context,
                theme,
                right[index],
                leadingBoundary: index == 0,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    TTableThemeData? theme,
    List<T> rows,
    _ResolvedTableGrid<T> grid,
    List<_ResolvedTableColumn<T>> left,
    List<_ResolvedTableColumn<T>> center,
    List<_ResolvedTableColumn<T>> right,
  ) {
    var content = rows.isEmpty
        ? widget.loading
              ? const SizedBox.shrink()
              : _buildEmpty(context)
        : _buildRows(context, theme, rows, grid, left, center, right);
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
              child: Center(child: widget.loadingWidget ?? const TLoading()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty(BuildContext context) => Center(
    child: widget.empty ?? TEmpty(emptyText: context.resource.emptyData),
  );

  Widget _buildRows(
    BuildContext context,
    TTableThemeData? theme,
    List<T> rows,
    _ResolvedTableGrid<T> grid,
    List<_ResolvedTableColumn<T>> left,
    List<_ResolvedTableColumn<T>> center,
    List<_ResolvedTableColumn<T>> right,
  ) {
    final rowHeight = theme?.rowHeight ?? _defaultRowHeight;
    final content = SizedBox(
      height: rowHeight * rows.length,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectable)
            SizedBox(
              width: _selectionColumnWidth,
              child: Column(
                children: [
                  for (var index = 0; index < rows.length; index++)
                    SizedBox(
                      key: ValueKey((
                        'selection',
                        _rowElementIdentity(rows[index], index),
                      )),
                      height: rowHeight,
                      child: ColoredBox(
                        color: _rowColor(context, theme, index),
                        child: _buildRowSelection(context, rows[index], index),
                      ),
                    ),
                ],
              ),
            ),
          _buildPane(context, theme, grid, left, rowHeight),
          Expanded(
            child: SingleChildScrollView(
              controller: _horizontalScroll.bodyController,
              scrollDirection: Axis.horizontal,
              child: _buildPane(context, theme, grid, center, rowHeight),
            ),
          ),
          _buildPane(context, theme, grid, right, rowHeight),
        ],
      ),
    );
    var body = widget.height != null || widget.maxHeight != null
        ? SingleChildScrollView(child: content)
        : content;
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

  Widget _buildPane(
    BuildContext context,
    TTableThemeData? theme,
    _ResolvedTableGrid<T> grid,
    List<_ResolvedTableColumn<T>> columns,
    double rowHeight,
  ) {
    if (columns.isEmpty) {
      return const SizedBox.shrink();
    }
    final columnIndexes = columns.map((column) => column.index).toSet();
    final offsets = <int, double>{};
    var paneWidth = 0.0;
    for (final column in columns) {
      offsets[column.index] = paneWidth;
      paneWidth += column.width;
    }
    return SizedBox(
      width: paneWidth,
      height: rowHeight * grid.rowCount,
      child: Stack(
        children: [
          for (final cell in grid.cells)
            if (columnIndexes.contains(cell.context.columnIndex))
              Positioned(
                key: ValueKey((
                  _rowElementIdentity(cell.context.row, cell.context.rowIndex),
                  cell.context.column.id,
                )),
                left: offsets[cell.context.columnIndex],
                top: cell.context.rowIndex * rowHeight,
                child: _buildCell(context, theme, cell, columns, rowHeight),
              ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(
    BuildContext context,
    TTableThemeData? theme,
    _ResolvedTableColumn<T> resolvedColumn, {
    bool leadingBoundary = false,
    bool trailingBoundary = false,
  }) {
    final column = resolvedColumn.value;
    final active = widget.sort?.columnId == column.id;
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: column.header),
        if (column.comparator != null) ...[
          const SizedBox(width: 4),
          _SortIndicator(direction: active ? widget.sort?.direction : null),
        ],
      ],
    );
    return _cellFrame(
      context,
      theme,
      resolvedColumn.width,
      column.align,
      header: true,
      leadingBoundary: leadingBoundary,
      trailingBoundary: trailingBoundary,
      child: column.comparator == null
          ? content
          : InkWell(onTap: () => _requestSort(column), child: content),
    );
  }

  Widget _buildCell(
    BuildContext context,
    TTableThemeData? theme,
    _ResolvedTableCell<T> cell,
    List<_ResolvedTableColumn<T>> paneColumns,
    double rowHeight,
  ) {
    final cellContext = cell.context;
    final column = cellContext.column;
    final content = column.cellBuilder(
      context,
      cellContext.row,
      cellContext.rowIndex,
    );
    final hasTap = widget.onCellTap != null || widget.onRowTap != null;
    final paneStart = paneColumns.first.index;
    final paneEnd = paneColumns.last.index;
    final cellEnd = cellContext.columnIndex + cell.span.columnSpan - 1;
    final width = paneColumns
        .where(
          (resolved) =>
              resolved.index >= cellContext.columnIndex &&
              resolved.index <= cellEnd,
        )
        .fold<double>(0, (total, resolved) => total + resolved.width);
    return _cellFrame(
      context,
      theme,
      width,
      column.align,
      height: rowHeight * cell.span.rowSpan,
      backgroundColor: _rowColor(context, theme, cellContext.rowIndex),
      leadingBoundary:
          column.fixed == TTableColumnFixed.right &&
          cellContext.columnIndex == paneStart,
      trailingBoundary:
          column.fixed == TTableColumnFixed.left && cellEnd == paneEnd,
      child: !hasTap
          ? content
          : InkWell(
              onTap: () {
                widget.onCellTap?.call(cellContext);
                widget.onRowTap?.call(cellContext.rowIndex, cellContext.row);
              },
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
    bool header = false,
    double height = double.infinity,
    Color? backgroundColor,
    bool leadingBoundary = false,
    bool trailingBoundary = false,
  }) {
    final alignment = switch (align) {
      TTableColumnAlign.left => Alignment.centerLeft,
      TTableColumnAlign.center => Alignment.center,
      TTableColumnAlign.right => Alignment.centerRight,
    };
    return Container(
      width: width,
      height: height,
      alignment: alignment,
      padding: theme?.cellPadding ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: _cellBorder(
          context,
          theme,
          leadingBoundary: leadingBoundary,
          trailingBoundary: trailingBoundary,
        ),
      ),
      child: ClipRect(
        child: DefaultTextStyle.merge(
          style: _textStyle(context, header: header),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          child: child,
        ),
      ),
    );
  }

  Color _rowColor(BuildContext context, TTableThemeData? theme, int rowIndex) {
    final striped = (widget.stripe ?? theme?.stripe ?? false) && rowIndex.isOdd;
    return striped
        ? theme?.stripeColor ?? context.tTheme.bgColorSecondaryContainer
        : theme?.backgroundColor ?? context.tTheme.bgColorContainer;
  }

  Widget _buildSelectAll(BuildContext context, List<T> rows) {
    final selectableRows = <T>[
      for (var index = 0; index < rows.length; index++)
        if (widget.rowSelectable?.call(rows[index], index) ?? true) rows[index],
    ];
    final selectedCount = selectableRows.where(_isRowSelected).length;
    return _selectionFrame(
      context,
      value:
          selectableRows.isNotEmpty && selectedCount == selectableRows.length,
      tristate: selectedCount > 0 && selectedCount < selectableRows.length,
      enabled: selectableRows.isNotEmpty,
      onChanged: (checked) {
        final selectableKeys = selectableRows.map(_rowIdentity).toSet();
        final next = _withoutRowKeys(widget.selectedRows, selectableKeys);
        if (selectedCount == 0 && checked == true) {
          next.addAll(selectableRows);
        }
        widget.onSelectionChanged!(next);
      },
    );
  }

  Widget _buildRowSelection(BuildContext context, T row, int index) {
    final enabled = widget.rowSelectable?.call(row, index) ?? true;
    return _selectionFrame(
      context,
      value: _isRowSelected(row),
      enabled: enabled,
      onChanged: (checked) {
        final next = _withoutRowKeys(widget.selectedRows, {_rowIdentity(row)});
        if (checked == true) {
          next.add(row);
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
      width: _selectionColumnWidth,
      height: double.infinity,
      decoration: BoxDecoration(border: _cellBorder(context, null)),
      child: CheckboxTheme(
        data: const CheckboxThemeData(
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Center(
          child: TCheckbox(
            value: tristate ? null : value,
            size: TCheckboxSize.small,
            showDivider: false,
            onChanged: enabled ? onChanged : null,
          ),
        ),
      ),
    );
  }

  TextStyle _textStyle(BuildContext context, {required bool header}) {
    final tokenFont = context.tTheme.fontBodyMedium;
    return TextStyle(
      color: header
          ? context.tTheme.textColorPlaceholder
          : context.tTheme.textColorPrimary,
      fontSize: tokenFont?.size ?? 14,
      height: tokenFont?.height ?? 22 / 14,
      fontWeight: tokenFont?.fontWeight ?? FontWeight.w400,
    );
  }

  Border _cellBorder(
    BuildContext context,
    TTableThemeData? theme, {
    bool leadingBoundary = false,
    bool trailingBoundary = false,
  }) {
    final resolvedTheme =
        theme ?? Theme.of(context).extension<TTableThemeData>();
    final side = BorderSide(
      color: resolvedTheme?.borderColor ?? context.tTheme.componentStrokeColor,
      width: 0.5,
    );
    final bordered = widget.bordered ?? resolvedTheme?.bordered ?? false;
    if (bordered) {
      return Border.all(color: side.color, width: side.width);
    }
    return Border(
      left: leadingBoundary
          ? BorderSide(color: side.color, width: 1)
          : BorderSide.none,
      right: trailingBoundary
          ? BorderSide(color: side.color, width: 1)
          : BorderSide.none,
      bottom: side,
    );
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

class _ResolvedTableColumn<T> {
  const _ResolvedTableColumn(this.value, this.index, this.width);

  final TTableColumn<T> value;
  final int index;
  final double width;
}

class _ResolvedTableCell<T> {
  const _ResolvedTableCell(this.context, this.span);

  final TTableCellContext<T> context;
  final TTableCellSpan span;
}

class _ResolvedTableGrid<T> {
  const _ResolvedTableGrid({required this.rowCount, required this.cells});

  final int rowCount;
  final List<_ResolvedTableCell<T>> cells;
}

class _SortIndicator extends StatelessWidget {
  const _SortIndicator({this.direction});

  final TTableSortDirection? direction;

  @override
  Widget build(BuildContext context) {
    final activeColor = context.tTheme.brandNormalColor;
    final inactiveColor = context.tTheme.textColorPlaceholder;
    return SizedBox(
      width: 12,
      height: 18,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: TIcon(
              TIcons.caret_up_small,
              size: 12,
              color: direction == TTableSortDirection.ascending
                  ? activeColor
                  : inactiveColor,
            ),
          ),
          Positioned(
            bottom: 0,
            child: TIcon(
              TIcons.caret_down_small,
              size: 12,
              color: direction == TTableSortDirection.descending
                  ? activeColor
                  : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// 让表头和表体共享横向偏移的私有协调器。
class _TableScrollCoordinator {
  late final ScrollController headerController = _createController();
  late final ScrollController bodyController = _createController();

  double _offset = 0;
  bool _syncing = false;

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
    for (final controller in [headerController, bodyController]) {
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
    bodyController.dispose();
  }
}
