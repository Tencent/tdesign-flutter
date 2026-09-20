import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'all_size_tags_example.dart';
import 'circle_fill_tag_example.dart';
import 'close_fill_tag_example.dart';
import 'dark_show_tags_example.dart';
import 'icon_fill_tag_example.dart';
import 'long_text_tag_example.dart';
import 'mark_fill_tag_example.dart';
import 'outline_show_tags_example.dart';
import 'simple_fill_tag_example.dart';
import 'tag_select_color_schemes_example.dart';
import 'tag_select_default_example.dart';
import 'tag_select_disabled_example.dart';
import 'tag_select_outline_example.dart';

@ExampleCodeManifest()
class TTagPage extends StatefulWidget {
  const TTagPage({Key? key}) : super(key: key);

  @override
  State<TTagPage> createState() => _TTagPageState();
}

class _TTagPageState extends State<TTagPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于表明主体的类目，属性或状态',
      exampleCodeGroup: 'tag',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础标签',
              methodName: 'SimpleFillTagExample',
              builder: (_) => const SimpleFillTagExample(),
            ),
            ExampleItem(
              desc: '圆弧标签',
              methodName: 'CircleFillTagExample',
              builder: (_) => const CircleFillTagExample(),
            ),
            ExampleItem(
              desc: 'Mark标签',
              methodName: 'MarkFillTagExample',
              builder: (_) => const MarkFillTagExample(),
            ),
            ExampleItem(
              desc: '带图标的标签',
              methodName: 'IconFillTagExample',
              builder: (_) => const IconFillTagExample(),
            ),
            ExampleItem(
              desc: '超长省略文本标签',
              methodName: 'LongTextTagExample',
              builder: (_) => const LongTextTagExample(),
            ),
            ExampleItem(
              desc: '可关闭的标签',
              methodName: 'CloseFillTagExample',
              builder: (_) => const CloseFillTagExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态（主题）',
          children: [
            ExampleItem(
              desc: '填充型各主题',
              methodName: 'DarkShowTagsExample',
              builder: (_) => const DarkShowTagsExample(),
            ),
            ExampleItem(
              desc: '描边型各主题',
              methodName: 'OutlineShowTagsExample',
              builder: (_) => const OutlineShowTagsExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件尺寸',
          children: [
            ExampleItem(
              desc: '',
              methodName: 'AllSizeTagsExample',
              builder: (_) => const AllSizeTagsExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '可选标签',
          children: [
            ExampleItem(
              desc: '默认形态',
              methodName: 'TagSelectDefaultExample',
              builder: (_) => const TagSelectDefaultExample(),
            ),
            ExampleItem(
              desc: '描边形态',
              methodName: 'TagSelectOutlineExample',
              builder: (_) => const TagSelectOutlineExample(),
            ),
            ExampleItem(
              desc: '不同语义色',
              methodName: 'TagSelectColorSchemesExample',
              builder: (_) => const TagSelectColorSchemesExample(),
            ),
            ExampleItem(
              desc: '禁用状态',
              methodName: 'TagSelectDisabledExample',
              builder: (_) => const TagSelectDisabledExample(),
            ),
          ],
        ),
      ],
      test: [
        ExampleItem(
          desc: '禁用状态',
          ignoreCode: true,
          builder: (context) {
            return Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 16),
              child: Wrap(spacing: 8, children: [_buildDisabledTag(context)]),
            );
          },
        ),
      ],
    );
  }

  // ============ 组件类型 ============

  // ============ 组件状态（主题） ============

  // ============ 组件尺寸 ============

  // ============ 测试 ============

  Widget _buildDisabledTag(BuildContext context) {
    return const Wrap(
      spacing: 8,
      children: [
        TTag('禁用', colorScheme: TTagColorScheme.defaultTheme, enabled: false),
        TTag('禁用', colorScheme: TTagColorScheme.primary, enabled: false),
        TTag('禁用', colorScheme: TTagColorScheme.danger, enabled: false),
      ],
    );
  }
}
