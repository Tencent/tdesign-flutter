part of 'toast_page.dart';

extension _ToastBasicModule on TToastPage {
  ExampleModule get _toastBasicModule => ExampleModule(
    title: '基础提示',
    children: [
      ExampleItem(desc: '纯文本', builder: _buildTextToast),
      ExampleItem(desc: '多行文字', builder: _buildMultipleTextToast),
      ExampleItem(desc: '带横向图标', builder: _buildHorizontalIconToast),
      ExampleItem(desc: '带竖向图标', builder: _buildVerticalIconToast),
      ExampleItem(desc: '加载状态', builder: _buildLoadingToast),
    ],
  );
}
