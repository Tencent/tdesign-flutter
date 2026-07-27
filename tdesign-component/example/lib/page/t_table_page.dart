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
  static const _rows = [
    _ExampleRow('Alice', 'Designer', 30),
    _ExampleRow('Bob', 'Engineer', 24),
    _ExampleRow('Carol', 'Manager', 36),
  ];

  Set<_ExampleRow> _selected = {};
  TTableSort? _sort;

  List<TTableColumn<_ExampleRow>> get _columns => [
        TTableColumn<_ExampleRow>(
          id: 'name',
          header: const Text('姓名'),
          cellBuilder: (_, row, __) => Text(row.name),
          comparator: (a, b) => a.name.compareTo(b.name),
        ),
        TTableColumn<_ExampleRow>(
          id: 'role',
          header: const Text('职位'),
          cellBuilder: (_, row, __) => Text(row.role),
          width: 140,
        ),
        TTableColumn<_ExampleRow>(
          id: 'age',
          header: const Text('年龄'),
          cellBuilder: (_, row, __) => Text('${row.age}'),
          comparator: (a, b) => a.age.compareTo(b.age),
          align: TTableColumnAlign.right,
          width: 80,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'Table 表格',
      exampleCodeGroup: 'table',
      children: [
        ExampleModule(
          title: '基础能力',
          children: [
            ExampleItem(desc: '基础表格', builder: _buildBasic),
            ExampleItem(desc: '受控排序', builder: _buildSortable),
            ExampleItem(desc: '受控多选', builder: _buildSelectable),
          ],
        ),
        ExampleModule(
          title: '布局与状态',
          children: [
            ExampleItem(desc: '固定列', builder: _buildFixed),
            ExampleItem(desc: '加载状态', builder: _buildLoading),
            ExampleItem(desc: '空状态', builder: _buildEmpty),
          ],
        ),
      ],
    );
  }

  Widget _frame(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      );

  @ExampleCode(group: 'table')
  Widget _buildBasic(BuildContext context) {
    return _frame(TTable(columns: _columns, data: _rows));
  }

  @ExampleCode(group: 'table')
  Widget _buildSortable(BuildContext context) {
    return _frame(TTable(
      columns: _columns,
      data: _rows,
      sort: _sort,
      onSortChanged: (value) => setState(() => _sort = value),
    ));
  }

  @ExampleCode(group: 'table')
  Widget _buildSelectable(BuildContext context) {
    return _frame(TTable(
      columns: _columns,
      data: _rows,
      selectionMode: TTableSelectionMode.multiple,
      selectedRows: _selected,
      onSelectionChanged: (value) => setState(() => _selected = value),
    ));
  }

  @ExampleCode(group: 'table')
  Widget _buildFixed(BuildContext context) {
    final columns = [
      TTableColumn<_ExampleRow>(
        id: 'name',
        header: const Text('姓名'),
        fixed: TTableColumnFixed.left,
        cellBuilder: (_, row, __) => Text(row.name),
      ),
      ..._columns.skip(1),
      TTableColumn<_ExampleRow>(
        id: 'action',
        header: const Text('操作'),
        fixed: TTableColumnFixed.right,
        cellBuilder: (_, __, ___) => const Icon(Icons.more_horiz),
        width: 64,
      ),
    ];
    return _frame(TTable(columns: columns, data: _rows));
  }

  @ExampleCode(group: 'table')
  Widget _buildLoading(BuildContext context) {
    return _frame(TTable(
      columns: _columns,
      data: _rows,
      loading: true,
    ));
  }

  @ExampleCode(group: 'table')
  Widget _buildEmpty(BuildContext context) {
    return _frame(TTable<_ExampleRow>(
      columns: _columns,
      data: const [],
      empty: const Padding(
        padding: EdgeInsets.all(24),
        child: Text('暂无数据'),
      ),
    ));
  }
}

class _ExampleRow {
  const _ExampleRow(this.name, this.role, this.age);

  final String name;
  final String role;
  final int age;
}
