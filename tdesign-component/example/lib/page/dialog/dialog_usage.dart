part of 'dialog_page.dart';

extension _DialogUsageModule on TDialogPage {
  ExampleModule get _dialogUsageModule => ExampleModule(
    title: '组件用法',
    children: [
      ExampleItem(desc: '命令调用', builder: _commandDialog),
      ExampleItem(desc: '自定义按钮', builder: _customActionDialog),
    ],
  );
}
