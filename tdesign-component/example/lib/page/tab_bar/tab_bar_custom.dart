part of 'tab_bar_page.dart';

extension _TabBarCustomModule on _TTabBarPageState {
  ExampleModule get _tabBarCustomModule => ExampleModule(
    title: '自定义',
    children: [
      ExampleItem(
        desc: '自定义样式',
        builder: _customTabBar,
        methodName: '_customTabBar',
      ),
    ],
  );
}
