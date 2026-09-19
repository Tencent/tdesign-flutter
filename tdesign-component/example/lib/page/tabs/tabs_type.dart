part of 'tabs_page.dart';

extension _TabsTypeModule on TTabsPage {
  ExampleModule get _tabsTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '均分选项卡', builder: _buildItemWithSplit1),
      ExampleItem(builder: _buildItemWithSplit2),
      ExampleItem(builder: _buildItemWithSplit3),
      ExampleItem(builder: _buildItemWithSplit4),
      ExampleItem(desc: '等距选项卡', builder: _buildItemWithSpace),
      ExampleItem(desc: '带图标选项卡', builder: _buildItemWithIcon),
      ExampleItem(desc: '带徽标选项卡', builder: _buildItemWithLogo),
      ExampleItem(desc: '带内容区选项卡', builder: _buildItemWithContent),
    ],
  );
}
