import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'rate_action_example.dart';
import 'rate_basic_example.dart';
import 'rate_color_example.dart';
import 'rate_count_example.dart';
import 'rate_custom_example.dart';
import 'rate_show_text_example.dart';
import 'rate_size_example.dart';
import 'rate_third_party_icon_example.dart';
import 'rate_vertical_example.dart';

@ExampleCodeManifest()
/// TRate 演示。
class TRatePage extends StatelessWidget {
  const TRatePage({super.key});

  @override
  Widget build(BuildContext context) => ExamplePage(
    title: tTitle(context),
    desc: '用于对某行为/事物进行打分。',
    exampleCodeGroup: 'rate',
    compactDemo: true,
    showTestModule: false,
    children: [
      ExampleModule(
        title: '组件类型',
        children: [
          ExampleItem(
            desc: '实心评分',
            center: false,
            methodName: 'RateBasicExample',
            builder: (_) => const RateBasicExample(),
          ),
          ExampleItem(
            desc: '自定义评分',
            center: false,
            methodName: 'RateCustomExample',
            builder: (_) => const RateCustomExample(),
          ),
          ExampleItem(
            desc: '第三方图标评分',
            center: false,
            methodName: 'RateThirdPartyIconExample',
            builder: (_) => const RateThirdPartyIconExample(),
          ),
          ExampleItem(
            desc: '自定义评分数量',
            center: false,
            methodName: 'RateCountExample',
            builder: (_) => const RateCountExample(),
          ),
          ExampleItem(
            desc: '带描述评分',
            center: false,
            methodName: 'RateShowTextExample',
            builder: (_) => const RateShowTextExample(),
          ),
        ],
      ),
      ExampleModule(
        title: '组件状态',
        children: [
          ExampleItem(
            desc: '',
            center: false,
            methodName: 'RateActionExample',
            builder: (_) => const RateActionExample(),
          ),
        ],
      ),
      ExampleModule(
        title: '组件样式',
        children: [
          ExampleItem(
            desc: '评分大小',
            center: false,
            methodName: 'RateSizeExample',
            builder: (_) => const RateSizeExample(),
          ),
          ExampleItem(
            desc: '评分风格',
            center: false,
            methodName: 'RateColorExample',
            builder: (_) => const RateColorExample(),
          ),
        ],
      ),
      ExampleModule(
        title: '特殊样式',
        children: [
          ExampleItem(
            desc: '竖向带描述评分',
            center: false,
            methodName: 'RateVerticalExample',
            builder: (_) => const RateVerticalExample(),
          ),
        ],
      ),
    ],
  );
}
