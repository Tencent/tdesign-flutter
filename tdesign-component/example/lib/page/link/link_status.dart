part of 'link_page.dart';

extension _LinkStatusModule on _TLinkViewPageState {
  ExampleModule get _linkStatusModule => ExampleModule(
    title: '组件状态',
    children: [
      ExampleItem(desc: '不同主题', builder: _buildColorSchemeLinks),
      ExampleItem(desc: '禁用状态', builder: _buildDisabledLinks),
    ],
  );
}
