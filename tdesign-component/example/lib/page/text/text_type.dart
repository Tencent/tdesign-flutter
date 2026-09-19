part of 'text_page.dart';

extension _TextTypeModule on TTextPage {
  ExampleModule get _textTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '普通文本', builder: _buildPlainText),
      ExampleItem(desc: '富文本', builder: _buildRichText),
    ],
  );
}
