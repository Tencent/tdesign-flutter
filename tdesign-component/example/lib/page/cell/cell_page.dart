import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'cell_card_group_example.dart';
import 'cell_multiple_line_example.dart';
import 'cell_single_line_example.dart';

@ExampleCodeManifest()
class TCellPage extends StatelessWidget {
  const TCellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'Cell 单元格',
      desc: '用于各个类别行的信息展示。',
      exampleCodeGroup: 'cell',
      backgroundColor: context.tTheme.bgColorPage,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '单行单元格',
              key: const Key('cell-demo-single-line'),
              center: false,
              methodName: 'CellSingleLineExample',
              builder: (_) => const CellSingleLineExample(),
            ),
            ExampleItem(
              desc: '多行单元格',
              key: const Key('cell-demo-multiple-line'),
              center: false,
              methodName: 'CellMultipleLineExample',
              builder: (_) => const CellMultipleLineExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '卡片单元格',
              key: const Key('cell-demo-card'),
              center: false,
              methodName: 'CellCardGroupExample',
              builder: (_) => const CellCardGroupExample(),
            ),
          ],
        ),
      ],
    );
  }
}
