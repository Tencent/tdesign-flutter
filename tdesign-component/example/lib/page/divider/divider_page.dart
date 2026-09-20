import 'package:flutter/material.dart';

import '../../base/example_widget.dart';
import 'divider_base_example.dart';
import 'divider_dashed_example.dart';

class TDividerPage extends StatelessWidget {
  const TDividerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于分割、组织、细化有一定逻辑的组织元素内容和页面结构。',
      exampleCodeGroup: 'divider',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [dividerBaseExampleItem],
        ),
        ExampleModule(
          title: '组件状态',
          children: [dividerDashedExampleItem],
        ),
      ],
    );
  }
}
