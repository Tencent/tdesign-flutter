import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

ExampleModule tableTypeModule() {
  return ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        desc: '基础表格',
        compactContentSpacing: 8,
        methodName: 'TableBasicExample',
        builder: (_) => const TableBasicExample(),
      ),
      ExampleItem(
        desc: '可排序表格',
        compactContentSpacing: 8,
        methodName: 'TableSortableExample',
        builder: (_) => const TableSortableExample(),
      ),
      ExampleItem(
        desc: '带操作或按钮表格',
        compactContentSpacing: 8,
        methodName: 'TableOperationTextExample',
        builder: (_) => const TableOperationTextExample(),
      ),
      ExampleItem(
        methodName: 'TableOperationIconExample',
        builder: (_) => const TableOperationIconExample(),
      ),
      ExampleItem(
        desc: '可固定首列表格',
        compactContentSpacing: 8,
        methodName: 'TableFixedFirstExample',
        builder: (_) => const TableFixedFirstExample(),
      ),
      ExampleItem(
        desc: '可固定尾列表格',
        compactContentSpacing: 7,
        methodName: 'TableFixedLastExample',
        builder: (_) => const TableFixedLastExample(),
      ),
      ExampleItem(
        desc: '横向平铺可滚动表格',
        compactContentSpacing: 8,
        methodName: 'TableHorizontalScrollExample',
        builder: (_) => const TableHorizontalScrollExample(),
      ),
    ],
  );
}

@ExampleCode(group: 'table')
class TableBasicExample extends StatelessWidget {
  const TableBasicExample({super.key});

  static final _rows = List<List<String>>.generate(
    10,
    (index) => [index == 9 ? '内容内容内容内容' : '内容', '内容', '内容', '内容'],
  );

  @override
  Widget build(BuildContext context) {
    final columns = List<TTableColumn<List<String>>>.generate(
      4,
      (index) => TTableColumn<List<String>>(
        id: 'title${index + 1}',
        header: const Text('标题'),
        cellBuilder: (_, row, __) => Text(row[index]),
      ),
    );
    return TTable(columns: columns, data: _rows);
  }
}

@ExampleCode(group: 'table')
class TableSortableExample extends StatefulWidget {
  const TableSortableExample({super.key});

  @override
  State<TableSortableExample> createState() => _TableSortableExampleState();
}

class _TableSortableExampleState extends State<TableSortableExample> {
  static final _rows = List<List<String>>.generate(
    10,
    (index) => [index == 9 ? '内容内容内容内容' : '内容', '内容', '内容', '内容'],
  );

  TTableSort? _sort;

  List<TTableColumn<List<String>>> get _columns =>
      List<TTableColumn<List<String>>>.generate(
        4,
        (index) => TTableColumn<List<String>>(
          id: 'title${index + 1}',
          header: const Text('标题'),
          comparator: (first, second) => first[index].compareTo(second[index]),
          cellBuilder: (_, row, __) => Text(row[index]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return TTable(
      key: const ValueKey('table-sortable'),
      columns: _columns,
      data: _rows,
      sort: _sort,
      onSortChanged: (value) => setState(() => _sort = value),
    );
  }
}

@ExampleCode(group: 'table')
class TableOperationTextExample extends StatelessWidget {
  const TableOperationTextExample({super.key});

  static final _rows = List<List<String>>.generate(
    10,
    (index) => [index == 9 ? '内容内容内容内容' : '内容', '内容', '内容'],
  );

  @override
  Widget build(BuildContext context) {
    return TTable(
      columns: [
        for (var index = 0; index < 3; index++)
          TTableColumn<List<String>>(
            id: 'title${index + 1}',
            header: const Text('标题'),
            cellBuilder: (_, row, __) => Text(row[index]),
          ),
        TTableColumn<List<String>>(
          id: 'actions',
          header: const Text('标题'),
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
}

@ExampleCode(group: 'table')
class TableOperationIconExample extends StatelessWidget {
  const TableOperationIconExample({super.key});

  static final _rows = List<List<String>>.generate(
    10,
    (index) => [index == 9 ? '内容内容内容内容' : '内容', '内容', '内容'],
  );

  @override
  Widget build(BuildContext context) {
    return TTable(
      columns: [
        for (var index = 0; index < 3; index++)
          TTableColumn<List<String>>(
            id: 'title${index + 1}',
            header: const Text('标题'),
            cellBuilder: (_, row, __) => Text(row[index]),
          ),
        TTableColumn<List<String>>(
          id: 'action-icons',
          header: const Text('标题'),
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
}

@ExampleCode(group: 'table')
class TableFixedFirstExample extends StatelessWidget {
  const TableFixedFirstExample({super.key});

  static final _rows = List<List<String>>.generate(
    10,
    (index) => [index == 9 ? '内容内容内容内容' : '内容'],
  );

  @override
  Widget build(BuildContext context) {
    return TTable(
      key: const ValueKey('table-fixed-first'),
      columns: [
        TTableColumn<List<String>>(
          id: 'title1',
          header: const Text('标题'),
          width: 94,
          fixed: TTableColumnFixed.left,
          cellBuilder: (_, row, __) => Text(row.first),
        ),
        for (var index = 2; index <= 6; index++)
          TTableColumn<List<String>>(
            id: 'title$index',
            header: const Text('标题'),
            width: 120,
            cellBuilder: (_, __, ___) => const Text('内容'),
          ),
      ],
      data: _rows,
    );
  }
}

@ExampleCode(group: 'table')
class TableFixedLastExample extends StatelessWidget {
  const TableFixedLastExample({super.key});

  static final _rows = List<List<String>>.generate(
    10,
    (index) => [index == 9 ? '内容内容内容内容' : '内容'],
  );

  @override
  Widget build(BuildContext context) {
    return TTable(
      key: const ValueKey('table-fixed-last'),
      columns: [
        for (var index = 1; index <= 5; index++)
          TTableColumn<List<String>>(
            id: 'title$index',
            header: const Text('标题'),
            width: 120,
            cellBuilder: (_, __, ___) => const Text('内容'),
          ),
        TTableColumn<List<String>>(
          id: 'actions',
          header: const Text('标题'),
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
}

@ExampleCode(group: 'table')
class TableHorizontalScrollExample extends StatelessWidget {
  const TableHorizontalScrollExample({super.key});

  static final _rows = List<List<String>>.generate(
    10,
    (index) => index == 0
        ? ['横向平铺内容不省略', '横向平铺内容不省略', '横向平铺内容不省略']
        : ['内容', '内容', '内容'],
  );

  @override
  Widget build(BuildContext context) {
    return TTable(
      key: const ValueKey('table-horizontal-scroll'),
      columns: [
        for (var index = 0; index < 3; index++)
          TTableColumn<List<String>>(
            id: 'title${index + 1}',
            header: const Text('标题'),
            width: 160,
            cellBuilder: (_, row, __) => Text(row[index]),
          ),
      ],
      data: _rows,
    );
  }
}
