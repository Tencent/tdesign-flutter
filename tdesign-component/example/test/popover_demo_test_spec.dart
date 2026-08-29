import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_popover_page.dart';

import 'demo_page_test_utils.dart';

const popoverDemoPageTestSpec = DemoPageTestSpec(
  name: 'popover',
  title: 'Popover 弹出气泡',
  page: TPopoverPage(),
  useAlignmentCjkFont: true,
  expectedTexts: [
    '01 组件类型',
    '带箭头的弹出气泡',
    '不带箭头的弹出气泡',
    '自定义内容弹出气泡',
    '02 组件样式',
    '深色',
    '浅色',
    '品牌色',
    '成功色',
    '警告色',
    '错误色',
    '顶部弹出气泡',
    '底部弹出气泡',
    '右侧弹出气泡',
    '左侧弹出气泡',
  ],
  componentType: TButton,
  expectedComponentCount: 21,
);
