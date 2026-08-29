import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_notice_bar_page.dart';

import 'demo_page_test_utils.dart';

const noticeBarDemoPageTestSpec = DemoPageTestSpec(
  useFeedbackGoldenFont: true,
  name: 'notice_bar',
  title: 'NoticeBar 消息提醒',
  page: TNoticeBarPage(),
  expectedTexts: [
    '01 组件类型',
    '纯文字的公告栏',
    '可滚动的公告栏',
    '垂直滚动的公告栏',
    '带图标的公告栏',
    '带可点击后缀图标的公告栏',
    '带入口的公告栏',
    '自定义内容的公告栏',
    '自定义样式的公告栏',
    '02 组件状态',
    '普通通知',
    '成功通知',
    '警示通知',
    '错误通知',
  ],
  componentType: TNoticeBar,
  expectedComponentCount: 14,
);
