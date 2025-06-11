---
title: SideBar 侧边栏
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

[td_sidebar_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/sidebar/td_sidebar_page.dart)

[td_sidebar_page_anchor.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/sidebar/td_sidebar_page_anchor.dart)

[td_sidebar_page_custom.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/sidebar/td_sidebar_page_custom.dart)

[td_sidebar_page_icon.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/sidebar/td_sidebar_page_icon.dart)

[td_sidebar_page_pagination.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/sidebar/td_sidebar_page_pagination.dart)

### 1 组件类型

侧边导航用法

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildAnchorSideBar(BuildContext context) {
    // 锚点用法
    final list = <SideItemProps>[];
    final pages = <Widget>[];

    for (var i = 0; i < 20; i++) {
      list.add(SideItemProps(
        index: i,
        label: '选项',
        value: i,
      ));
      pages.add(getAnchorDemo(i));
    }

    pages.add(Container(
      height: MediaQuery.of(context).size.height - itemHeight,
      decoration: const BoxDecoration(color: Colors.white),
    ));

    list[1].badge = const TDBadge(TDBadgeType.redPoint);
    list[2].badge = const TDBadge(
      TDBadgeType.message,
      count: '8',
    );

    var demoHeight = MediaQuery.of(context).size.height;
    _sideBarController.init(list);

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: TDSideBar(
            height: demoHeight,
            style: TDSideBarStyle.normal,
            value: currentValue,
            controller: _sideBarController,
            children: list
                .map((ele) => TDSideBarItem(
                    label: ele.label ?? '',
                    badge: ele.badge,
                    value: ele.value,
                    icon: ele.icon))
                .toList(),
            onChanged: onChanged,
            onSelected: onSelected,
          ),
        ),
        Expanded(
            child: SizedBox(
          height: demoHeight,
          child: SingleChildScrollView(
            controller: _demoScroller,
            child: Column(
              children: pages,
            ),
          ),
        ))
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPaginationSideBar(BuildContext context) {
    // 切页用法
    final list = <SideItemProps>[];
    final pages = <Widget>[];

    for (var i = 0; i < 100; i++) {
      list.add(SideItemProps(
        index: i,
        label: '选项',
        value: i,
      ));
      pages.add(getPageDemo(i));
    }

    list[1].badge = const TDBadge(TDBadgeType.redPoint);
    list[2].badge = const TDBadge(
      TDBadgeType.message,
      count: '8',
    );

    void setCurrentValue(int value) {
      _pageController.jumpToPage(value);
      if (currentValue != value) {
        currentValue = value;
      }
    }

    var demoHeight = MediaQuery.of(context).size.height;

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: TDSideBar(
            height: demoHeight,
            style: TDSideBarStyle.normal,
            value: currentValue,
            controller: _sideBarController,
            children: list
                .map((ele) => TDSideBarItem(
                    label: ele.label ?? '',
                    badge: ele.badge,
                    value: ele.value,
                    icon: ele.icon))
                .toList(),
            onSelected: setCurrentValue,
          ),
        ),
        Expanded(
            child: SizedBox(
          height: demoHeight,
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: pages,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ))
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildAnchorSideBar(BuildContext context) {
    // 锚点用法
    final list = <SideItemProps>[];
    final pages = <Widget>[];

    for (var i = 0; i < 20; i++) {
      list.add(SideItemProps(
        index: i,
        label: '选项',
        value: i,
      ));
      pages.add(getAnchorDemo(i));
    }

    pages.add(Container(
      height: MediaQuery.of(context).size.height - itemHeight,
      decoration: const BoxDecoration(color: Colors.white),
    ));

    list[1].badge = const TDBadge(TDBadgeType.redPoint);
    list[2].badge = const TDBadge(
      TDBadgeType.message,
      count: '8',
    );

    var demoHeight = MediaQuery.of(context).size.height;
    _sideBarController.init(list);

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: TDSideBar(
            height: demoHeight,
            style: TDSideBarStyle.normal,
            value: currentValue,
            controller: _sideBarController,
            children: list
                .map((ele) => TDSideBarItem(
                    label: ele.label ?? '',
                    badge: ele.badge,
                    value: ele.value,
                    icon: ele.icon))
                .toList(),
            onChanged: onChanged,
            onSelected: onSelected,
          ),
        ),
        Expanded(
            child: SizedBox(
          height: demoHeight,
          child: SingleChildScrollView(
            controller: _demoScroller,
            child: Column(
              children: pages,
            ),
          ),
        ))
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPaginationSideBar(BuildContext context) {
    // 切页用法
    final list = <SideItemProps>[];
    final pages = <Widget>[];

    for (var i = 0; i < 100; i++) {
      list.add(SideItemProps(
        index: i,
        label: '选项',
        value: i,
      ));
      pages.add(getPageDemo(i));
    }

    list[1].badge = const TDBadge(TDBadgeType.redPoint);
    list[2].badge = const TDBadge(
      TDBadgeType.message,
      count: '8',
    );

    void setCurrentValue(int value) {
      _pageController.jumpToPage(value);
      if (currentValue != value) {
        currentValue = value;
      }
    }

    var demoHeight = MediaQuery.of(context).size.height;

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: TDSideBar(
            height: demoHeight,
            style: TDSideBarStyle.normal,
            value: currentValue,
            controller: _sideBarController,
            children: list
                .map((ele) => TDSideBarItem(
                    label: ele.label ?? '',
                    badge: ele.badge,
                    value: ele.value,
                    icon: ele.icon))
                .toList(),
            onSelected: setCurrentValue,
          ),
        ),
        Expanded(
            child: SizedBox(
          height: demoHeight,
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: pages,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ))
      ],
    );
  }</pre>

