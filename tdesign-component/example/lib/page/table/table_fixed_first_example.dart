import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';

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
