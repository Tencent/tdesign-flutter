import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_steps_page.dart';

import 'demo_page_test_utils.dart';

const stepsDemoPageTestSpec = DemoPageTestSpec(
  name: 'steps',
  title: 'Steps 步骤条',
  page: TStepsPage(),
  componentType: TSteps,
  expectedComponentCount: 12,
  useAlignmentCjkFont: true,
  supplementalCjkFontFamily: 'TDesign Steps Golden CJK',
  supplementalCjkFontPath: 'test/fonts/StepsGoldenCJK-Regular.otf',
  precacheAssetImages: ['assets/img/image.png'],
  expectedTexts: [
    '用于任务步骤展示或任务进度展示。',
    '01 组件类型',
    'Horizontal Default Steps 水平默认步骤条',
    'Vertical Icon Steps 垂直图标步骤条',
    'Customize Steps Content 自定义步骤条内容',
    '02 组件状态',
    'Error 错误状态',
    '03 特殊类型',
    'Vertical Customize Steps 垂直自定义步骤条',
    'Read-only Steps 纯展示步骤条',
  ],
);
