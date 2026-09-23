import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tabBar')
class WeakTabBarsExample extends StatefulWidget {
  const WeakTabBarsExample({super.key});

  @override
  State<WeakTabBarsExample> createState() => _WeakTabBarsExampleState();
}

class _WeakTabBarsExampleState extends State<WeakTabBarsExample> {
  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart。
  /// 在 StatefulWidget 的 State 中声明 `final _weakValues = [0, 0, 0];`，
  /// 从 build 调用本方法；状态由 State 持有并通过 setState 重建。
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

  final _weakValues = [0, 0, 0];

  @override
  Widget build(BuildContext context) {
    return _weakTabBars(context);
  }
}
