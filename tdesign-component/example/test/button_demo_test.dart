import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_button_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  registerDemoPageTests(
    const DemoPageTestSpec(
      name: 'button',
      title: 'Button 按钮',
      page: TButtonPage(),
      expectedTexts: ['01 组件类型', '02 组件状态', '03 组件主题'],
      componentType: TButton,
    ),
  );
}
