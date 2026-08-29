import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_textarea_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  registerDemoPageTests(
    const DemoPageTestSpec(
      name: 'textarea',
      title: 'Textarea 多行文本框',
      page: TTextareaPage(),
      expectedTexts: ['01 组件类型', '02 组件状态', '03 组件样式', '04 特殊样式'],
      componentType: TTextarea,
    ),
  );
}
