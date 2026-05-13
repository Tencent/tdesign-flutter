---
title: Tabs 选项卡
description: 用于内容分类后的展示切换。
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

[td_tabs_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_tabs_page.dart)

### 1 组件类型

均分选项卡
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildItemWithSplit1(BuildContext context) {
    return TTabBar(
      tabs: subList(2),
      controller: _tabController1,
      showIndicator: true,
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildItemWithSplit2(BuildContext context) {
    return TTabBar(
      tabs: subList(3),
      controller: _tabController2,
      showIndicator: true,
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildItemWithSplit3(BuildContext context) {
    return TTabBar(
      tabs: subList(4),
      controller: _tabController3,
      showIndicator: true,
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildItemWithSplit4(BuildContext context) {
    return TTabBar(
      tabs: subList(5),
      controller: _tabController4,
      showIndicator: true,
    );
  }</pre>

</td-code-block>
                                  

等距选项卡
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildItemWithSpace(BuildContext context) {
    return TTabBar(
      tabs: subList(16),
      controller: TabController(length: 16, vsync: this),
      labelPadding: const EdgeInsets.all(10),
      showIndicator: true,
      isScrollable: true,
    );
  }</pre>

</td-code-block>
                                  

带图标选项卡
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildItemWithIcon(BuildContext context) {
    var tabs = List.generate(3, (index) {
      final text = '选项${index + 1}';
      return TTab(
        text: text,
        icon: const Icon(TIcons.app, size: 18),
      );
    });
    return TTabBar(
      tabs: tabs,
      controller: TabController(length: tabs.length, vsync: this),
      showIndicator: true,
    );
  }</pre>

</td-code-block>
                                  

带微标选项卡
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildItemWithLogo(BuildContext context) {
    var tabs = [
      const TTab(
        text: '选项',
        contentHeight: 48,
        textMargin: EdgeInsets.only(right: 8),
        badge: TBadge(TBadgeType.redPoint),
      ),
      const TTab(
        text: '选项',
        contentHeight: 42,
        textMargin: EdgeInsets.only(right: 16, top: 2, bottom: 2),
        badge: TBadge(TBadgeType.message, message: '8'),
      ),
      const TTab(
        text: '选项',
        height: 48,
        icon: Icon(TIcons.app, size: 18),
      ),
    ];
    return TTabBar(
      tabs: tabs,
      controller: TabController(length: tabs.length, vsync: this),
      showIndicator: true,
    );
  }</pre>

</td-code-block>
                                  

带内容区选项卡
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildItemWithContent(BuildContext context) {
    var tabController = TabController(length: 3, vsync: this);
    return SizedBox(
      height: 120 + 48,
      child: Column(
        children: [
          TTabBar(
            tabs: subList(3),
            controller: tabController,
            showIndicator: true,
            isScrollable: false,
          ),
          Container(
            height: 120,
            color: TTheme.of(context).bgColorContainer,
            child: TTabBarView(
              children: _getTabViews(),
              controller: tabController,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

带内容区选项卡（autoHeight 自适应高度）
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildItemWithAutoHeight(BuildContext context) {
    // 演示 issue #519 的修复：开启 autoHeight 后，外部无需再包 SizedBox
    // 显式设置高度，TTabBarView 会根据当前激活 tab 的子内容高度自适应，
    // 切换 tab 时高度会平滑过渡。
    var tabController = TabController(length: 3, vsync: this);
    // 三个子内容高度故意不同，用于观察外层容器的高度过渡效果
    final autoHeightTabViews = <Widget>[
      Container(
        height: 100,
        color: const Color(0xFFE3F0FF),
        alignment: Alignment.center,
        child: const TText('内容区 1（高度 100）'),
      ),
      Container(
        height: 200,
        color: const Color(0xFFE8F7E3),
        alignment: Alignment.center,
        child: const TText('内容区 2（高度 200）'),
      ),
      Container(
        height: 150,
        color: const Color(0xFFFFF5E0),
        alignment: Alignment.center,
        child: const TText('内容区 3（高度 150）'),
      ),
    ];
    return Column(
      children: [
        TTabBar(
          tabs: subList(3),
          controller: tabController,
          showIndicator: true,
          isScrollable: false,
        ),
        // 此处未给 TTabBarView 包 SizedBox、也未指定 height
        TTabBarView(
          autoHeight: true,
          controller: tabController,
          children: autoHeightTabViews,
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  
### 1 组件状态

选项卡状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildItemWithStatus(BuildContext context) {
    var tabs = [
      const TTab(text: '选中'),
      const TTab(text: '默认'),
      const TTab(text: '禁用', enable: false),
    ];
    return TTabBar(
      tabs: tabs,
      controller: TabController(length: tabs.length, vsync: this),
      showIndicator: true,
    );
  }</pre>

</td-code-block>
                                  
### 1 组件样式

选项卡尺寸
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildItemWithSizeSmall(BuildContext context) {
    var tabs = [
      const TTab(text: '小尺寸'),
      const TTab(text: '选项2'),
      const TTab(text: '选项3'),
      const TTab(text: '选项4'),
    ];
    return TTabBar(
      tabs: tabs,
      controller: TabController(length: tabs.length, vsync: this),
      showIndicator: true,
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildItemWithSizeBig(BuildContext context) {
    var tabs = [
      const TTab(text: '大尺寸', size: TTabSize.large),
      const TTab(text: '选项2', size: TTabSize.large),
      const TTab(text: '选项3', size: TTabSize.large),
      const TTab(text: '选项4', size: TTabSize.large),
    ];
    return TTabBar(
      tabs: tabs,
      controller: TabController(length: tabs.length, vsync: this),
      showIndicator: true,
    );
  }</pre>

</td-code-block>
                                  

选项卡样式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildItemWithOutlineNormal(BuildContext context) {
    var tabs = [
      const TTab(text: '选项1'),
      const TTab(text: '选项2'),
      const TTab(text: '选项3'),
      const TTab(text: '选项4'),
    ];
    return TTabBar(
      tabs: tabs,
      outlineType: TTabBarOutlineType.capsule,
      controller: TabController(length: tabs.length, vsync: this),
      showIndicator: false,
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildItemWithOutlineCard(BuildContext context) {
    var tabs = [
      const TTab(text: '选项1'),
      const TTab(text: '选项2'),
      const TTab(text: '选项3'),
      const TTab(text: '选项4'),
    ];
    return TTabBar(
      tabs: tabs,
      outlineType: TTabBarOutlineType.card,
      controller: TabController(length: tabs.length, vsync: this),
      showIndicator: false,
    );
  }</pre>

</td-code-block>
                                  


## API
### TTabBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | tabBar背景色，当outlineType为card时控制选中tab颜色 |
| controller | TabController? | - | tab控制器 |
| decoration | Decoration? | - | tabBar修饰 |
| dividerColor | Color? | - | 分割线颜色 |
| dividerHeight | double | 0.5 | 分割线高度,小于等于0则不展示分割线 |
| height | double? | - | tabBar高度 |
| indicator | Decoration? | - | 自定义引导控件 |
| indicatorColor | Color? | - | tabBar下标颜色 |
| indicatorHeight | double? | - | tabBar下标高度 |
| indicatorPadding | EdgeInsets? | - | 引导padding |
| indicatorWidth | double? | - | tabBar下标宽度 |
| isScrollable | bool | false | 是否滚动 |
| key |  | - |  |
| labelColor | Color? | - | tabBar 已选标签颜色 |
| labelPadding | EdgeInsetsGeometry? | - | tab间距 |
| labelStyle | TextStyle? | - | 已选label字体 |
| onTap |  Function(int)? | - | 点击事件 |
| outlineType | TTabBarOutlineType | TTabBarOutlineType.filled | 选项卡样式 |
| physics | ScrollPhysics? | - | 自定义滑动 |
| selectedBgColor | Color? | - | 被选中背景色，只有outlineType为capsule时有效 |
| showIndicator | bool | false | 是否展示引导控件 |
| tabAlignment |  | - |  |
| tabs | List<TTab> | - | tab数组 |
| unSelectedBgColor | Color? | - | 未选中背景色，只有outlineType为capsule时有效 |
| unselectedLabelColor | Color? | - | tabBar未选标签颜色 |
| unselectedLabelStyle | TextStyle? | - | unselectedLabel字体 |
| width | double? | - | tabBar宽度 |

```
```

### TTab
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | TBadge? | - | 图标 |
| child | Widget? | - | 子widget |
| contentHeight | double? | - | 中间内容高度 |
| enable | bool | true | 是否可用，默认true |
| height | double? | - | tab高度 |
| icon | Widget? | - | 图标 |
| iconMargin | EdgeInsetsGeometry | const EdgeInsets.only(bottom: 4.0, right: 4.0) | 图标间距 |
| key |  | - |  |
| outlineType | TTabOutlineType | TTabOutlineType.filled | 选项卡样式 |
| size | TTabSize | TTabSize.small | 选项卡尺寸 |
| text | String? | - | 文字内容 |
| textMargin | EdgeInsetsGeometry? | - | 中间内容宽度 |

```
```

### TTabBarView
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animationDuration | Duration | const Duration(milliseconds: 300) | 高度自适应模式下的过渡动画时长（默认 300ms） |
| autoHeight | bool | false | 是否开启高度自适应（默认 false，保持向后兼容） |
| children | List<Widget> | - | 子 widget 列表（每一项对应一个 tab 页的内容） |
| controller | TabController? | - | Tab 控制器，用于和外部 [TabBar] 联动 |
| isSlideSwitch | bool | false | 是否可以左右滑动切换 tab 页 |
| key |  | - |  |


  