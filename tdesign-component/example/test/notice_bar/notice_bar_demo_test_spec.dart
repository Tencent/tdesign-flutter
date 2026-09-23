import 'package:tdesign_flutter_example/page/notice_bar/notice_bar_page.dart';

import '../demo_page_test_utils.dart';

enum NoticeBarGoldenStrategy { page, postAction }

class NoticeBarDemoScenario {
  const NoticeBarDemoScenario({
    required this.id,
    required this.group,
    required this.label,
    required this.operation,
    required this.expectedResult,
    required this.goldenStrategy,
  });
  final String id;
  final String group;
  final String label;
  final String operation;
  final String expectedResult;
  final NoticeBarGoldenStrategy goldenStrategy;
}

const noticeBarDemoScenarios = [
  NoticeBarDemoScenario(
    id: 'text',
    group: '组件类型',
    label: '纯文字的公告栏',
    operation: 'none',
    expectedResult: 'renders',
    goldenStrategy: NoticeBarGoldenStrategy.page,
  ),
  NoticeBarDemoScenario(
    id: 'icon',
    group: '组件类型',
    label: '带图标的公告栏',
    operation: 'none',
    expectedResult: 'renders',
    goldenStrategy: NoticeBarGoldenStrategy.page,
  ),
  NoticeBarDemoScenario(
    id: 'close',
    group: '组件类型',
    label: '带关闭的公告栏',
    operation: 'tap close',
    expectedResult: 'shows close feedback',
    goldenStrategy: NoticeBarGoldenStrategy.postAction,
  ),
  NoticeBarDemoScenario(
    id: 'entrance',
    group: '组件类型',
    label: '带入口的公告栏',
    operation: 'tap link and entrance',
    expectedResult: 'shows feedback',
    goldenStrategy: NoticeBarGoldenStrategy.postAction,
  ),
  NoticeBarDemoScenario(
    id: 'custom_style',
    group: '组件类型',
    label: '自定义样式的公告栏',
    operation: 'none',
    expectedResult: 'renders',
    goldenStrategy: NoticeBarGoldenStrategy.page,
  ),
  NoticeBarDemoScenario(
    id: 'custom_content',
    group: '组件类型',
    label: '自定义内容的公告栏',
    operation: 'tap detail',
    expectedResult: 'shows detail feedback',
    goldenStrategy: NoticeBarGoldenStrategy.postAction,
  ),
  NoticeBarDemoScenario(
    id: 'status',
    group: '组件状态',
    label: '公告栏类型有普通（info）、警示（warning）、成功（success）、错误（error）',
    operation: 'none',
    expectedResult: 'renders all statuses',
    goldenStrategy: NoticeBarGoldenStrategy.page,
  ),
  NoticeBarDemoScenario(
    id: 'scroll',
    group: '可滚动公告栏',
    label: '可滚动公告栏有水平（horizontal）和垂直（vertical）',
    operation: 'advance timer',
    expectedResult: 'vertical item advances',
    goldenStrategy: NoticeBarGoldenStrategy.postAction,
  ),
];

const noticeBarDemoPageTestSpec = DemoPageTestSpec(
  useFeedbackGoldenFont: true,
  name: 'notice_bar',
  title: 'NoticeBar 公告栏',
  page: TNoticeBarPage(),
  expectedTexts: ['01 组件类型', '02 组件状态', '03 可滚动公告栏'],
);
