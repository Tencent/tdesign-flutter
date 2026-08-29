import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_fab_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  registerDemoPageTests(
    const DemoPageTestSpec(
      name: 'fab',
      title: 'Fab 悬浮按钮',
      page: TFabPage(),
      expectedTexts: ['01 组件类型', '02 组件样式'],
      componentType: TFab,
    ),
  );
}
