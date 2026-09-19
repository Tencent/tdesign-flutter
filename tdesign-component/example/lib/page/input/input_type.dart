part of 'input_page.dart';

extension _InputTypeModule on _TInputViewPageState {
  ExampleModule get _inputTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '基础输入框', builder: _buildBasic, center: false),
      ExampleItem(desc: '带字数限制输入框', builder: _buildFormatter, center: false),
      ExampleItem(desc: '带操作输入框', builder: _buildAction, center: false),
      ExampleItem(desc: '带图标输入框', builder: _buildSlots, center: false),
      ExampleItem(desc: '特定类型输入框', builder: _buildPassword, center: false),
    ],
  );
}
