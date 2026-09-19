import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

part 'tab_bar_type.dart';
part 'tab_bar_style.dart';
part 'tab_bar_custom.dart';

class TTabBarPage extends StatefulWidget {
  const TTabBarPage({super.key});

  @override
  State<TTabBarPage> createState() => _TTabBarPageState();
}

class _TTabBarPageState extends State<TTabBarPage> {
  int _textValue = 0;
  int _iconTextValue = 0;
  int _iconValue = 0;
  int _doubleLayerValue = 3;
  final _weakValues = [0, 0, 0];
  int _capsuleValue = 0;
  int _customValue = 0;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'TabBar 底部标签栏',
      desc: '用于在不同功能模块之间进行快速切换，位于页面底部。',
      exampleCodeGroup: 'tabBar',
      compactDemo: true,
      showTestModule: false,
      children: [_tabBarTypeModule, _tabBarStyleModule, _tabBarCustomModule],
    );
  }

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart。
  /// 在 StatefulWidget 的 State 中声明 `int _textValue = 0;`，
  /// 从 build 调用本方法；状态由 State 持有并通过 setState 重建。
  @ExampleCode(group: 'tabBar')
  Widget _textTabBar(BuildContext context) {
    const labels = ['首页', '应用', '聊天', '我的'];
    return TTabBar(
      type: TTabBarType.text,
      useSafeArea: false,
      value: _textValue,
      onChanged: (newValue) {
        setState(() => _textValue = newValue);
        TToast.showText('点击了 Item ${newValue + 1}', context: context);
      },
      navigationTabs: List.generate(
        4,
        (index) => TTabBarItemConfig(tabText: labels[index]),
      ),
    );
  }

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart。
  /// 在 StatefulWidget 的 State 中声明 `int _iconTextValue = 0;`，
  /// 从 build 调用本方法；状态由 State 持有并通过 setState 重建。
  @ExampleCode(group: 'tabBar')
  Widget _iconTextTabBar(BuildContext context) {
    const labels = ['首页', '应用', '聊天', '我的'];
    const icons = [TIcons.home, TIcons.app, TIcons.chat, TIcons.user];
    return TTabBar(
      type: TTabBarType.iconText,
      useSafeArea: false,
      value: _iconTextValue,
      onChanged: (newValue) => setState(() => _iconTextValue = newValue),
      navigationTabs: List.generate(
        4,
        (index) => TTabBarItemConfig(
          tabText: labels[index],
          selectedIcon: Icon(icons[index], size: 20),
          unselectedIcon: Icon(icons[index], size: 20),
        ),
      ),
    );
  }

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart。
  /// 在 StatefulWidget 的 State 中声明 `int _iconValue = 0;`，
  /// 从 build 调用本方法；状态由 State 持有并通过 setState 重建。
  @ExampleCode(group: 'tabBar')
  Widget _iconTabBar(BuildContext context) {
    const icons = [TIcons.home, TIcons.app, TIcons.chat, TIcons.user];
    return TTabBar(
      type: TTabBarType.icon,
      useSafeArea: false,
      value: _iconValue,
      onChanged: (newValue) => setState(() => _iconValue = newValue),
      navigationTabs: List.generate(
        4,
        (index) => TTabBarItemConfig(
          selectedIcon: Icon(icons[index], size: 20),
          unselectedIcon: Icon(icons[index], size: 20),
        ),
      ),
    );
  }

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart。
  /// 在 StatefulWidget 的 State 中声明 `int _doubleLayerValue = 3;`，
  /// 从 build 调用本方法；状态由 State 持有并通过 setState 重建。
  @ExampleCode(group: 'tabBar')
  Widget _doubleLayerTabBar(BuildContext context) {
    const labels = ['首页', '应用', '聊天', '我的'];
    return TTabBar(
      type: TTabBarType.doubleLayer,
      useSafeArea: false,
      value: _doubleLayerValue,
      onChanged: (newValue) => setState(() => _doubleLayerValue = newValue),
      navigationTabs: List.generate(
        4,
        (index) => TTabBarItemConfig(
          tabText: labels[index],
          popUpButtonConfig: index == 3
              ? TTabBarPopUpBtnConfig(
                  items: const [
                    TTabBarMenuItem(value: '基本信息'),
                    TTabBarMenuItem(value: '个人主页'),
                    TTabBarMenuItem(value: '设置'),
                  ],
                  onChanged: (item) =>
                      TToast.showText('选择了$item', context: context),
                )
              : null,
        ),
      ),
    );
  }

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart。
  /// 在 StatefulWidget 的 State 中声明 `final _weakValues = [0, 0, 0];`，
  /// 从 build 调用本方法；状态由 State 持有并通过 setState 重建。
  @ExampleCode(group: 'tabBar')
  Widget _weakTabBars(BuildContext context) {
    const labels = ['首页', '应用', '聊天', '我的'];
    const icons = [TIcons.home, TIcons.app, TIcons.chat, TIcons.user];
    const badges = [
      TBadgeConfig(label: '16'),
      TBadgeConfig(variant: TBadgeVariant.dot),
      TBadgeConfig(label: 'New'),
      TBadgeConfig(label: '···'),
    ];
    return Column(
      children: [
        TTabBar(
          type: TTabBarType.text,
          itemStyle: TTabBarItemStyle.normal,
          split: true,
          useSafeArea: false,
          value: _weakValues[0],
          onChanged: (value) => setState(() => _weakValues[0] = value),
          navigationTabs: List.generate(
            4,
            (index) =>
                TTabBarItemConfig(tabText: labels[index], badge: badges[index]),
          ),
        ),
        const SizedBox(height: 16),
        TTabBar(
          type: TTabBarType.icon,
          itemStyle: TTabBarItemStyle.normal,
          useSafeArea: false,
          value: _weakValues[1],
          onChanged: (value) => setState(() => _weakValues[1] = value),
          navigationTabs: List.generate(
            4,
            (index) => TTabBarItemConfig(
              selectedIcon: Icon(icons[index], size: 20),
              unselectedIcon: Icon(icons[index], size: 20),
              badge: badges[index],
            ),
          ),
        ),
        const SizedBox(height: 16),
        TTabBar(
          type: TTabBarType.iconText,
          itemStyle: TTabBarItemStyle.normal,
          useSafeArea: false,
          value: _weakValues[2],
          onChanged: (value) => setState(() => _weakValues[2] = value),
          navigationTabs: List.generate(
            4,
            (index) => TTabBarItemConfig(
              tabText: labels[index],
              selectedIcon: Icon(icons[index], size: 20),
              unselectedIcon: Icon(icons[index], size: 20),
              badge: badges[index],
            ),
          ),
        ),
      ],
    );
  }

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart。
  /// 在 StatefulWidget 的 State 中声明 `int _capsuleValue = 0;`，
  /// 从 build 调用本方法；状态由 State 持有并通过 setState 重建。
  @ExampleCode(group: 'tabBar')
  Widget _capsuleTabBar(BuildContext context) {
    const icons = [TIcons.home, TIcons.app, TIcons.chat, TIcons.user];
    return TTabBar(
      type: TTabBarType.icon,
      style: TTabBarStyle.capsule,
      useSafeArea: false,
      value: _capsuleValue,
      onChanged: (newValue) => setState(() => _capsuleValue = newValue),
      navigationTabs: List.generate(
        4,
        (index) => TTabBarItemConfig(
          selectedIcon: Icon(icons[index], size: 20),
          unselectedIcon: Icon(icons[index], size: 20),
        ),
      ),
    );
  }

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart。
  /// 在 StatefulWidget 的 State 中声明 `int _customValue = 0;`，
  /// 从 build 调用本方法；状态由 State 持有并通过 setState 重建。
  @ExampleCode(group: 'tabBar')
  Widget _customTabBar(BuildContext context) {
    const icons = [TIcons.home, TIcons.app, TIcons.chat, TIcons.user];
    return TTabBar(
      type: TTabBarType.icon,
      itemStyle: TTabBarItemStyle.normal,
      showTopBorder: false,
      useSafeArea: false,
      value: _customValue,
      onChanged: (newValue) => setState(() => _customValue = newValue),
      navigationTabs: List.generate(
        4,
        (index) => TTabBarItemConfig(
          selectedIcon: Icon(icons[index], size: 20),
          unselectedIcon: Icon(icons[index], size: 20),
        ),
      ),
    );
  }
}
