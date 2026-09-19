part of 'link_page.dart';

extension _LinkTypeModule on _TLinkViewPageState {
  ExampleModule get _linkTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '基础文字链接', builder: _buildBasicLinks),
      ExampleItem(desc: '下划线文字链接', builder: _buildUnderlineLinks),
      ExampleItem(desc: '前置图标文字链接', builder: _buildPrefixLinks),
      ExampleItem(desc: '后置图标文字链接', builder: _buildSuffixLinks),
    ],
  );
}
