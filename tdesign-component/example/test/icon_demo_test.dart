import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_icon_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  registerDemoPageTests(
    const DemoPageTestSpec(
      name: 'icon',
      title: 'Icon 图标',
      page: TIconPage(),
      expectedTexts: ['01 主题与图标', '02 icon示例'],
      componentType: TIcon,
    ),
  );
}
