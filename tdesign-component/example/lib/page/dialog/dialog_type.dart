part of 'dialog_page.dart';

extension _DialogTypeModule on TDialogPage {
  ExampleModule get _dialogTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '反馈类对话框', builder: _feedbackDialogs),
      ExampleItem(desc: '确认类对话框', builder: _confirmDialogs),
      ExampleItem(desc: '输入类对话框', builder: _inputDialogs),
      ExampleItem(desc: '带图片的对话框', builder: _imageDialogs),
    ],
  );
}
