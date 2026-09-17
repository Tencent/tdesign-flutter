import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_theme_page.dart';

import '../demo_page_test_utils.dart';

void main() {
  const spec = DemoPageTestSpec(
    name: 'theme',
    title: 'Theme 主题',
    page: TThemeColorsPage(),
    expectedTexts: ['01 颜色示例', '功能色', '文字&图标颜色', '中性色板'],
    componentType: TText,
  );
  registerDemoPageTests(spec);
}
