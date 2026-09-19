part of 'search_bar_page.dart';

extension _SearchBarTypeModule on _TSearchBarPageState {
  ExampleModule get _searchBarTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '基础搜索框', center: false, builder: _buildBase),
      ExampleItem(desc: '字数限制', center: false, builder: _buildMaxLength),
      ExampleItem(desc: '获取焦点后显示取消按钮', center: false, builder: _buildAction),
    ],
  );
}
