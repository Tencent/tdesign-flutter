part of 'collapse_page.dart';

extension _CollapseStyleModule on TCollapsePageState {
  ExampleModule get _collapseStyleModule => ExampleModule(
    title: '组件样式',
    children: [ExampleItem(desc: '卡片折叠面板', builder: _buildCardCollapse)],
  );
}
