import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_divider_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  registerDemoPageTests(
    const DemoPageTestSpec(
      name: 'divider',
      title: 'Divider 分割线',
      page: TDividerPage(),
      expectedTexts: ['01 组件类型', '02 组件状态'],
      componentType: TDivider,
    ),
  );
}
