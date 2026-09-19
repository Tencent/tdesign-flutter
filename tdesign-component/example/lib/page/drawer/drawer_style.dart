part of 'drawer_page.dart';

extension _DrawerStyleModule on TDrawerPage {
  ExampleModule get _drawerStyleModule => const ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(
        desc: '带标题样式',
        padding: EdgeInsets.symmetric(horizontal: 16),
        builder: _buildTitleSimple,
      ),
      ExampleItem(
        desc: '抽屉方向',
        padding: EdgeInsets.symmetric(horizontal: 16),
        builder: _buildPlacementSimple,
      ),
      ExampleItem(
        desc: '带底部插槽样式',
        padding: EdgeInsets.symmetric(horizontal: 16),
        builder: _buildBottomSimple,
      ),
    ],
  );
}
