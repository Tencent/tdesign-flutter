import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_dialog_page.dart';

import 'demo_page_test_utils.dart';

const dialogDemoPageTestSpec = DemoPageTestSpec(
  name: 'dialog',
  title: 'Dialog 对话框',
  page: TDialogPage(),
  expectedTexts: [
    '01 组件类型',
    '反馈类对话框',
    '确认类对话框',
    '02 组件状态',
    '按钮布局与关闭按钮',
    '03 特殊类型',
    '带图片对话框',
    '带输入框对话框',
    '命令调用',
  ],
  componentType: TButton,
  expectedComponentCount: 21,
);
