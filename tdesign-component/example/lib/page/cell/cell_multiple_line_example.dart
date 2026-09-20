import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'cell')
class CellMultipleLineExample extends StatefulWidget {
  const CellMultipleLineExample({super.key});

  @override
  State<CellMultipleLineExample> createState() =>
      _CellMultipleLineExampleState();
}

class _CellMultipleLineExampleState extends State<CellMultipleLineExample> {
  Widget _buildMultipleLine(BuildContext context) {
    var switchValue = true;
    const description = '一段很长很长的内容文字';
    return StatefulBuilder(
      builder: (context, setState) {
        final cells = [
          TCell(
            title: const Text('单行标题'),
            subtitle: const Text(description),
            arrow: true,
            onTap: () {},
          ),
          TCell(
            title: const Text('单行标题'),
            subtitle: const Text(description),
            required: true,
            arrow: true,
            onTap: () {},
          ),
          TCell(
            title: const Text('单行标题'),
            subtitle: const Text(description),
            note: const TBadge(label: '16'),
            arrow: true,
            onTap: () {},
          ),
          TCell(
            title: const Text('单行标题'),
            subtitle: const Text(description),
            note: TSwitch(
              value: switchValue,
              onChanged: (value) => setState(() => switchValue = value),
            ),
            onTap: () {},
          ),
          TCell(
            title: const Text('单行标题'),
            subtitle: const Text(description),
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
            subtitle: const Text(description),
            arrow: true,
            onTap: () {},
          ),
          TCell(
            title: const Text('单行标题'),
            subtitle: const Text('一段很长很长的内容文字，长文本自动换行，该选项的描述是一段很长的内容'),
            onTap: () {},
          ),
          TCell(
            image: const TImage(
              src: 'assets/img/t_avatar_1.png',
              shape: TImageShape.circle,
              fit: BoxFit.cover,
              width: 48,
              height: 48,
            ),
            title: const Text('单行标题'),
            subtitle: const Text('一段很长很长很长的内容文字'),
            arrow: true,
            onTap: () {},
          ),
          TCell(
            image: const TImage(
              src: 'assets/img/t_avatar_1.png',
              shape: TImageShape.circle,
              fit: BoxFit.cover,
              width: 48,
              height: 48,
            ),
            title: const Text('单行标题'),
            subtitle: const Text(description),
            align: TCellAlign.top,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMultipleLine(context);
  }
}