</td-code-block>
                

图标侧边导航
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildIconSideBar(BuildContext context) {
    final list = <SideItemProps>[];
    final pages = <Widget>[];

    for (var i = 0; i < 20; i++) {
      list.add(
          SideItemProps(index: i, label: '选项', value: i, icon: TDIcons.app));
      pages.add(getAnchorDemo(i));
    }

    pages.add(Container(
      height: MediaQuery.of(context).size.height - itemHeight,
      decoration: const BoxDecoration(color: Colors.white),
    ));

    list[1].badge = const TDBadge(TDBadgeType.redPoint);
    list[2].badge = const TDBadge(
      TDBadgeType.message,
      count: '8',
    );

    var demoHeight = MediaQuery.of(context).size.height;

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: TDSideBar(
            height: demoHeight,
            style: TDSideBarStyle.normal,
            value: currentValue,
            controller: _sideBarController,
            children: list
                .map((ele) => TDSideBarItem(
                    label: ele.label ?? '',
                    badge: ele.badge,
                    value: ele.value,
                    icon: ele.icon))
                .toList(),
            onChanged: onChanged,
            onSelected: onSelected,
          ),
        ),
        Expanded(
            child: SizedBox(
          height: demoHeight,
          child: SingleChildScrollView(
            controller: _demoScroller,
            child: Column(
              children: pages,
            ),
          ),
        ))
      ],
    );
  }</pre>

</td-code-block>
                                  
### 1 组件样式

