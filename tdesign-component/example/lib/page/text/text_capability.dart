part of 'text_page.dart';

extension _TextCapabilityModule on TTextPage {
  ExampleModule get _textCapabilityModule => ExampleModule(
    title: '段落与辅助能力',
    children: [
      ExampleItem(desc: '多行省略', builder: _buildOverflow),
      ExampleItem(desc: '对齐与文字缩放', builder: _buildLayout),
      ExampleItem(desc: '文字选择与语义', builder: _buildAccessibleText),
      ExampleItem(desc: '获取 Flutter 原生 Text', builder: _buildRawText),
    ],
  );
}
