import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tabBar')
class CustomTabBarExample extends StatefulWidget {
  const CustomTabBarExample({super.key});

  @override
  State<CustomTabBarExample> createState() => _CustomTabBarExampleState();
}

class _CustomTabBarExampleState extends State<CustomTabBarExample> {
  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart。
  /// 在 StatefulWidget 的 State 中声明 `int _customValue = 0;`，
  /// 从 build 调用本方法；状态由 State 持有并通过 setState 重建。
  Widget _customTabBar(BuildContext context) {
    const icons = [TIcons.home, TIcons.app, TIcons.chat, TIcons.user];
    return TTabBar(
      type: TTabBarType.icon,
      itemStyle: TTabBarItemStyle.normal,
      useSafeArea: false,
      value: _customValue,
      onChanged: (newValue) => setState(() => _customValue = newValue),
      navigationTabs: List.generate(
        4,
        (index) => TTabBarItemConfig(
          selectedIcon: Icon(icons[index]),
          unselectedIcon: Icon(icons[index]),
          allowMultipleTaps: true,
          onTap: () => TToast.showText('第 ${index + 1} 项', context: context),
        ),
      ),
    );
  }

  int _customValue = 0;

  @override
  Widget build(BuildContext context) {
    return _customTabBar(context);
  }
}