侧边导航样式

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildOutlineSideBar(BuildContext context) {
    // 非通栏选项样式
    final list = <SideItemProps>[];
    final pages = <Widget>[];

    for (var i = 0; i < 20; i++) {
      list.add(SideItemProps(
        index: i,
        label: '选项',
        value: i,
      ));
      pages.add(getAnchorDemo(i));
    }

    pages.add(Container(
      height: MediaQuery.of(context).size.height - itemHeight,
      decoration: const BoxDecoration(color: Colors.white),
    ));

    list[1].badge = const TDBadge(TDBadgeType.redPoint);
    list[2].badge = const TDBadge(
      TDBadgeType.message,
      count: '8',
    );

    var demoHeight = MediaQuery.of(context).size.height;

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: TDSideBar(
            height: demoHeight,
            style: TDSideBarStyle.outline,
            value: currentValue,
            controller: _sideBarController,
            children: list
                .map((ele) => TDSideBarItem(
                    label: ele.label ?? '',
                    badge: ele.badge,
                    value: ele.value,
                    icon: ele.icon))
                .toList(),
            onChanged: onChanged,
            onSelected: onSelected,
          ),
        ),
        Expanded(
            child: SizedBox(
          height: demoHeight,
          child: SingleChildScrollView(
            controller: _demoScroller,
            child: Column(
              children: pages,
            ),
          ),
        ))
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomSideBar(BuildContext context) {
    // 自定义样式
    final list = <SideItemProps>[];
    final pages = <Widget>[];

    for (var i = 0; i < 100; i++) {
      list.add(SideItemProps(
        index: i,
        label: '选项',
        value: i,
      ));
      pages.add(getPageDemo(i));
    }

    list[1].badge = const TDBadge(TDBadgeType.redPoint);
    list[2].badge = const TDBadge(
      TDBadgeType.message,
      count: '8',
    );
    list[1].textStyle = const TextStyle(color: Colors.green);

    void setCurrentValue(int value) {
      _pageController.jumpToPage(value);
      if (currentValue != value) {
        currentValue = value;
      }
    }

    var demoHeight = MediaQuery.of(context).size.height;

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: TDSideBar(
            height: demoHeight,
            style: TDSideBarStyle.normal,
            value: currentValue,
            controller: _sideBarController,
            children: list
                .map((ele) => TDSideBarItem(
                    label: ele.label ?? '',
                    badge: ele.badge,
                    value: ele.value,
                    textStyle: ele.textStyle,
                    icon: ele.icon))
                .toList(),
            selectedTextStyle:TextStyle(color: Colors.red),
            onSelected: setCurrentValue,
            contentPadding:EdgeInsets.only(left: 16, top: 16,bottom: 16),
            selectedBgColor: Colors.blue,
            unSelectedBgColor: Colors.yellow,
          ),
        ),
        Expanded(
            child: SizedBox(
          height: demoHeight,
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: pages,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ))
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildOutlineSideBar(BuildContext context) {
    // 非通栏选项样式
    final list = <SideItemProps>[];
    final pages = <Widget>[];

    for (var i = 0; i < 20; i++) {
      list.add(SideItemProps(
        index: i,
        label: '选项',
        value: i,
      ));
      pages.add(getAnchorDemo(i));
    }

    pages.add(Container(
      height: MediaQuery.of(context).size.height - itemHeight,
      decoration: const BoxDecoration(color: Colors.white),
    ));

    list[1].badge = const TDBadge(TDBadgeType.redPoint);
    list[2].badge = const TDBadge(
      TDBadgeType.message,
      count: '8',
    );

    var demoHeight = MediaQuery.of(context).size.height;

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: TDSideBar(
            height: demoHeight,
            style: TDSideBarStyle.outline,
            value: currentValue,
            controller: _sideBarController,
            children: list
                .map((ele) => TDSideBarItem(
                    label: ele.label ?? '',
                    badge: ele.badge,
                    value: ele.value,
                    icon: ele.icon))
                .toList(),
            onChanged: onChanged,
            onSelected: onSelected,
          ),
        ),
        Expanded(
            child: SizedBox(
          height: demoHeight,
          child: SingleChildScrollView(
            controller: _demoScroller,
            child: Column(
              children: pages,
            ),
          ),
        ))
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomSideBar(BuildContext context) {
    // 自定义样式
    final list = <SideItemProps>[];
    final pages = <Widget>[];

    for (var i = 0; i < 100; i++) {
      list.add(SideItemProps(
        index: i,
        label: '选项',
        value: i,
      ));
      pages.add(getPageDemo(i));
    }

    list[1].badge = const TDBadge(TDBadgeType.redPoint);
    list[2].badge = const TDBadge(
      TDBadgeType.message,
      count: '8',
    );
    list[1].textStyle = const TextStyle(color: Colors.green);

    void setCurrentValue(int value) {
      _pageController.jumpToPage(value);
      if (currentValue != value) {
        currentValue = value;
      }
    }

    var demoHeight = MediaQuery.of(context).size.height;

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: TDSideBar(
            height: demoHeight,
            style: TDSideBarStyle.normal,
            value: currentValue,
            controller: _sideBarController,
            children: list
                .map((ele) => TDSideBarItem(
                    label: ele.label ?? '',
                    badge: ele.badge,
                    value: ele.value,
                    textStyle: ele.textStyle,
                    icon: ele.icon))
                .toList(),
            selectedTextStyle:TextStyle(color: Colors.red),
            onSelected: setCurrentValue,
            contentPadding:EdgeInsets.only(left: 16, top: 16,bottom: 16),
            selectedBgColor: Colors.blue,
            unSelectedBgColor: Colors.yellow,
          ),
        ),
        Expanded(
            child: SizedBox(
          height: demoHeight,
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: pages,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ))
      ],
    );
  }</pre>

</td-code-block>
                


## API
### TDSideBarItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| badge | TDBadge? | - | 徽标 |
| disabled | bool | false | 是否禁用 |
| icon | IconData? | - | 图标 |
| textStyle | TextStyle? | - | 标签样式 |
| label | String | '' | 标签 |
| value | int | -1 | 值 |

```
```
 ### TDSideBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| value | int? | - | 选项值 |
| defaultValue | int? | - | 默认值 |
| selectedColor | Color? | - | 选中值后颜色 |
| children | List<TDSideBarItem> | const [] | 单项 |
| onChanged | ValueChanged<int>? | - | 选中值发生变化（Controller控制） |
| onSelected | ValueChanged<int>? | - | 选中值发生变化（点击事件） |
| height | double? | - | 高度 |
| controller | TDSideBarController? | - | 控制器 |
| contentPadding | EdgeInsetsGeometry? | - | 自定义文本框内边距 |
| selectedTextStyle | TextStyle? | - | 选中样式 |
| style | TDSideBarStyle | TDSideBarStyle.normal | 样式 |
| loading | bool? | - | 加载效果 |
| loadingWidget | Widget? | - | 自定义加载动画 |
| selectedBgColor | Color? | - | 选择的背景颜色 |
| unSelectedBgColor | Color? | - | 未选择的背景颜色 |


  