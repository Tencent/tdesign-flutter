part of 'tabs_page.dart';

extension _TabsStatusModule on TTabsPage {
  ExampleModule get _tabsStatusModule => ExampleModule(
    title: '组件状态',
    children: [ExampleItem(desc: '选项卡状态', builder: _buildItemWithStatus)],
  );
}
