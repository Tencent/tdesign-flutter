part of 'tab_bar_page.dart';

extension _TabBarTypeModule on _TTabBarPageState {
  ExampleModule get _tabBarTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        desc: '纯文本标签栏',
        builder: _textTabBar,
        methodName: '_textTabBar',
      ),
      ExampleItem(
        desc: '图标加文本标签栏',
        builder: _iconTextTabBar,
        methodName: '_iconTextTabBar',
      ),
      ExampleItem(
        desc: '纯图标标签栏',
        builder: _iconTabBar,
        methodName: '_iconTabBar',
      ),
      ExampleItem(
        desc: '双层级文本标签栏',
        builder: _doubleLayerTabBar,
        methodName: '_doubleLayerTabBar',
      ),
    ],
  );
}
