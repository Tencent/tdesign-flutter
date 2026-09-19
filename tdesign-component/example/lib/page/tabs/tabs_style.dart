part of 'tabs_page.dart';

extension _TabsStyleModule on TTabsPage {
  ExampleModule get _tabsStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(desc: '选项卡尺寸', builder: _buildItemWithSizeSmall),
      ExampleItem(builder: _buildItemWithSizeLarge),
      ExampleItem(desc: '选项卡样式', builder: _buildItemWithLine),
      ExampleItem(builder: _buildItemWithTag),
    ],
  );
}
