part of 'textarea_page.dart';

extension _TextareaTypeModule on TTextareaPage {
  ExampleModule get _textareaTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '基础多行文本框', builder: _buildBasic, center: false),
      ExampleItem(desc: '带标题多行文本框', builder: _buildLabel, center: false),
      ExampleItem(desc: '自动增高多行文本框', builder: _buildAutosize, center: false),
      ExampleItem(desc: '设置字符数限制', builder: _buildMaxLength, center: false),
    ],
  );
}
