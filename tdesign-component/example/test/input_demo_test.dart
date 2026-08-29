import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_input_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  registerDemoPageTests(
    const DemoPageTestSpec(
      name: 'input',
      title: 'Input 输入框',
      page: TInputViewPage(),
      expectedTexts: ['01 组件类型', '02 组件状态', '03 组件样式'],
      componentType: TInput,
    ),
  );
}
