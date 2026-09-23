import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/message/message_page.dart';

import '../demo_page_test_utils.dart';

enum MessageDemoLifetime { autoDismiss, persistent }

class MessageDemoCase {
  const MessageDemoCase({
    required this.name,
    required this.triggerText,
    required this.visibleText,
    required this.lifetime,
    this.actionText,
    this.hasCloseButton = false,
  });

  final String name;
  final String triggerText;
  final String visibleText;
  final MessageDemoLifetime lifetime;
  final String? actionText;
  final bool hasCloseButton;
}

const messageDemoCases = [
  MessageDemoCase(
    name: 'text',
    triggerText: '纯文字的通知',
    visibleText: '这是一条纯文字的消息通知',
    lifetime: MessageDemoLifetime.autoDismiss,
  ),
  MessageDemoCase(
    name: 'icon',
    triggerText: '带图标的通知',
    visibleText: '这是一条带图标的消息通知',
    lifetime: MessageDemoLifetime.autoDismiss,
  ),
  MessageDemoCase(
    name: 'closeable',
    triggerText: '带关闭的通知',
    visibleText: '这是一条带关闭的消息通知',
    lifetime: MessageDemoLifetime.persistent,
    hasCloseButton: true,
  ),
  MessageDemoCase(
    name: 'marquee',
    triggerText: '可滚动的通知',
    visibleText: '这是一条较长的通知信息，这是一条较长的通知信息，这是一条较长的通知信息',
    lifetime: MessageDemoLifetime.persistent,
  ),
  MessageDemoCase(
    name: 'action',
    triggerText: '带按钮的通知',
    visibleText: '这是一条带操作的消息通知',
    lifetime: MessageDemoLifetime.persistent,
    actionText: '链接',
  ),
  MessageDemoCase(
    name: 'function',
    triggerText: '函数式调用',
    visibleText: '这是一条通过函数式调用的消息通知',
    lifetime: MessageDemoLifetime.autoDismiss,
  ),
  MessageDemoCase(
    name: 'info',
    triggerText: '普通通知',
    visibleText: '这是一条普通通知信息',
    lifetime: MessageDemoLifetime.autoDismiss,
  ),
  MessageDemoCase(
    name: 'success',
    triggerText: '成功通知',
    visibleText: '这是一条成功的提示消息',
    lifetime: MessageDemoLifetime.autoDismiss,
  ),
  MessageDemoCase(
    name: 'warning',
    triggerText: '警示通知',
    visibleText: '这是一条需要用户关注到的警示通知',
    lifetime: MessageDemoLifetime.autoDismiss,
  ),
  MessageDemoCase(
    name: 'error',
    triggerText: '错误通知',
    visibleText: '这是一条错误提示通知',
    lifetime: MessageDemoLifetime.autoDismiss,
  ),
];

const messageDemoPageTestSpec = DemoPageTestSpec(
  name: 'message',
  title: 'Message 消息通知',
  page: TMessagePage(),
  useAlignmentCjkFont: true,
  expectedTexts: [
    '01 组件类型',
    '纯文字的通知',
    '带图标的通知',
    '带关闭的通知',
    '可滚动的通知',
    '带按钮的通知',
    '函数式调用',
    '02 组件状态',
    '普通通知',
    '成功通知',
    '警示通知',
    '错误通知',
  ],
  componentType: TButton,
  expectedComponentCount: 10,
);
