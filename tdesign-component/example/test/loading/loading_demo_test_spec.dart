import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_loading_page.dart';

import '../demo_page_test_utils.dart';

enum LoadingDemoGoldenStrategy { page, postAction }

class LoadingDemoScenario {
  const LoadingDemoScenario({
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
  final LoadingDemoGoldenStrategy goldenStrategy;
}

const loadingDemoScenarios = [
  LoadingDemoScenario(
    id: 'icon',
    group: '组件类型',
    label: '纯图标',
    operation: 'none',
    expectedResult: 'renders',
    goldenStrategy: LoadingDemoGoldenStrategy.page,
  ),
  LoadingDemoScenario(
    id: 'horizontal',
    group: '组件类型',
    label: '图标加文字横向',
    operation: 'none',
    expectedResult: 'renders',
    goldenStrategy: LoadingDemoGoldenStrategy.page,
  ),
  LoadingDemoScenario(
    id: 'vertical',
    group: '组件类型',
    label: '图标加文字竖向',
    operation: 'none',
    expectedResult: 'renders',
    goldenStrategy: LoadingDemoGoldenStrategy.page,
  ),
  LoadingDemoScenario(
    id: 'text',
    group: '组件类型',
    label: '纯文字',
    operation: 'none',
    expectedResult: 'renders',
    goldenStrategy: LoadingDemoGoldenStrategy.page,
  ),
  LoadingDemoScenario(
    id: 'size',
    group: '组件尺寸',
    label: '大尺寸',
    operation: 'none',
    expectedResult: 'renders all sizes',
    goldenStrategy: LoadingDemoGoldenStrategy.page,
  ),
  LoadingDemoScenario(
    id: 'speed',
    group: '加载速度',
    label: '加载速度调整',
    operation: 'drag slider',
    expectedResult: 'duration label changes',
    goldenStrategy: LoadingDemoGoldenStrategy.postAction,
  ),
];

const loadingDemoPageTestSpec = DemoPageTestSpec(
  name: 'loading',
  title: 'Loading 加载',
  page: TLoadingPage(),
  useAlignmentCjkFont: true,
  precacheAssetImages: ['assets/img/loading-logo2.png'],
  expectedTexts: [
    '01 组件类型',
    '纯图标',
    '图标加文字横向',
    '图标加文字竖向',
    '纯文字',
    '02 组件尺寸',
    '大尺寸',
    '中尺寸',
    '小尺寸',
    '03 加载速度',
    '加载速度调整',
    '800',
  ],
  componentType: TLoading,
  expectedComponentCount: 13,
);
