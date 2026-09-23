import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'close_notice_bar_example.dart';
import 'custom_content_notice_bar_example.dart';
import 'custom_notice_bar_example.dart';
import 'entrance_notice_bar_example.dart';
import 'icon_notice_bar_example.dart';
import 'scrolling_notice_bars_example.dart';
import 'text_notice_bar_example.dart';
import 'theme_notice_bars_example.dart';

@ExampleCodeManifest()
class TNoticeBarPage extends StatelessWidget {
  const TNoticeBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'noticeBar',
      desc: '在导航栏下方，用于给用户显示提示消息。',
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '纯文字的公告栏',
              methodName: 'TextNoticeBarExample',
              builder: (_) => const TextNoticeBarExample(),
            ),
            ExampleItem(
              desc: '带图标的公告栏',
              methodName: 'IconNoticeBarExample',
              builder: (_) => const IconNoticeBarExample(),
            ),
            ExampleItem(
              desc: '带关闭的公告栏',
              methodName: 'CloseNoticeBarExample',
              builder: (_) => const CloseNoticeBarExample(),
            ),
            ExampleItem(
              desc: '带入口的公告栏',
              methodName: 'EntranceNoticeBarExample',
              builder: (_) => const EntranceNoticeBarExample(),
            ),
            ExampleItem(
              desc: '自定义样式的公告栏',
              methodName: 'CustomNoticeBarExample',
              builder: (_) => const CustomNoticeBarExample(),
            ),
            ExampleItem(
              desc: '自定义内容的公告栏',
              methodName: 'CustomContentNoticeBarExample',
              builder: (_) => const CustomContentNoticeBarExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '公告栏类型有普通（info）、警示（warning）、成功（success）、错误（error）',
              methodName: 'ThemeNoticeBarsExample',
              builder: (_) => const ThemeNoticeBarsExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '可滚动公告栏',
          children: [
            ExampleItem(
              desc: '可滚动公告栏有水平（horizontal）和垂直（vertical）',
              methodName: 'ScrollingNoticeBarsExample',
              builder: (_) => const ScrollingNoticeBarsExample(),
            ),
          ],
        ),
      ],
    );
  }
}
