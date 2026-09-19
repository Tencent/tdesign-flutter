part of 'checkbox_page.dart';

extension _CheckboxSpecialModule on _TCheckboxPageState {
  ExampleModule get _checkboxSpecialModule => ExampleModule(
    title: '特殊样式',
    children: [ExampleItem(desc: '纵向卡片多选框', builder: _cardCheckboxes)],
  );
}
