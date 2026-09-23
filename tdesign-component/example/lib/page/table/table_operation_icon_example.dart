import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';

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
