import 'package:tdesign_flutter_example/page/t_slider_page.dart';

import 'demo_page_test_utils.dart';

const sliderDemoPageTestSpec = DemoPageTestSpec(
  name: 'slider',
  title: 'Slider 滑动选择器',
  page: TSliderPage(),
  expectedTexts: [
    '用于选择横轴上的数值、区间、档位。',
    '01 组件类型',
    '单游标滑块',
    '双游标滑块',
    '带数值滑动选择器',
    '起始非零滑动选择器',
    '带刻度滑动选择器',
    '02 组件状态',
    '滑块禁用状态',
    '03 特殊样式',
    '胶囊型滑块',
    '04 垂直状态',
  ],
  useAlignmentCjkFont: true,
  supplementalCjkFontFamily: 'TDesign Slider Golden CJK',
  supplementalCjkFontPath: 'test/fonts/SliderGoldenCJK-Regular.otf',
);
