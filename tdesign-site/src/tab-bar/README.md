---
title: TabBar 标签栏
description: 用于在不同功能模块之间进行快速切换，位于页面底部。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

### 1 组件类型

纯文本标签栏

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                



          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                



          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                



          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

图标加文本标签栏

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar(BuildContext context) {

    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                



          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                



          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                



          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

纯图标标签栏

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(
              selectedIcon: _selectedIcon,
              unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              })
        ]);
  }</pre>

</td-code-block>
                



          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                



          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                



          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig(tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTextTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomTabBarTabConfig( tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar3tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar4tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _iconTypeTabBar5tabs(BuildContext context) {
    return TDBottomTabBar(TDBottomTabBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }</pre>

</td-code-block>
                

双层级文本标签栏
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _expansionPannelTypeTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.expansionPanel,
      useVerticalDivider: true,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
            tabText: '展开项',
            onTap: () {
              onTapTab(context, '展开项');
            },
            popUpButtonConfig: TDBottomTabBarPopUpBtnConfig(
                popUpDialogConfig: TDBottomTabBarPopUpShapeConfig(
                  radius: 10,
                  arrowWidth: 16,
                  arrowHeight: 8,
                ),
                items: [
                  '展开项一',
                  '展开项二',
                  '展开项三',
                ]
                    .reversed
                    .map((e) => PopUpMenuItem(
                          value: e,
                          itemWidget: SizedBox(
                            //height: 30,
                            child: Text(
                              e,
                              style: TextStyle(
                                  color: TDTheme.of(context).fontGyColor1,
                                  fontSize: 16),
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (v) {
                  TDToast.showText('点击了 $v', context: context);
                })),
      ],
    );
  }</pre>

</td-code-block>
                                  
### 1 组件样式

弱选中标签栏

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _weakSelectTextTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.text,
      componentType: TDBottomTabBarComponentType.normal,
      useVerticalDivider: true,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          badgeConfig: BadgeConfig(
            showBage: true,
            tdBadge: const TDBadge(TDBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _weakSelectTextTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.text,
      componentType: TDBottomTabBarComponentType.normal,
      useVerticalDivider: true,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          badgeConfig: BadgeConfig(
            showBage: true,
            tdBadge: const TDBadge(TDBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }</pre>

</td-code-block>
                



          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _weakSelectIconTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.icon,
      componentType: TDBottomTabBarComponentType.normal,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
          badgeConfig: BadgeConfig(
            showBage: true,
            tdBadge: const TDBadge(TDBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _weakSelectIconTextTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.iconText,
      componentType: TDBottomTabBarComponentType.normal,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          badgeConfig: BadgeConfig(
            showBage: true,
            tdBadge: const TDBadge(TDBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _weakSelectIconTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.icon,
      componentType: TDBottomTabBarComponentType.normal,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
          badgeConfig: BadgeConfig(
            showBage: true,
            tdBadge: const TDBadge(TDBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _weakSelectIconTextTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.iconText,
      componentType: TDBottomTabBarComponentType.normal,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          badgeConfig: BadgeConfig(
            showBage: true,
            tdBadge: const TDBadge(TDBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }</pre>

</td-code-block>
                



          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _weakSelectIconTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.icon,
      componentType: TDBottomTabBarComponentType.normal,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
          badgeConfig: BadgeConfig(
            showBage: true,
            tdBadge: const TDBadge(TDBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _weakSelectIconTextTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.iconText,
      componentType: TDBottomTabBarComponentType.normal,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          badgeConfig: BadgeConfig(
            showBage: true,
            tdBadge: const TDBadge(TDBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _weakSelectIconTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.icon,
      componentType: TDBottomTabBarComponentType.normal,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
          badgeConfig: BadgeConfig(
            showBage: true,
            tdBadge: const TDBadge(TDBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(

            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _weakSelectIconTextTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.iconText,
      componentType: TDBottomTabBarComponentType.normal,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          badgeConfig: BadgeConfig(
            showBage: true,
            tdBadge: const TDBadge(TDBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }</pre>

</td-code-block>
                

悬浮胶囊标签栏
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _capsuleTabBar(BuildContext context) {
    return TDBottomTabBar(
      TDBottomTabBarBasicType.iconText,
      componentType: TDBottomTabBarComponentType.label,
      outlineType: TDBottomTabBarOutlineType.capsule,
      useVerticalDivider: true,
      navigationTabs: [
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomTabBarTabConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  


## API
### BadgeConfig
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| showBage | bool | - | 是否展示消息 |
| tdBadge | TDBadge? | - | 消息样式(未设置但showBage为true，则默认使用红点) |
| badgeTopOffset | double? | - | 消息顶部偏移量 |
| badgeRightOffset | double? | - | 消息右侧偏移量 |

```
```
 ### TDBottomTabBarTabConfig
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| onTap | GestureTapCallback? | - | tab点击事件 |
| selectedIcon | Widget? | - | 选中时图标 |
| unselectedIcon | Widget? | - | 未选中时图标 |
| tabText | String? | - | tab文本 |
| selectTabTextStyle | TextStyle? | - | 文本已选择样式 basicType为text时必填 |
| unselectTabTextStyle | TextStyle? | - | 文本未选择样式 basicType为text时必填 |
| badgeConfig | BadgeConfig? | - | 消息配置 |
| popUpButtonConfig | TDBottomTabBarPopUpBtnConfig? | - | 弹窗配置 |

```
```
 ### TDBottomTabBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| basicType | TDBottomTabBarBasicType | basicType | 基本样式（纯文本、纯图标、图标+文本） |
| key |  | - |  |
| componentType | TDBottomTabBarComponentType? | TDBottomTabBarComponentType.label | 选项样式 默认label |
| outlineType | TDBottomTabBarOutlineType? | TDBottomTabBarOutlineType.filled | 标签栏样式 默认filled |
| navigationTabs | List<TDBottomTabBarTabConfig> | - | tabs配置 |
| barHeight | double? | _kDefaultTabBarHeight | tab高度 |
| useVerticalDivider | bool? | - | 是否使用竖线分隔(如果选项样式为label则强制为false) |
| dividerHeight | double? | - | 分割线高度（可选） |
| dividerThickness | double? | - | 分割线厚度（可选） |
| dividerColor | Color? | - | 分割线颜色（可选） |
| showTopBorder | bool? | true | 是否展示bar上边线（设置为true 但是topBorder样式未设置，则使用默认值,非胶囊型才生效） |
| topBorder | BorderSide? | - | 上边线样式 |
| useSafeArea | bool | true | 使用安全区域 |
| selectedBgColor | Color? | - | 选中时背景颜色 |
| unselectedBgColor | Color? | - | 未选中时背景颜色 |

```
```
 ### TDBottomTabBarPopUpBtnConfig
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| items | List<PopUpMenuItem> | - | 选项list |
| onChanged | ValueChanged<String> | - | 统一在 onChanged 中处理各item点击事件 |
| popUpDialogConfig | TDBottomTabBarPopUpShapeConfig? | - | 弹窗UI配置 |

```
```
 ### TDBottomTabBarPopUpShapeConfig
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| popUpWidth | double? | - | 弹窗宽度（不设置，默认为按钮宽度 - 20） |
| popUpitemHeight | double? | _kDefaultMenuItemHeight | 单个选项高度 所有选项等高 不设置则使用默认值 48 |
| backgroundColor | Color? | - | 弹窗背景颜色 |
| radius | double? | - | pannel圆角 默认0 |
| arrowWidth | double? | - | 箭头宽度 默认13.5 |
| arrowHeight | double? | - | 箭头高度 默认8 |

```
```
 ### PopUpMenuItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| itemWidget | Widget? | - | 选项widget |
| value | String | - | 选项值 |
| alignment | AlignmentGeometry | AlignmentDirectional.center | 对齐方式 |


  