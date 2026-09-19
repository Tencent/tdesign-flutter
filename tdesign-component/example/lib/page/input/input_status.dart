part of 'input_page.dart';

extension _InputStatusModule on _TInputViewPageState {
  ExampleModule get _inputStatusModule => ExampleModule(
    title: '组件状态',
    children: [
      ExampleItem(desc: '输入框状态', builder: _buildStatus, center: false),
      ExampleItem(desc: '信息超长状态', builder: _buildLabel, center: false),
    ],
  );
}
