part of 'picker_page.dart';

extension _PickerTypeModule on _TPickerPageState {
  ExampleModule get _pickerTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '基础选择器', builder: _buildBase, methodName: '_cell'),
      ExampleItem(builder: _buildTime, methodName: '_cell'),
      ExampleItem(builder: _buildArea, methodName: '_cell'),
    ],
  );
}
