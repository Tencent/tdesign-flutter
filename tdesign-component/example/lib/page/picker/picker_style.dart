part of 'picker_page.dart';

extension _PickerStyleModule on _TPickerPageState {
  ExampleModule get _pickerStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(desc: '是否带标题', builder: _buildTitle, methodName: '_cell'),
    ],
  );
}
