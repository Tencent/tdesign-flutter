part of 'toast_page.dart';

extension _ToastManualCloseModule on TToastPage {
  ExampleModule get _toastManualCloseModule => ExampleModule(
    title: '手动关闭',
    children: [
      ExampleItem(desc: '显示提示', builder: _buildShowToast),
      ExampleItem(desc: '关闭提示', builder: _buildHideToast),
    ],
  );
}
