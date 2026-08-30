import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_notice_bar_page.dart';

import 'demo_page_test_utils.dart';

const noticeBarDemoPageTestSpec = DemoPageTestSpec(
  useFeedbackGoldenFont: true,
  name: 'notice_bar',
  title: 'NoticeBar 公告栏',
  page: TNoticeBarPage(),
  expectedTexts: [
    '01 组件类型',
    '纯文字的公告栏',
    '带图标的公告栏',
    '带关闭的公告栏',
    '带入口的公告栏',
    '自定义样式的公告栏',
    '自定义内容的公告栏',
    '02 组件状态',
    '公告栏类型有普通（info）、警示（warning）、成功（success）、错误（error）',
    '03 可滚动公告栏',
    '可滚动公告栏有水平（horizontal）和垂直（vertical）',
  ],
  componentType: TNoticeBar,
  expectedComponentCount: 14,
);
