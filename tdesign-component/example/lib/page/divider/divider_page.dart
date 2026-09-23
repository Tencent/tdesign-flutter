import 'package:flutter/material.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'divider_base_example.dart';
import 'divider_dashed_example.dart';

@ExampleCodeManifest()
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
          children: [
            ExampleItem(
              key: const Key('divider-base-example'),
              desc: '水平分割线',
              center: false,
              methodName: 'DividerBaseExample',
              builder: (_) => const DividerBaseExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              key: const Key('divider-dashed-example'),
              desc: '虚线样式',
              center: false,
              methodName: 'DividerDashedExample',
              builder: (_) => const DividerDashedExample(),
            ),
          ],
        ),
      ],
    );
  }
}
