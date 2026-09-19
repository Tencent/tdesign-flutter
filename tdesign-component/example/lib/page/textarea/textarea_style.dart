part of 'textarea_page.dart';

extension _TextareaStyleModule on TTextareaPage {
  ExampleModule get _textareaStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(desc: '竖排样式', builder: _buildVertical, center: false),
      ExampleItem(desc: '卡片样式', builder: _buildCard, center: false),
    ],
  );
}
