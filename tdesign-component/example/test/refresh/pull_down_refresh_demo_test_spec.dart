import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_pull_down_refresh_page.dart';

import '../demo_page_test_utils.dart';

class PullDownRefreshDemoScenario {
  const PullDownRefreshDemoScenario({
    required this.id,
    required this.group,
    required this.label,
    required this.operation,
    required this.expectedResult,
  });
  final String id;
  final String group;
  final String label;
  final String operation;
  final String expectedResult;
}

const pullDownRefreshDemoScenarios = [
  PullDownRefreshDemoScenario(
    id: 'basic',
    group: '顶部下拉刷新',
    label: '基础用法',
    operation: 'tap or pull',
    expectedResult: 'refreshing indicator',
  ),
  PullDownRefreshDemoScenario(
    id: 'custom_text',
    group: '自定义提示语',
    label: 'loadingTexts（小程序已有公开 props 的新增 API 演示，Demo 形态仅参考 Mobile Vue）',
    operation: 'pull',
    expectedResult: 'custom refreshing text',
  ),
  PullDownRefreshDemoScenario(
    id: 'timeout',
    group: '刷新超时',
    label: 'refreshTimeout（小程序已有公开 props 的新增 API 演示，Demo 形态仅参考 Mobile Vue）',
    operation: 'pull and wait',
    expectedResult: 'timeout feedback',
  ),
];

const pullDownRefreshDemoPageTestSpec = DemoPageTestSpec(
  name: 'pull_down_refresh',
  goldenDirectory: 'refresh',
  title: 'PullDownRefresh 下拉刷新',
  page: TPullDownRefreshPage(),
  useFeedbackGoldenFont: true,
  expectedTexts: ['01 顶部下拉刷新', '02 自定义提示语', '03 刷新超时'],
  componentType: TPullDownRefresh,
  expectedComponentCount: 3,
);
