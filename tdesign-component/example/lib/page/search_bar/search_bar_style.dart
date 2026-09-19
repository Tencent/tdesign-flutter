part of 'search_bar_page.dart';

extension _SearchBarStyleModule on _TSearchBarPageState {
  ExampleModule get _searchBarStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(desc: '搜索框形状', center: false, builder: _buildShape),
      ExampleItem(desc: '默认状态其他对齐方式', center: false, builder: _buildCenter),
    ],
  );
}
