import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

/// TSideBarUnSelectedColorPage 演示。
class TSideBarUnSelectedColorPage extends StatefulWidget {
  const TSideBarUnSelectedColorPage({super.key});

  @override
  State<TSideBarUnSelectedColorPage> createState() =>
      TSideBarUnSelectedColorPageState();
}

class TSideBarUnSelectedColorPageState
    extends State<TSideBarUnSelectedColorPage> {
  static const _items = [
    TSideBarItem(value: 0, label: '首页', icon: TIcons.app),
    TSideBarItem(
      value: 1,
      label: '消息',
      icon: TIcons.app,
      badge: TBadge(label: '3'),
    ),
    TSideBarItem(value: 2, label: '收藏', icon: TIcons.app),
    TSideBarItem(value: 3, label: '设置', icon: TIcons.app),
  ];

  var _currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'SideBar 自定义未选中颜色',
      exampleCodeGroup: 'sideBar',
      showSingleChild: true,
      singleChild: CodeWrapper(
        isCenter: false,
        builder: _buildUnselectedColorSideBar,
      ),
    );
  }

  @ExampleCode(group: 'sideBar')
  Widget _buildUnselectedColorSideBar(BuildContext context) {
    final label = _items[_currentValue].label;
    return Row(
      children: [
        SizedBox(
          width: 116,
          child: TSideBar(
            value: _currentValue,
            children: _items,
            selectedColor: context.tTheme.brandNormalColor,
            selectedBgColor: context.tTheme.brandLightColor,
            unSelectedColor: context.tTheme.textColorSecondary,
            unSelectedBgColor: context.tTheme.bgColorContainer,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
            onChanged: (value) => setState(() => _currentValue = value),
          ),
        ),
        Expanded(
          child: Container(
            color: context.tTheme.bgColorContainer,
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TText(label, font: context.tTheme.fontTitleMedium),
                const SizedBox(height: 4),
                TText(
                  '未选中项使用次级文字色，选中项保留品牌色。',
                  textColor: context.tTheme.textColorSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
