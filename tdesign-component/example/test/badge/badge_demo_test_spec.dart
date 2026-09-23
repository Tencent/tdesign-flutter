import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/badge/badge_page.dart';

import '../demo_page_test_utils.dart';

const badgeDemoPageTestSpec = DemoPageTestSpec(
  name: 'badge',
  title: 'Badge 徽标',
  page: TBadgePage(),
  expectedTexts: [
    '01 组件类型',
    '红点徽标',
    '数字徽标',
    '自定义徽标',
    '02 组件样式',
    '圆形徽标',
    '方形徽标',
    '气泡徽标',
    '角标',
    '三角角标',
    '03 组件尺寸',
    'Large',
    'Medium',
  ],
  componentType: TBadge,
  expectedComponentCount: 16,
  supplementalCjkFontFamily: 'Badge Golden CJK',
  supplementalCjkFontPath: 'test/fonts/BadgeGoldenCJK-Regular.otf',
  precacheAssetImages: ['assets/img/t_avatar_1.png'],
);
