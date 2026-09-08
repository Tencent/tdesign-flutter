import 'package:flutter/material.dart';

import '../base/example_widget.dart';
import 'tree_select/tree_select_examples.dart';

class TTreeSelectPage extends StatelessWidget {
  const TTreeSelectPage({super.key});

  @override
  Widget build(BuildContext context) => ExamplePage(
    title: tTitle(context),
    desc: '用于多层级数据的逐级选择。',
    exampleCodeGroup: 'tree-select',
    compactDemo: true,
    showTestModule: false,
    children: [
      ExampleModule(
        title: '组件类型',
        children: [
          ExampleItem(
            desc: '基础树形选择器',
            methodName: 'TreeSelectSingleExample',
            builder: (_) => const TreeSelectSingleExample(),
          ),
          ExampleItem(
            desc: '多选树形选择器',
            methodName: 'TreeSelectMultipleExample',
            builder: (_) => const TreeSelectMultipleExample(),
          ),
        ],
      ),
      ExampleModule(
        title: '组件状态',
        children: [
          ExampleItem(
            desc: '树形选择器-三列',
            methodName: 'TreeSelectThreeColumnsExample',
            builder: (_) => const TreeSelectThreeColumnsExample(),
          ),
        ],
      ),
    ],
  );
}
