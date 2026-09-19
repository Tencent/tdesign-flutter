part of 'link_page.dart';

extension _LinkStyleModule on _TLinkViewPageState {
  ExampleModule get _linkStyleModule => ExampleModule(
    title: '组件样式',
    children: [ExampleItem(desc: '链接尺寸', builder: _buildLinkSizes)],
  );
}
