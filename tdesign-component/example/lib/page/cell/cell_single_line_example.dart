import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'cell')
class CellSingleLineExample extends StatefulWidget {
  const CellSingleLineExample({super.key});

  @override
  State<CellSingleLineExample> createState() => _CellSingleLineExampleState();
}

class _CellSingleLineExampleState extends State<CellSingleLineExample> {
  var _switchValue = true;

  Widget _buildSingleLine(BuildContext context) {
    final cells = [
      TCell(title: const Text('单行标题'), arrow: true, onTap: () {}),
      TCell(
        title: const Text('单行标题'),
        required: true,
        arrow: true,
        onTap: () {},
      ),
      TCell(
        title: const Text('单行标题', semanticsLabel: '单行标题，有16条消息'),
        note: const TBadge(label: '16'),
        arrow: true,
        onTap: () {},
      ),
      TCell(
        title: const Text('单行标题'),
        note: TSwitch(
          value: _switchValue,
          onChanged: (value) => setState(() => _switchValue = value),
        ),
        onTap: () {},
      ),
      TCell(
        title: const Text('单行标题'),
        note: const Text('辅助信息'),
        arrow: true,
        onTap: () {},
      ),
      TCell(
        prefix: Icon(
          TIcons.app,
          size: 24,
          color: context.tTheme.brandNormalColor,
        ),
        title: const Text('单行标题'),
        arrow: true,
        onTap: () {},
      ),
    ];
    return Column(
      children: [
        for (var index = 0; index < cells.length; index++) ...[
          cells[index],
          if (index < cells.length - 1)
            Divider(
              height: 0.5,
              thickness: 0.5,
              indent: 16,
              color: context.tTheme.componentStrokeColor,
            ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSingleLine(context);
  }
}
