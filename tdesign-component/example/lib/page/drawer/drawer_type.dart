part of 'drawer_page.dart';

extension _DrawerTypeModule on TDrawerPage {
  ExampleModule get _drawerTypeModule => const ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        desc: '基础抽屉',
        padding: EdgeInsets.symmetric(horizontal: 16),
        builder: _buildBaseSimple,
      ),
      ExampleItem(
        desc: '带图标抽屉',
        padding: EdgeInsets.symmetric(horizontal: 16),
        builder: _buildIconSimple,
      ),
    ],
  );
}
