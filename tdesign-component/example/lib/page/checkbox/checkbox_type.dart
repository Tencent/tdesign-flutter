part of 'checkbox_page.dart';

extension _CheckboxTypeModule on _TCheckboxPageState {
  ExampleModule get _checkboxTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '纵向多选框', builder: _verticalCheckbox),
      ExampleItem(desc: '横向多选框', builder: _horizontalCheckbox),
      ExampleItem(desc: '带全选多选框', builder: _checkAll),
    ],
  );
}
