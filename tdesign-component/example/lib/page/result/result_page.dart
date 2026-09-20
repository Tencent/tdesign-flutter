import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'basic_results_example.dart';
import 'custom_result_example.dart';
import 'description_results_example.dart';
import 'page_example.dart';

@ExampleCodeManifest()
class TResultPage extends StatelessWidget {
  const TResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'Result 结果',
      desc: '用于反馈不同结果的展示。',
      exampleCodeGroup: 'result',
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础结果',
              methodName: 'BasicResultsExample',
              builder: (_) => const BasicResultsExample(),
            ),
            ExampleItem(
              desc: '带描述结果',
              methodName: 'DescriptionResultsExample',
              builder: (_) => const DescriptionResultsExample(),
            ),
            ExampleItem(
              desc: '自定义结果',
              methodName: 'CustomResultExample',
              builder: (_) => const CustomResultExample(),
            ),
            ExampleItem(
              desc: '页面示例',
              methodName: 'PageExample',
              builder: (_) => const PageExample(),
            ),
          ],
        ),
      ],
    );
  }
}
