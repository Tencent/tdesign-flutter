part of 'sidebar_page.dart';

extension _SidebarStyleModule on TSideBarPageState {
  ExampleModule get _sidebarStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(
        desc: '侧边导航样式',
        padding: const EdgeInsets.symmetric(horizontal: 16),
        ignoreCode: true,
        builder: _buildStyleSideBar,
      ),
    ],
  );
}
