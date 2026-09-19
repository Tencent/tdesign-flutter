part of 'text_page.dart';

extension _TextStyleModule on TTextPage {
  ExampleModule get _textStyleModule => ExampleModule(
    title: '文本样式',
    children: [
      ExampleItem(desc: '字体 Token 与颜色', builder: _buildTokenStyle),
      ExampleItem(desc: '字重与删除线', builder: _buildDecoration),
      ExampleItem(desc: '字形背景与行盒背景', builder: _buildBackground),
      ExampleItem(desc: '字体族与资源 package', builder: _buildFontFamily),
    ],
  );
}
