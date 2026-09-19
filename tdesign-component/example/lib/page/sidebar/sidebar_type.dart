part of 'sidebar_page.dart';

extension _SidebarTypeModule on TSideBarPageState {
  ExampleModule get _sidebarTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        desc: '侧边导航用法',
        padding: const EdgeInsets.symmetric(horizontal: 16),
        ignoreCode: true,
        builder: _buildNavigatorSideBar,
      ),
      ExampleItem(
        desc: '带图标侧边导航',
        padding: const EdgeInsets.symmetric(horizontal: 16),
        builder: _buildIconSideBar,
        // 图标示例复用锚点页面的真实组件实现；这里不能指向仅负责跳转的按钮方法。
        methodName: '_buildAnchorSideBar',
      ),
    ],
  );
}
