import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';

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
