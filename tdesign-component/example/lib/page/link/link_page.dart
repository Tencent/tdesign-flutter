import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'basic_links_example.dart';
import 'color_scheme_links_example.dart';
import 'disabled_links_example.dart';
import 'link_sizes_example.dart';
import 'prefix_links_example.dart';
import 'suffix_links_example.dart';
import 'underline_links_example.dart';

@ExampleCodeManifest()
class TLinkViewPage extends StatefulWidget {
  const TLinkViewPage({Key? key}) : super(key: key);

  @override
  State<TLinkViewPage> createState() => _TLinkViewPageState();
}

class _TLinkViewPageState extends State<TLinkViewPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '文字超链接用于跳转一个新页面，如当前项目跳转，友情链接等。',
      backgroundColor: context.tTheme.bgColorPage,
      exampleCodeGroup: 'link',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础文字链接',
              methodName: 'BasicLinksExample',
              builder: (_) => const BasicLinksExample(),
            ),
            ExampleItem(
              desc: '下划线文字链接',
              methodName: 'UnderlineLinksExample',
              builder: (_) => const UnderlineLinksExample(),
            ),
            ExampleItem(
              desc: '前置图标文字链接',
              methodName: 'PrefixLinksExample',
              builder: (_) => const PrefixLinksExample(),
            ),
            ExampleItem(
              desc: '后置图标文字链接',
              methodName: 'SuffixLinksExample',
              builder: (_) => const SuffixLinksExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '不同主题',
              methodName: 'ColorSchemeLinksExample',
              builder: (_) => const ColorSchemeLinksExample(),
            ),
            ExampleItem(
              desc: '禁用状态',
              methodName: 'DisabledLinksExample',
              builder: (_) => const DisabledLinksExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '链接尺寸',
              methodName: 'LinkSizesExample',
              builder: (_) => const LinkSizesExample(),
            ),
          ],
        ),
      ],
    );
  }
}
