part of 'message_page.dart';

extension _MessageTypeModule on TMessagePage {
  ExampleModule get _messageTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '消息通知内容为文本、带操作按钮', builder: _buildMessageTypes),
    ],
  );
}
