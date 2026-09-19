part of 'checkbox_page.dart';

extension _CheckboxStatusModule on _TCheckboxPageState {
  ExampleModule get _checkboxStatusModule => ExampleModule(
    title: '组件状态',
    children: [ExampleItem(desc: '多选框状态', builder: _disabledCheckbox)],
  );
}
