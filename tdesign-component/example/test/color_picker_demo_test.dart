import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_color_picker_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  registerDemoPageTests(
    const DemoPageTestSpec(
      name: 'colorPicker',
      title: 'ColorPicker 颜色选择器',
      page: TColorPickerPage(),
      expectedTexts: [
        '01 组件类型',
        '02 组件状态',
        '基础颜色选择器',
        '带色板的颜色选择器',
        '弹窗形式的颜色选择器',
        '组件模式选择',
      ],
      componentType: TColorPicker,
      expectedComponentCount: 3,
    ),
  );
}
