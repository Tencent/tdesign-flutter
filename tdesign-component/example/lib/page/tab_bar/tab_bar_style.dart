part of 'tab_bar_page.dart';

extension _TabBarStyleModule on _TTabBarPageState {
  ExampleModule get _tabBarStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(
        desc: '弱选中标签栏',
        builder: _weakTabBars,
        methodName: '_weakTabBars',
      ),
      ExampleItem(
        desc: '悬浮胶囊标签栏',
        builder: _capsuleTabBar,
        methodName: '_capsuleTabBar',
      ),
    ],
  );
}
