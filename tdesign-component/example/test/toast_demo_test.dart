import 'package:tdesign_flutter_example/page/t_toast_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  registerDemoPageTests(
    const DemoPageTestSpec(
      name: 'toast',
      title: 'Toast 轻提示',
      page: TToastPage(),
      expectedTexts: ['01 基础提示', '02 组件状态', '03 显示遮罩', '04 手动关闭'],
    ),
  );
}
