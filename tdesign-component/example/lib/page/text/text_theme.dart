part of 'text_page.dart';

extension _TextThemeModule on TTextPage {
  ExampleModule get _textThemeModule => ExampleModule(
    title: '组件主题',
    children: [ExampleItem(desc: '子树默认样式', builder: _buildThemeDemo)],
  );
}
