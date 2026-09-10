import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_result_page.dart';

import 'demo_page_test_utils.dart';

const resultDemoPageTestSpec = DemoPageTestSpec(
  name: 'result',
  title: 'Result 结果',
  page: TResultPage(),
  expectedTexts: [
    '01 组件类型',
    '基础结果',
    '带描述结果',
    '自定义结果',
    '页面示例',
    '成功状态',
    '失败状态',
    '警示状态',
    '默认状态',
    '描述文字',
  ],
  componentType: TResult,
  expectedComponentCount: 9,
  useAlignmentCjkFont: true,
  precacheAssetImages: ['assets/img/illustration.png'],
);
