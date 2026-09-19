part of 'textarea_page.dart';

extension _TextareaSpecialModule on TTextareaPage {
  ExampleModule get _textareaSpecialModule => ExampleModule(
    title: '特殊样式',
    children: [
      ExampleItem(desc: '标签外置输入框', builder: _buildCustom, center: false),
    ],
  );
}
