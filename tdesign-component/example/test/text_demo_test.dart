import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_text_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  registerDemoPageTests(
    const DemoPageTestSpec(
      name: 'text',
      title: 'Text 文本',
      page: TTextPage(),
      expectedTexts: ['01 组件类型', '02 文本样式', '03 段落与辅助能力', '04 可复制', '05 文本省略（展开/收起）', '06 组件主题'],
      componentType: TText,
    ),
  );
}
