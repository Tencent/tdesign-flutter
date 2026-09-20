import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'switch_basic_example.dart';
import 'switch_color_example.dart';
import 'switch_label_example.dart';
import 'switch_sizes_example.dart';
import 'switch_status_example.dart';

@ExampleCodeManifest()
/// TSwitch 示例页。
class TSwitchPage extends StatelessWidget {
  const TSwitchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'switch',
      desc: '用于控制某个功能的开启和关闭。',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础开关',
              key: const Key('switch-demo-basic'),
              center: false,
              methodName: 'SwitchBasicExample',
              builder: (_) => const SwitchBasicExample(),
            ),
            ExampleItem(
              desc: '带描述开关',
              key: const Key('switch-demo-label'),
              center: false,
              methodName: 'SwitchLabelExample',
              builder: (_) => const SwitchLabelExample(),
            ),
            ExampleItem(
              desc: '自定义颜色开关',
              key: const Key('switch-demo-color'),
              center: false,
              methodName: 'SwitchColorExample',
              builder: (_) => const SwitchColorExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '',
              key: const Key('switch-demo-status'),
              center: false,
              methodName: 'SwitchStatusExample',
              builder: (_) => const SwitchStatusExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '开关尺寸',
              key: const Key('switch-demo-sizes'),
              center: false,
              methodName: 'SwitchSizesExample',
              builder: (_) => const SwitchSizesExample(),
            ),
          ],
        ),
      ],
      test: const [],
    );
  }
}
