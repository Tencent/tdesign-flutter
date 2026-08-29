import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_form_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  registerDemoPageTests(
    const DemoPageTestSpec(
      name: 'form',
      title: 'Form 表单',
      page: TFormPage(),
      expectedTexts: ['01 组件类型'],
      componentType: TFormItem,
    ),
  );
}
