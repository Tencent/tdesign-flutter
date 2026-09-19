part of 'checkbox_page.dart';

extension _CheckboxStyleModule on _TCheckboxPageState {
  ExampleModule get _checkboxStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(desc: '勾选样式', builder: _variants),
      ExampleItem(desc: '勾选显示位置', builder: _positions),
      ExampleItem(desc: '非通栏多选样式', builder: _nonFullWidthCheckbox),
    ],
  );
}
