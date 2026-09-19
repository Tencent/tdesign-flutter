part of 'toast_page.dart';

extension _ToastStatusModule on TToastPage {
  ExampleModule get _toastStatusModule => ExampleModule(
    title: '组件状态',
    children: [
      ExampleItem(desc: '成功提示', builder: _buildSuccessToast),
      ExampleItem(desc: '警告提示', builder: _buildWarningToast),
      ExampleItem(desc: '错误提示', builder: _buildFailToast),
    ],
  );
}
