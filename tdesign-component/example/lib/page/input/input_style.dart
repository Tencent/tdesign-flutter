part of 'input_page.dart';

extension _InputStyleModule on _TInputViewPageState {
  ExampleModule get _inputStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(desc: '内容位置', builder: _buildAlign, center: false),
      ExampleItem(desc: '竖排样式', builder: _buildLayout, center: false),
      ExampleItem(desc: '非通栏样式', builder: _buildBanner, center: false),
      ExampleItem(desc: '标签外置样式', builder: _buildBordered, center: false),
      ExampleItem(desc: '自定义样式输入框', builder: _buildCustom, center: false),
    ],
  );
}
