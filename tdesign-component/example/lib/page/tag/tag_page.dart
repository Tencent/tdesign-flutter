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
import 'simple_fill_tag_example.dart';
import 'tag_select_variants_example.dart';

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
      navBarTitle: 'Tag',
      desc: '用于表明主体的类目，属性或状态。',
      exampleCodeGroup: 'tag',
      showTestModule: false,
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
            ExampleItem(
              desc: '可选中的标签',
              methodName: 'TagSelectVariantsExample',
              builder: (_) => const TagSelectVariantsExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '展示型标签',
              methodName: 'DarkShowTagsExample',
              builder: (_) => const DarkShowTagsExample(),
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
