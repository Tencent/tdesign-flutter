import 'package:flutter/material.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'progress_button_example.dart';
import 'progress_circle_example.dart';
import 'progress_circle_status_example.dart';
import 'progress_linear_example.dart';
import 'progress_linear_status_example.dart';
import 'progress_micro_button_example.dart';
import 'progress_micro_circle_example.dart';
import 'progress_plump_example.dart';
import 'progress_plump_status_example.dart';

@ExampleCodeManifest()
class TProgressPage extends StatelessWidget {
  const TProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    const itemPadding = EdgeInsets.symmetric(horizontal: 16);
    return ExamplePage(
      title: tTitle(context),
      desc: '用于展示任务当前的进度。',
      exampleCodeGroup: 'progress',
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '线性进度条',
              padding: itemPadding,
              methodName: 'ProgressLinearExample',
              builder: (_) => const ProgressLinearExample(),
            ),
            ExampleItem(
              desc: '百分比内显',
              padding: itemPadding,
              methodName: 'ProgressPlumpExample',
              builder: (_) => const ProgressPlumpExample(),
            ),
            ExampleItem(
              desc: '环形进度条',
              padding: itemPadding,
              methodName: 'ProgressCircleExample',
              builder: (_) => const ProgressCircleExample(),
            ),
            ExampleItem(
              desc: '微型环形进度条',
              padding: itemPadding,
              methodName: 'ProgressMicroCircleExample',
              builder: (_) => const ProgressMicroCircleExample(),
            ),
            ExampleItem(
              desc: '按钮进度条',
              padding: itemPadding,
              methodName: 'ProgressButtonExample',
              builder: (_) => const ProgressButtonExample(),
            ),
            ExampleItem(
              desc: '微型按钮进度条',
              padding: itemPadding,
              methodName: 'ProgressMicroButtonExample',
              builder: (_) => const ProgressMicroButtonExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '线性进度条',
              padding: itemPadding,
              methodName: 'ProgressLinearStatusExample',
              builder: (_) => const ProgressLinearStatusExample(),
            ),
            ExampleItem(
              desc: '百分比内显进度条',
              padding: itemPadding,
              methodName: 'ProgressPlumpStatusExample',
              builder: (_) => const ProgressPlumpStatusExample(),
            ),
            ExampleItem(
              desc: '环形进度条',
              padding: itemPadding,
              methodName: 'ProgressCircleStatusExample',
              builder: (_) => const ProgressCircleStatusExample(),
            ),
          ],
        ),
      ],
    );
  }
}
