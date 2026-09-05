import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

class TTabBarPage extends StatelessWidget {
  const TTabBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'TabBar 底部标签栏',
      navBarTitle: 'TabBar',
      desc: '用于在不同功能模块之间进行快速切换，位于页面底部。',
      exampleCodeGroup: 'tabBar',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '纯文本标签栏', builder: _textTabBar),
            ExampleItem(desc: '图标加文本标签栏', builder: _iconTextTabBar),
            ExampleItem(desc: '纯图标标签栏', builder: _iconTabBar),
            ExampleItem(desc: '双层级文本标签栏', builder: _doubleLayerTabBar),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(desc: '弱选中标签栏', builder: _weakTabBars),
            ExampleItem(desc: '悬浮胶囊标签栏', builder: _capsuleTabBar),
          ],
        ),
        ExampleModule(
          title: '自定义',
          children: [ExampleItem(desc: '自定义样式', builder: _customTabBar)],
        ),
      ],
    );
  }

  @ExampleCode(group: 'tabBar')
  Widget _textTabBar(BuildContext context) {
    const labels = ['首页', '应用', '聊天', '我的'];
    var value = 0;
    return StatefulBuilder(
      builder: (context, setState) => TTabBar(
        type: TTabBarType.text,
        useSafeArea: false,
        value: value,
        onChanged: (newValue) {
          setState(() => value = newValue);
          TToast.showText('点击了 Item ${newValue + 1}', context: context);
        },
        navigationTabs: List.generate(
          4,
          (index) => TTabBarItemConfig(tabText: labels[index]),
        ),
      ),
    );
  }

  @ExampleCode(group: 'tabBar')
  Widget _iconTextTabBar(BuildContext context) {
    const labels = ['首页', '应用', '聊天', '我的'];
    const icons = [TIcons.home, TIcons.app, TIcons.chat, TIcons.user];
    var value = 0;
    return StatefulBuilder(
      builder: (context, setState) => TTabBar(
        type: TTabBarType.iconText,
        useSafeArea: false,
        value: value,
        onChanged: (newValue) => setState(() => value = newValue),
        navigationTabs: List.generate(
          4,
          (index) => TTabBarItemConfig(
            tabText: labels[index],
            selectedIcon: Icon(icons[index], size: 20),
            unselectedIcon: Icon(icons[index], size: 20),
          ),
        ),
      ),
    );
  }

  @ExampleCode(group: 'tabBar')
  Widget _iconTabBar(BuildContext context) {
    const icons = [TIcons.home, TIcons.app, TIcons.chat, TIcons.user];
    var value = 0;
    return StatefulBuilder(
      builder: (context, setState) => TTabBar(
        type: TTabBarType.icon,
        useSafeArea: false,
        value: value,
        onChanged: (newValue) => setState(() => value = newValue),
        navigationTabs: List.generate(
          4,
          (index) => TTabBarItemConfig(
            selectedIcon: Icon(icons[index], size: 20),
            unselectedIcon: Icon(icons[index], size: 20),
          ),
        ),
      ),
    );
  }

  @ExampleCode(group: 'tabBar')
  Widget _doubleLayerTabBar(BuildContext context) {
    const labels = ['首页', '应用', '聊天', '我的'];
    var value = 0;
    return StatefulBuilder(
      builder: (context, setState) => TTabBar(
        type: TTabBarType.doubleLayer,
        useSafeArea: false,
        value: value,
        onChanged: (newValue) => setState(() => value = newValue),
        navigationTabs: List.generate(
          4,
          (index) => TTabBarItemConfig(
            tabText: labels[index],
            popUpButtonConfig: index == 3
                ? TTabBarPopUpBtnConfig(
                    items: const [
                      TTabBarMenuItem(value: '展开项一'),
                      TTabBarMenuItem(value: '展开项二'),
                      TTabBarMenuItem(value: '展开项三'),
                    ],
                    onChanged: (_) {},
                  )
                : null,
          ),
        ),
      ),
    );
  }

  @ExampleCode(group: 'tabBar')
  Widget _weakTabBars(BuildContext context) {
    const labels = ['首页', '应用', '聊天', '我的'];
    const icons = [TIcons.home, TIcons.app, TIcons.chat, TIcons.user];
    const badges = [
      TBadge(label: '16'),
      TBadge(variant: TBadgeVariant.dot),
      TBadge(label: 'New'),
      TBadge(label: '···'),
    ];
    final values = [0, 0, 0];
    return StatefulBuilder(
      builder: (context, setState) => Column(
        children: [
          TTabBar(
            type: TTabBarType.text,
            itemStyle: TTabBarItemStyle.normal,
            split: true,
            useSafeArea: false,
            value: values[0],
            onChanged: (value) => setState(() => values[0] = value),
            navigationTabs: List.generate(
              4,
              (index) => TTabBarItemConfig(
                tabText: labels[index],
                badgeConfig: TTabBarBadgeConfig(
                  showBadge: true,
                  tBadge: badges[index],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TTabBar(
            type: TTabBarType.icon,
            itemStyle: TTabBarItemStyle.normal,
            useSafeArea: false,
            value: values[1],
            onChanged: (value) => setState(() => values[1] = value),
            navigationTabs: List.generate(
              4,
              (index) => TTabBarItemConfig(
                selectedIcon: Icon(icons[index], size: 20),
                unselectedIcon: Icon(icons[index], size: 20),
                badgeConfig: TTabBarBadgeConfig(
                  showBadge: true,
                  tBadge: badges[index],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TTabBar(
            type: TTabBarType.iconText,
            itemStyle: TTabBarItemStyle.normal,
            useSafeArea: false,
            value: values[2],
            onChanged: (value) => setState(() => values[2] = value),
            navigationTabs: List.generate(
              4,
              (index) => TTabBarItemConfig(
                tabText: labels[index],
                selectedIcon: Icon(icons[index], size: 20),
                unselectedIcon: Icon(icons[index], size: 20),
                badgeConfig: TTabBarBadgeConfig(
                  showBadge: true,
                  tBadge: badges[index],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'tabBar')
  Widget _capsuleTabBar(BuildContext context) {
    const icons = [TIcons.home, TIcons.app, TIcons.chat, TIcons.user];
    var value = 0;
    return StatefulBuilder(
      builder: (context, setState) => TTabBar(
        type: TTabBarType.icon,
        style: TTabBarStyle.capsule,
        useSafeArea: false,
        value: value,
        onChanged: (newValue) => setState(() => value = newValue),
        navigationTabs: List.generate(
          4,
          (index) => TTabBarItemConfig(
            selectedIcon: Icon(icons[index], size: 20),
            unselectedIcon: Icon(icons[index], size: 20),
          ),
        ),
      ),
    );
  }

  @ExampleCode(group: 'tabBar')
  Widget _customTabBar(BuildContext context) {
    const icons = [TIcons.home, TIcons.app, TIcons.chat, TIcons.user];
    var value = 0;
    return StatefulBuilder(
      builder: (context, setState) => TTabBar(
        type: TTabBarType.icon,
        itemStyle: TTabBarItemStyle.normal,
        showTopBorder: false,
        useSafeArea: false,
        value: value,
        onChanged: (newValue) => setState(() => value = newValue),
        navigationTabs: List.generate(
          4,
          (index) => TTabBarItemConfig(
            selectedIcon: Icon(icons[index], size: 20),
            unselectedIcon: Icon(icons[index], size: 20),
          ),
        ),
      ),
    );
  }
}
