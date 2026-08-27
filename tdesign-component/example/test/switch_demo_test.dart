import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_switch_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  registerDemoPageTests(
    const DemoPageTestSpec(
      name: 'switch',
      title: 'Switch 开关',
      page: TSwitchPage(),
      expectedTexts: [
        '01 组件类型',
        '02 组件状态',
        '03 组件样式',
        '基础开关',
        '带描述开关',
        '自定义颜色开关',
        '开关尺寸',
      ],
      componentType: TSwitch,
      expectedComponentCount: 11,
    ),
  );
}
