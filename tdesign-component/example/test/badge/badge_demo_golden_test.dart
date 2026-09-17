import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_badge_page.dart';

import '../demo_page_test_utils.dart';

void main() {
  registerDemoGoldenTests(
    const DemoPageTestSpec(
      name: 'badge',
      title: 'Badge 徽标',
      page: TBadgePage(),
      expectedTexts: ['01 组件类型', '02 组件样式', '03 组件尺寸'],
      componentType: TBadge,
    ),
  );
}
