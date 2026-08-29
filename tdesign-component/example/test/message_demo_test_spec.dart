import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_message_page.dart';

import 'demo_page_test_utils.dart';

const messageDemoPageTestSpec = DemoPageTestSpec(
  name: 'message',
  title: 'Message 消息通知',
  page: TMessagePage(),
  expectedTexts: [
    '01 组件类型',
    '消息通知内容为文本、带操作按钮',
    '纯文字的通知',
    '带图标的通知',
    '带关闭的通知',
    '可滚动的通知',
    '带按钮的通知',
    '组件调用',
    '02 组件状态',
    '消息组件风格',
    '普通通知',
    '成功通知',
    '警示通知',
    '错误通知',
  ],
  componentType: TButton,
  expectedComponentCount: 10,
);
