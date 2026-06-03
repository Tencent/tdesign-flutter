---
title: Drawer 抽屉
description: 用作一组平行关系页面/内容的切换器，相较于Tab，同屏可展示更多的选项数量。
spline: navigation
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在 `tdesign_flutter/tdesign_flutter.dart` 中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```


## 代码演示

[td_drawer_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_drawer_page.dart)

### 1 组件类型

基础抽屉

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildBaseSimple(BuildContext context) {
  /// 获取navBar尺寸
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return TButton(
    text: '基础抽屉',
    isBlock: true,
    type: TButtonType.outline,
    theme: TButtonTheme.primary,
    size: TButtonSize.large,
    onTap: () {
      TDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        items: List.generate(
            drawerItemLength, (index) => TDrawerItem(title: '菜单${index + 1}')),
        onItemClick: (index, item) {
          print('drawer item被点击，index：$index，title：${item.title}');
        },
      );
    },
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildBaseSimple(BuildContext context) {
  /// 获取navBar尺寸
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return TButton(
    text: '基础抽屉',
    isBlock: true,
    type: TButtonType.outline,
    theme: TButtonTheme.primary,
    size: TButtonSize.large,
    onTap: () {
      TDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        items: List.generate(
            drawerItemLength, (index) => TDrawerItem(title: '菜单${index + 1}')),
        onItemClick: (index, item) {
          print('drawer item被点击，index：$index，title：${item.title}');
        },
      );
    },
  );
}</pre>

</td-code-block>
                

带图标抽屉

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildIconSimple(BuildContext context) {
  /// 获取navBar尺寸
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return TButton(
    text: '带图标抽屉',
    isBlock: true,
    type: TButtonType.outline,
    theme: TButtonTheme.primary,
    size: TButtonSize.large,
    onTap: () {
      TDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        items: List.generate(
            drawerItemLength,
            (index) => TDrawerItem(
                title: '菜单${index + 1}', icon: const Icon(TIcons.app))),
      );
    },
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildIconSimple(BuildContext context) {
  /// 获取navBar尺寸
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return TButton(
    text: '带图标抽屉',
    isBlock: true,
    type: TButtonType.outline,
    theme: TButtonTheme.primary,
    size: TButtonSize.large,
    onTap: () {
      TDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        items: List.generate(
            drawerItemLength,
            (index) => TDrawerItem(
                title: '菜单${index + 1}', icon: const Icon(TIcons.app))),
      );
    },
  );
}</pre>

</td-code-block>
                
### 1 组件样式

带标题抽屉

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildTitleSimple(BuildContext context) {
  /// 获取navBar尺寸
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return TButton(
    text: '带图标抽屉',
    isBlock: true,
    type: TButtonType.outline,
    theme: TButtonTheme.primary,
    size: TButtonSize.large,
    onTap: () {
      TDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        title: '标题',
        placement: TDrawerPlacement.left,
        items: List.generate(
            drawerItemLength, (index) => TDrawerItem(title: '菜单${index + 1}')),
      );
    },
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildTitleSimple(BuildContext context) {
  /// 获取navBar尺寸
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return TButton(
    text: '带图标抽屉',
    isBlock: true,
    type: TButtonType.outline,
    theme: TButtonTheme.primary,
    size: TButtonSize.large,
    onTap: () {
      TDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        title: '标题',
        placement: TDrawerPlacement.left,
        items: List.generate(
            drawerItemLength, (index) => TDrawerItem(title: '菜单${index + 1}')),
      );
    },
  );
}</pre>

</td-code-block>
                

带底部插槽样式

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildBottomSimple(BuildContext context) {
  /// 获取navBar尺寸
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return TButton(
    text: '带底部插槽样式',
    isBlock: true,
    type: TButtonType.outline,
    theme: TButtonTheme.primary,
    size: TButtonSize.large,
    onTap: () {
      TDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        title: '标题',
        placement: TDrawerPlacement.left,
        items: List.generate(
            drawerItemLength, (index) => TDrawerItem(title: '菜单${index + 1}')),
        footer: const TButton(
          text: '操作',
          type: TButtonType.outline,
          width: double.infinity,
          size: TButtonSize.large,
        ),
      );
    },
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildBottomSimple(BuildContext context) {
  /// 获取navBar尺寸
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return TButton(
    text: '带底部插槽样式',
    isBlock: true,
    type: TButtonType.outline,
    theme: TButtonTheme.primary,
    size: TButtonSize.large,
    onTap: () {
      TDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        title: '标题',
        placement: TDrawerPlacement.left,
        items: List.generate(
            drawerItemLength, (index) => TDrawerItem(title: '菜单${index + 1}')),
        footer: const TButton(
          text: '操作',
          type: TButtonType.outline,
          width: double.infinity,
          size: TButtonSize.large,
        ),
      );
    },
  );
}</pre>

</td-code-block>
                


## API
### TDrawer
#### 简介
抽屉组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |
| backgroundColor | Color? | - | 组件背景颜色 |
| bordered | bool? | true | 是否显示边框 |
| closeOnOverlayClick | bool? | true | 点击蒙层时是否关闭抽屉 |
| contentWidget | Widget? | - | 自定义内容，优先级高于`items`/`footer`/`title` |
| drawerTop | double? | - | 距离顶部的距离 |
| footer | Widget? | - | 抽屉的底部 |
| hover | bool? | true | 是否开启点击反馈 |
| isShowLastBordered | bool? | true | 是否显示最后一行分割线 |
| items | List<TDrawerItem>? | - | 抽屉里的列表项 |
| onClose | VoidCallback? | - | 关闭时触发 |
| onItemClick | TDrawerItemClickCallback? | - | 点击抽屉里的列表项触发 |
| placement | TDrawerPlacement? | TDrawerPlacement.right | 抽屉方向 |
| showOverlay | bool? | true | 是否显示遮罩层 |
| style | TCellStyle? | - | 列表自定义样式 |
| title | String? | - | 抽屉的标题 |
| titleWidget | Widget? | - | 抽屉的标题组件 |
| visible | bool? | - | 组件是否可见 |
| width | double? | 280 | 宽度 |


### TDrawerWidget
#### 简介
抽屉内容组件
可用于 Scaffold 中的 drawer 属性
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 组件背景颜色 |
| bordered | bool? | true | 是否显示边框 |
| contentWidget | Widget? | - | 自定义内容，优先级高于`items`/`footer`/`title` |
| footer | Widget? | - | 抽屉的底部 |
| hover | bool? | true | 是否开启点击反馈 |
| isShowLastBordered | bool? | true | 是否显示最后一行分割线 |
| items | List<TDrawerItem>? | - | 抽屉里的列表项 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onItemClick | TDrawerItemClickCallback? | - | 点击抽屉里的列表项触发 |
| style | TCellStyle? | - | 列表自定义样式 |
| title | String? | - | 抽屉的标题 |
| titleWidget | Widget? | - | 抽屉的标题组件 |
| width | double? | 280 | 宽度 |


### TDrawerItem
#### 简介
抽屉里的列表项
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | Widget? | - | 完全自定义 |
| icon | Widget? | - | 每列图标 |
| title | String? | - | 每列标题 |


### TDrawerPlacement
#### 简介
抽屉方向
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | - |
| right | - |


### TDrawerItemClickCallback
#### 类型定义

```dart
typedef TDrawerItemClickCallback = void Function(int index, TDrawerItem item);
```


  