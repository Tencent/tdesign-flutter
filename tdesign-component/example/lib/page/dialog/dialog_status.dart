part of 'dialog_page.dart';

extension _DialogStatusModule on TDialogPage {
  ExampleModule get _dialogStatusModule => ExampleModule(
    title: '组件状态',
    children: [ExampleItem(builder: _buttonDialogs)],
  );
}
