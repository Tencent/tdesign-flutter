import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_swiper_page.dart';

import 'demo_page_test_utils.dart';

const swiperDemoPageTestSpec = DemoPageTestSpec(
  name: 'swiper',
  title: 'Swiper 轮播图',
  page: TSwiperPage(),
  expectedTexts: [
    '01 组件类型',
    '点状（dots）',
    '点条状（dots-bar）',
    '分式（fraction）',
    '切换按钮（controls）',
    '卡片式（cards）',
    '02 组件样式',
    '垂直模式',
    '自动播放',
    '自动播放间隔时间（单位毫秒）',
    '动画持续时间（单位毫秒）',
  ],
  componentType: TSwiper,
  expectedComponentCount: 7,
  useAlignmentCjkFont: true,
  supplementalCjkFontFamily: 'Swiper Golden CJK',
  supplementalCjkFontPath: 'test/fonts/SwiperGoldenCJK-Regular.otf',
  precacheAssetImages: ['assets/img/swiper1.png', 'assets/img/swiper2.png'],
);
