import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_progress_page.dart';

import 'demo_page_test_utils.dart';

const progressDemoPageTestSpec = DemoPageTestSpec(
  name: 'progress',
  title: 'Progress 进度条',
  page: TProgressPage(),
  expectedTexts: [
    '01 组件类型',
    '线性进度条',
    '百分比内显',
    '环形进度条',
    '微型环形进度条',
    '带操作图片预览',
    '微型按钮进度条',
    '02 组件状态',
    '线性进度条',
    '百分比内显进度条',
    '环形进度条',
  ],
  componentType: TProgress,
  expectedComponentCount: 20,
  useAlignmentCjkFont: true,
  supplementalCjkFontFamily: 'Noto Sans SC',
  supplementalCjkFontPath: 'test/fonts/ProgressGoldenCJK-Regular.otf',
);
