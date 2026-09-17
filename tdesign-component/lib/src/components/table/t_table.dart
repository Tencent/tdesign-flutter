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

/// 单元格点击回调。
typedef TTableCellTap<T> =
    void Function(int rowIndex, T row, TTableColumn<T> column);

/// 行点击回调。
typedef TTableRowTap<T> = void Function(int rowIndex, T row);

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
    this.bordered,
    this.stripe,
    this.onCellTap,
    this.onRowTap,
    this.onScroll,
    super.key,
  }) : assert(columns.length > 0),
       assert(maxHeight == null || maxHeight > 0),
       assert(
         selectionMode == TTableSelectionMode.none ||
             onSelectionChanged != null,
       );

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

  /// 是否显示完整单元格边框。
  ///
  /// 为空时读取 [TTableThemeData.bordered]，最后回退为 `false`。
  final bool? bordered;

  /// 是否为奇数数据行显示斑马纹背景。
  ///
  /// 为空时读取 [TTableThemeData.stripe]，最后回退为 `false`。
  final bool? stripe;

  /// 单元格点击回调。
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
  void didUpdateWidget(covariant TTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data.length < oldWidget.data.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _horizontalScroll.retainRows(widget.data.length);
        }
      });
    }
  }

  @override
  void dispose() {
    _horizontalScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TTableThemeData>();
    final rows = _sortedData();
    final naturalWidth =
        widget.columns.fold<double>(
          0,
          (total, column) => total + (column.width ?? _defaultColumnWidth),
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
        return SizedBox(
          width: width,
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
      (total, column) => total + (column.width ?? 0),
    );
    final flexibleCount = widget.columns
        .where((column) => column.width == null)
        .length;
    final remainingWidth = availableWidth - explicitWidth;
    final flexibleWidth = flexibleCount == 0
        ? _defaultColumnWidth
        : remainingWidth > 0
        ? remainingWidth / flexibleCount
        : _defaultColumnWidth;
    return [
      for (final column in widget.columns)
        _ResolvedTableColumn(column, column.width ?? flexibleWidth),
    ];
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
    List<_ResolvedTableColumn<T>> left,
    List<_ResolvedTableColumn<T>> center,
    List<_ResolvedTableColumn<T>> right,
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
    List<_ResolvedTableColumn<T>> left,
    List<_ResolvedTableColumn<T>> center,
    List<_ResolvedTableColumn<T>> right,
  ) {
    final body = ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: rows.length,
      itemBuilder: (context, index) {
        final row = rows[index];
        final striped =
            (widget.stripe ?? theme?.stripe ?? false) && index.isOdd;
        return SizedBox(
          height: theme?.rowHeight ?? _defaultRowHeight,
          child: ColoredBox(
            color: striped
                ? theme?.stripeColor ?? context.tTheme.bgColorSecondaryContainer
                : theme?.backgroundColor ?? context.tTheme.bgColorContainer,
            child: Row(
              children: [
                if (_selectable) _buildRowSelection(context, row, index),
                for (
                  var columnIndex = 0;
                  columnIndex < left.length;
                  columnIndex++
                )
                  _buildCell(
                    context,
                    theme,
                    row,
                    index,
                    left[columnIndex],
                    trailingBoundary: columnIndex == left.length - 1,
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _horizontalScroll.rowController(index),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: center
                          .map(
                            (column) =>
                                _buildCell(context, theme, row, index, column),
                          )
                          .toList(),
                    ),
                  ),
                ),
                for (
                  var columnIndex = 0;
                  columnIndex < right.length;
                  columnIndex++
                )
                  _buildCell(
                    context,
                    theme,
                    row,
                    index,
                    right[columnIndex],
                    leadingBoundary: columnIndex == 0,
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
    T row,
    int rowIndex,
    _ResolvedTableColumn<T> resolvedColumn, {
    bool leadingBoundary = false,
    bool trailingBoundary = false,
  }) {
    final column = resolvedColumn.value;
    final content = column.cellBuilder(context, row, rowIndex);
    final hasTap = widget.onCellTap != null || widget.onRowTap != null;
    return _cellFrame(
      context,
      theme,
      resolvedColumn.width,
      column.align,
      leadingBoundary: leadingBoundary,
      trailingBoundary: trailingBoundary,
      child: !hasTap
          ? content
          : InkWell(
              onTap: () {
                widget.onCellTap?.call(rowIndex, row, column);
                widget.onRowTap?.call(rowIndex, row);
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
      height: double.infinity,
      alignment: alignment,
      padding: theme?.cellPadding ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
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

  Widget _buildSelectAll(BuildContext context, List<T> rows) {
    final selectableRows = <T>{
      for (var index = 0; index < rows.length; index++)
        if (widget.rowSelectable?.call(rows[index], index) ?? true) rows[index],
    };
    final selectedCount = selectableRows
        .intersection(widget.selectedRows)
        .length;
    return _selectionFrame(
      context,
      value:
          selectableRows.isNotEmpty && selectedCount == selectableRows.length,
      tristate: selectedCount > 0 && selectedCount < selectableRows.length,
      enabled: selectableRows.isNotEmpty,
      onChanged: (checked) {
        final next = Set<T>.of(widget.selectedRows);
        if (selectedCount == 0 && checked == true) {
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
  const _ResolvedTableColumn(this.value, this.width);

  final TTableColumn<T> value;
  final double width;
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

/// 让表头和每个表体行共享横向偏移的私有协调器。
class _TableScrollCoordinator {
  final Map<int, ScrollController> _rowControllers = {};
  late final ScrollController headerController = _createController();

  double _offset = 0;
  bool _syncing = false;

  ScrollController rowController(int index) =>
      _rowControllers.putIfAbsent(index, _createController);

  void retainRows(int count) {
    final removedIndexes = _rowControllers.keys
        .where((index) => index >= count)
        .toList();
    for (final index in removedIndexes) {
      _rowControllers.remove(index)?.dispose();
    }
  }

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
