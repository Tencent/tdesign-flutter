import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TTablePage extends StatefulWidget {
  const TTablePage({super.key});

  @override
  State<TTablePage> createState() => _TTablePageState();
}

class _TTablePageState extends State<TTablePage> {
  static final _rows = List<_TableRow>.generate(
    10,
    (index) => _TableRow(index == 9 ? '内容内容内容内容' : '内容', '内容', '内容', '内容'),
  );

  static final _scrollRows = List<_TableRow>.generate(
    10,
    (index) => index == 0
        ? const _TableRow('横向平铺内容不省略', '横向平铺内容不省略', '横向平铺内容不省略', '')
        : const _TableRow('内容', '内容', '内容', ''),
  );

  TTableSort? _sort;

  List<TTableColumn<_TableRow>> _columns({bool sortable = false}) => [
    _column('title1', (row) => row.title1, sortable: sortable),
    _column('title2', (row) => row.title2, sortable: sortable),
    _column('title3', (row) => row.title3, sortable: sortable),
    _column('title4', (row) => row.title4, sortable: sortable),
  ];

  TTableColumn<_TableRow> _column(
    String id,
    String Function(_TableRow row) value, {
    bool sortable = false,
    double? width,
    TTableColumnFixed fixed = TTableColumnFixed.none,
    Widget Function(BuildContext context, _TableRow row, int index)?
    cellBuilder,
  }) {
    return TTableColumn<_TableRow>(
      id: id,
      header: const Text('标题'),
      width: width,
      fixed: fixed,
      comparator: sortable
          ? (first, second) => value(first).compareTo(value(second))
          : null,
      cellBuilder: cellBuilder ?? (_, row, __) => Text(value(row)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'Table 表格',
      navBarTitle: 'Table',
      desc:
          '表格常用于展示同类结构下的多种数据，易于组织、对比和分析等，并可对数据进行搜索、筛选、排序等操作。一般包括表头、数据行和表尾三部分。',
      exampleCodeGroup: 'table',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础表格',
              compactContentSpacing: 8,
              builder: _buildBasicTable,
            ),
            ExampleItem(
              desc: '可排序表格',
              compactContentSpacing: 8,
              builder: _buildSortableTable,
            ),
            ExampleItem(
              desc: '带操作或按钮表格',
              compactContentSpacing: 8,
              builder: _buildOperationTextTable,
            ),
            ExampleItem(builder: _buildOperationIconTable),
            ExampleItem(
              desc: '可固定首列表格',
              compactContentSpacing: 8,
              builder: _buildFixedFirstTable,
            ),
            ExampleItem(
              desc: '可固定尾列表格',
              compactContentSpacing: 7,
              builder: _buildFixedLastTable,
            ),
            ExampleItem(
              desc: '横向平铺可滚动表格',
              compactContentSpacing: 8,
              builder: _buildHorizontalScrollTable,
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '带斑马纹表格样式',
              compactContentSpacing: 14,
              builder: _buildStripeTable,
            ),
            ExampleItem(
              desc: '带边框表格样式',
              compactContentSpacing: 8,
              builder: _buildBorderedTable,
            ),
          ],
        ),
      ],
    );
  }

  @ExampleCode(group: 'table')
  Widget _buildBasicTable(BuildContext context) {
    return TTable(columns: _columns(), data: _rows);
  }

  @ExampleCode(group: 'table')
  Widget _buildSortableTable(BuildContext context) {
    return TTable(
      key: const ValueKey('table-sortable'),
      columns: _columns(sortable: true),
      data: _rows,
      sort: _sort,
      onSortChanged: (value) => setState(() => _sort = value),
    );
  }

  @ExampleCode(group: 'table')
  Widget _buildOperationTextTable(BuildContext context) {
    return TTable(
      columns: [
        ..._columns().take(3),
        _column(
          'actions',
          (_) => '',
          cellBuilder: (context, _, __) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '修改',
                style: TextStyle(color: context.tTheme.brandNormalColor),
              ),
              Text(
                '通过',
                style: TextStyle(color: context.tTheme.brandNormalColor),
              ),
            ],
          ),
        ),
      ],
      data: _rows,
    );
  }

  @ExampleCode(group: 'table')
  Widget _buildOperationIconTable(BuildContext context) {
    return TTable(
      columns: [
        ..._columns().take(3),
        _column(
          'action-icons',
          (_) => '',
          cellBuilder: (context, _, __) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TIcon(
                TIcons.upload,
                size: 16,
                color: context.tTheme.brandNormalColor,
              ),
              TIcon(
                TIcons.delete,
                size: 16,
                color: context.tTheme.brandNormalColor,
              ),
            ],
          ),
        ),
      ],
      data: _rows,
    );
  }

  @ExampleCode(group: 'table')
  Widget _buildFixedFirstTable(BuildContext context) {
    return TTable(
      key: const ValueKey('table-fixed-first'),
      columns: [
        _column(
          'title1',
          (row) => row.title1,
          width: 94,
          fixed: TTableColumnFixed.left,
        ),
        for (var index = 2; index <= 6; index++)
          _column('title$index', (_) => '内容', width: 120),
      ],
      data: _rows,
    );
  }

  @ExampleCode(group: 'table')
  Widget _buildFixedLastTable(BuildContext context) {
    return TTable(
      key: const ValueKey('table-fixed-last'),
      columns: [
        for (var index = 1; index <= 5; index++)
          _column('title$index', (_) => '内容', width: 120),
        _column(
          'actions',
          (_) => '',
          width: 94,
          fixed: TTableColumnFixed.right,
          cellBuilder: (context, _, __) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '修改',
                style: TextStyle(color: context.tTheme.brandNormalColor),
              ),
              Text(
                '通过',
                style: TextStyle(color: context.tTheme.brandNormalColor),
              ),
            ],
          ),
        ),
      ],
      data: _rows,
    );
  }

  @ExampleCode(group: 'table')
  Widget _buildHorizontalScrollTable(BuildContext context) {
    return TTable(
      key: const ValueKey('table-horizontal-scroll'),
      columns: [
        _column('title1', (row) => row.title1, width: 160),
        _column('title2', (row) => row.title2, width: 160),
        _column('title3', (row) => row.title3, width: 160),
      ],
      data: _scrollRows,
    );
  }

  @ExampleCode(group: 'table')
  Widget _buildStripeTable(BuildContext context) {
    return TTable(columns: _columns(), data: _rows, stripe: true);
  }

  @ExampleCode(group: 'table')
  Widget _buildBorderedTable(BuildContext context) {
    return TTable(columns: _columns(), data: _rows, bordered: true);
  }
}

class _TableRow {
  const _TableRow(this.title1, this.title2, this.title3, this.title4);

  final String title1;
  final String title2;
  final String title3;
  final String title4;
}
