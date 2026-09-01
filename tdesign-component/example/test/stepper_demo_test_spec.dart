import 'package:tdesign_flutter_example/page/t_stepper_page.dart';

import 'demo_page_test_utils.dart';

const stepperDemoPageTestSpec = DemoPageTestSpec(
  name: 'stepper',
  title: 'Stepper 步进器',
  page: TStepperPage(),
  expectedTexts: [
    '用于数量的增减。',
    '01 组件类型',
    '基础步进器',
    '02 组件状态',
    '最大最小状态',
    '禁用状态',
    '03 组件样式',
    '步进器样式',
    '步进器尺寸',
  ],
  useAlignmentCjkFont: true,
  supplementalCjkFontFamily: 'TDesign Stepper Golden CJK',
  supplementalCjkFontPath: 'test/fonts/StepperGoldenCJK-Regular.otf',
);
