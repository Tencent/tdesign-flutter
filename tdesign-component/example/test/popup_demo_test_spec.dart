import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_popup_page.dart';

import 'demo_page_test_utils.dart';

const popupDemoPageTestSpec = DemoPageTestSpec(
  name: 'popup',
  title: 'Popup 弹出层',
  page: TPopupPage(),
  expectedTexts: [
    '01 组件类型',
    '基础弹出层',
    '顶部弹出',
    '左侧弹出',
    '中间弹出',
    '底部弹出',
    '右侧弹出',
    '02 组件示例',
    '应用示例',
    '底部弹出层-带标题及操作',
    '居中弹出层-带自定义关闭按钮',
  ],
  componentType: TButton,
  expectedComponentCount: 7,
);
