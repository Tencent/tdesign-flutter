part of 'textarea_page.dart';

extension _TextareaStatusModule on TTextareaPage {
  ExampleModule get _textareaStatusModule => ExampleModule(
    title: '组件状态',
    children: [
      ExampleItem(desc: '禁用状态', builder: _buildDisabled, center: false),
    ],
  );
}
