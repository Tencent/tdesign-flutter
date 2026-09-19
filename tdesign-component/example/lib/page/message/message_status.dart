part of 'message_page.dart';

extension _MessageStatusModule on TMessagePage {
  ExampleModule get _messageStatusModule => ExampleModule(
    title: '组件状态',
    children: [ExampleItem(desc: '消息组件风格', builder: _buildMessageStyles)],
  );
}
