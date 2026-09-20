import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'accessible_text_example.dart';
import 'plain_text_example.dart';
import 'raw_text_example.dart';
import 'rich_text_example.dart';
import 'text_background_example.dart';
import 'text_decoration_example.dart';
import 'text_font_family_example.dart';
import 'text_layout_example.dart';
import 'text_overflow_example.dart';
import 'text_token_style_example.dart';
import 'theme_demo_example.dart';

@ExampleCodeManifest()
class TTextPage extends StatelessWidget {
  const TTextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc:
          '用于展示文本，支持普通文本和富文本两种模式，并复用 Flutter '
          '原生排版、缩放、语义与选择能力。',
      exampleCodeGroup: 'text',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '普通文本',
              methodName: 'PlainTextExample',
              builder: (_) => const PlainTextExample(),
            ),
            ExampleItem(
              desc: '富文本',
              methodName: 'RichTextExample',
              builder: (_) => const RichTextExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '文本样式',
          children: [
            ExampleItem(
              desc: '字体 Token 与颜色',
              methodName: 'TextTokenStyleExample',
              builder: (_) => const TextTokenStyleExample(),
            ),
            ExampleItem(
              desc: '字重与删除线',
              methodName: 'TextDecorationExample',
              builder: (_) => const TextDecorationExample(),
            ),
            ExampleItem(
              desc: '字形背景与行盒背景',
              methodName: 'TextBackgroundExample',
              builder: (_) => const TextBackgroundExample(),
            ),
            ExampleItem(
              desc: '字体族与资源 package',
              methodName: 'TextFontFamilyExample',
              builder: (_) => const TextFontFamilyExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '段落与辅助能力',
          children: [
            ExampleItem(
              desc: '多行省略',
              methodName: 'TextOverflowExample',
              builder: (_) => const TextOverflowExample(),
            ),
            ExampleItem(
              desc: '对齐与文字缩放',
              methodName: 'TextLayoutExample',
              builder: (_) => const TextLayoutExample(),
            ),
            ExampleItem(
              desc: '文字选择与语义',
              methodName: 'AccessibleTextExample',
              builder: (_) => const AccessibleTextExample(),
            ),
            ExampleItem(
              desc: '获取 Flutter 原生 Text',
              methodName: 'RawTextExample',
              builder: (_) => const RawTextExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件主题',
          children: [
            ExampleItem(
              desc: '子树默认样式',
              methodName: 'ThemeDemo',
              builder: (_) => const ThemeDemo(),
            ),
          ],
        ),
      ],
      test: const [],
    );
  }
}
