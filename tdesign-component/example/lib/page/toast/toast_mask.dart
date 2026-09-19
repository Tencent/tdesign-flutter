part of 'toast_page.dart';

extension _ToastMaskModule on TToastPage {
  ExampleModule get _toastMaskModule => ExampleModule(
    title: '显示遮罩',
    children: [ExampleItem(desc: '禁止滑动和点击', builder: _buildCoverToast)],
  );
}
