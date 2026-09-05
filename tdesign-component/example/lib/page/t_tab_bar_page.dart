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
    return const _DemoTabBar(type: TTabBarType.text);
  }

  @ExampleCode(group: 'tabBar')
  Widget _iconTextTabBar(BuildContext context) {
    return const _DemoTabBar(type: TTabBarType.iconText);
  }

  @ExampleCode(group: 'tabBar')
  Widget _iconTabBar(BuildContext context) {
    return const _DemoTabBar(type: TTabBarType.icon);
  }

  @ExampleCode(group: 'tabBar')
  Widget _doubleLayerTabBar(BuildContext context) {
    return const _DemoTabBar(type: TTabBarType.doubleLayer);
  }

  @ExampleCode(group: 'tabBar')
  Widget _weakTabBars(BuildContext context) {
    return const _DemoStack(
      children: [
        _DemoTabBar(
          type: TTabBarType.text,
          itemStyle: TTabBarItemStyle.normal,
          split: true,
          showBadges: true,
        ),
        _DemoTabBar(
          type: TTabBarType.icon,
          itemStyle: TTabBarItemStyle.normal,
          showBadges: true,
        ),
        _DemoTabBar(
          type: TTabBarType.iconText,
          itemStyle: TTabBarItemStyle.normal,
          showBadges: true,
        ),
      ],
    );
  }

  @ExampleCode(group: 'tabBar')
  Widget _capsuleTabBar(BuildContext context) {
    return const _DemoTabBar(
      type: TTabBarType.icon,
      style: TTabBarStyle.capsule,
    );
  }

  @ExampleCode(group: 'tabBar')
  Widget _customTabBar(BuildContext context) {
    return const _DemoTabBar(
      type: TTabBarType.icon,
      itemStyle: TTabBarItemStyle.normal,
      showTopBorder: false,
    );
  }
}

class _DemoStack extends StatelessWidget {
  const _DemoStack({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < children.length; index++) ...[
          children[index],
          if (index != children.length - 1) const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _DemoTabBar extends StatefulWidget {
  const _DemoTabBar({
    this.type = TTabBarType.iconText,
    this.itemStyle = TTabBarItemStyle.label,
    this.style = TTabBarStyle.filled,
    this.showBadges = false,
    this.split = false,
    this.showTopBorder = true,
  });

  final TTabBarType type;
  final TTabBarItemStyle itemStyle;
  final TTabBarStyle style;
  final bool showBadges;
  final bool split;
  final bool showTopBorder;

  @override
  State<_DemoTabBar> createState() => _DemoTabBarState();
}

class _DemoTabBarState extends State<_DemoTabBar> {
  var _value = 0;

  @override
  Widget build(BuildContext context) {
    return TTabBar(
      type: widget.type,
      itemStyle: widget.itemStyle,
      style: widget.style,
      split: widget.split,
      showTopBorder: widget.showTopBorder,
      useSafeArea: false,
      value: _value,
      onChanged: (value) {
        setState(() => _value = value);
        TToast.showText('点击了 Item ${value + 1}', context: context);
      },
      navigationTabs: List.generate(4, _item),
    );
  }

  TTabBarItemConfig _item(int index) {
    final hasText = widget.type != TTabBarType.icon;
    final hasIcon =
        widget.type == TTabBarType.icon || widget.type == TTabBarType.iconText;
    return TTabBarItemConfig(
      tabText: hasText ? const ['首页', '应用', '聊天', '我的'][index] : null,
      selectedIcon: hasIcon ? Icon(_icons[index], size: 20) : null,
      unselectedIcon: hasIcon ? Icon(_icons[index], size: 20) : null,
      badgeConfig: widget.showBadges
          ? TTabBarBadgeConfig(showBadge: true, tBadge: _badges[index])
          : null,
      popUpButtonConfig: widget.type == TTabBarType.doubleLayer && index == 3
          ? TTabBarPopUpBtnConfig(
              items: const [
                TTabBarMenuItem(value: '展开项一'),
                TTabBarMenuItem(value: '展开项二'),
                TTabBarMenuItem(value: '展开项三'),
              ],
              onChanged: (_) {},
            )
          : null,
    );
  }

  static const _icons = [TIcons.home, TIcons.app, TIcons.chat, TIcons.user];

  static const _badges = [
    TBadge(label: '16'),
    TBadge(variant: TBadgeVariant.dot),
    TBadge(label: 'New'),
    TBadge(label: '···'),
  ];
}
