import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

ExampleModule tableStyleModule() {
  return ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(
        desc: '带斑马纹表格样式',
        compactContentSpacing: 14,
        methodName: 'TableStripeExample',
        builder: (_) => const TableStripeExample(),
      ),
      ExampleItem(
        desc: '带边框表格样式',
        compactContentSpacing: 8,
        methodName: 'TableBorderedExample',
        builder: (_) => const TableBorderedExample(),
      ),
    ],
  );
}

@ExampleCode(group: 'table')
class TableStripeExample extends StatelessWidget {
  const TableStripeExample({super.key});

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
    return TTable(columns: columns, data: _rows, stripe: true);
  }
}

@ExampleCode(group: 'table')
class TableBorderedExample extends StatelessWidget {
  const TableBorderedExample({super.key});

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
    return TTable(columns: columns, data: _rows, bordered: true);
  }
}
