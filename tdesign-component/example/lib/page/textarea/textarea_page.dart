import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'textarea_autosize_example.dart';
import 'textarea_basic_example.dart';
import 'textarea_card_example.dart';
import 'textarea_custom_example.dart';
import 'textarea_disabled_example.dart';
import 'textarea_label_example.dart';
import 'textarea_max_length_example.dart';
import 'textarea_vertical_example.dart';

@ExampleCodeManifest()
/// TTextarea 示例页。
class TTextareaPage extends StatelessWidget {
  const TTextareaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'textarea',
      desc: '用于多行文本信息输入。',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础多行文本框',
              center: false,
              methodName: 'TextareaBasicExample',
              builder: (_) => const TextareaBasicExample(),
            ),
            ExampleItem(
              desc: '带标题多行文本框',
              center: false,
              methodName: 'TextareaLabelExample',
              builder: (_) => const TextareaLabelExample(),
            ),
            ExampleItem(
              desc: '自动增高多行文本框',
              center: false,
              methodName: 'TextareaAutosizeExample',
              builder: (_) => const TextareaAutosizeExample(),
            ),
            ExampleItem(
              desc: '设置字符数限制',
              center: false,
              methodName: 'TextareaMaxLengthExample',
              builder: (_) => const TextareaMaxLengthExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '禁用状态',
              center: false,
              methodName: 'TextareaDisabledExample',
              builder: (_) => const TextareaDisabledExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '竖排样式',
              center: false,
              methodName: 'TextareaVerticalExample',
              builder: (_) => const TextareaVerticalExample(),
            ),
            ExampleItem(
              desc: '卡片样式',
              center: false,
              methodName: 'TextareaCardExample',
              builder: (_) => const TextareaCardExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '特殊样式',
          children: [
            ExampleItem(
              desc: '标签外置输入框',
              center: false,
              methodName: 'TextareaCustomExample',
              builder: (_) => const TextareaCustomExample(),
            ),
          ],
        ),
      ],
      test: const [],
    );
  }
}
