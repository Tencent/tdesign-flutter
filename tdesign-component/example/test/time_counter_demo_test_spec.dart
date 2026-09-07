import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_time_counter_page.dart';

import 'demo_page_test_utils.dart';

const timeCounterDemoPageTestSpec = DemoPageTestSpec(
  name: 'time_counter',
  title: 'TimeCounter 计时器',
  page: TTimeCounterPage(),
  expectedTexts: [
    '01 组件类型',
    '时分秒',
    '带毫秒',
    '带方形底',
    '带圆形底',
    '带单位',
    '无底色带单位',
    '02 组件尺寸',
  ],
  componentType: TTimeCounter,
  expectedComponentCount: 21,
  useAlignmentCjkFont: true,
  // Linux Skia cannot rasterize the bundled variable number font reliably;
  // this deterministic subset covers both the explicit family and CJK fallback.
  supplementalCjkFontFamily: 'packages/tdesign_flutter/TCloudNumber',
  supplementalCjkFontPath:
      'test/fonts/TimeCounterGoldenCJK-Regular.otf',
);
