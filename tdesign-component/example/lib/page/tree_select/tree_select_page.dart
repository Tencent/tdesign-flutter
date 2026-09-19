import 'package:flutter/material.dart';

import '../../base/example_widget.dart';
import 'tree_select_examples.dart';

part 'tree_select_type.dart';
part 'tree_select_status.dart';

class TTreeSelectPage extends StatelessWidget {
  const TTreeSelectPage({super.key});

  @override
  Widget build(BuildContext context) => ExamplePage(
    title: tTitle(context),
    desc: '用于多层级数据的逐级选择。',
    exampleCodeGroup: 'tree-select',
    compactDemo: true,
    showTestModule: false,
    children: [_treeSelectTypeModule, _treeSelectStatusModule],
  );
}
