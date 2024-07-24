---
title: NavBar 导航栏
description: 用于不同页面之间切换或者跳转，位于内容区的上方，系统状态栏的下方。
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

[td_navbar_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_navbar_page.dart)

### 1 组件类型

基础H5导航栏
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _baseH5Navbar(BuildContext context) {
    return const TDNavBar(
        height: 48,
        titleFontWeight: FontWeight.w600,
        title: titleText,
        screenAdaptation: false,
        useDefaultBack: true,
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _leftMultiAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TDNavBar(
          height: 48,
          title: titleText,
          titleFontWeight: FontWeight.w600,
          screenAdaptation: false,
          useDefaultBack: true,
          leftBarItems: [
            TDNavBarItem(icon: TDIcons.close, iconSize: 24),
          ],
          rightBarItems: [
            TDNavBarItem(icon: TDIcons.ellipsis, iconSize: 24)
          ]
      ),
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _rightMultiAction(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: TDNavBar(
            height: 48,
            title: titleText,
            titleFontWeight: FontWeight.w600,
            screenAdaptation: false,
            useDefaultBack: true,
            rightBarItems: [
              TDNavBarItem(icon: TDIcons.home, iconSize: 24, ),
              TDNavBarItem(icon: TDIcons.ellipsis, iconSize: 24,)
            ]
        ),
    );
  }</pre>

</td-code-block>
                                  

带搜索导航栏
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _searchNavbar(BuildContext context){
    return TDNavBar(
      useDefaultBack: false,
      screenAdaptation: false,
      centerTitle: false,
      titleMargin: 0,
      titleWidget:  TDSearchBar(
        needCancel: false,
        autoHeight: true,
        padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
        placeHolder: '搜索预设文案',
        mediumStyle: true,
        style: TDSearchStyle.round,
        onTextChanged: (String text) {
          print('input：$text');
        },
      ),
      rightBarItems: [
        TDNavBarItem(icon: TDIcons.home,iconSize: 24),
        TDNavBarItem(icon: TDIcons.ellipsis,iconSize: 24)
      ]
    );
  }</pre>

</td-code-block>
                                  

带图片导航栏
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _logoNavbar(BuildContext context){
    return TDNavBar(
        useDefaultBack: false,
        screenAdaptation: false,
        centerTitle: false,
        titleMargin: 0,
        titleWidget:  const TDImage(
          assetUrl: 'assets/img/td_brand.png',
          width: 102,
          height: 24,
        ),
        rightBarItems: [
          TDNavBarItem(icon: TDIcons.home,iconSize: 24),
          TDNavBarItem(icon: TDIcons.ellipsis,iconSize: 24)
        ]
    );
  }</pre>

</td-code-block>
                                  
### 1 组件样式

标题对齐
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _titleCenterNavbar(BuildContext context) {
    return TDNavBar(
        height: 48,
        title: titleText,
        titleFontWeight: FontWeight.w600,
        screenAdaptation: false,
        useDefaultBack: true,
        rightBarItems: [
          TDNavBarItem(icon: TDIcons.home,iconSize: 24),
          TDNavBarItem(icon: TDIcons.ellipsis,iconSize: 24)
        ]
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _titleLeftNavbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TDNavBar(
          height: 48,
          title: titleText,
          titleFontWeight: FontWeight.w600,
          centerTitle: false,
          titleMargin: 0,
          screenAdaptation: false,
          useDefaultBack: true,
          rightBarItems: [
            TDNavBarItem(icon: TDIcons.home,iconSize: 24),
            TDNavBarItem(icon: TDIcons.ellipsis,iconSize: 24)
          ]
      ),
    );
  }</pre>

</td-code-block>
                                  

标题尺寸
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _titleNormalNavbar(BuildContext context) {
    return TDNavBar(
        height: 48,
        title: titleText,
        titleFontWeight: FontWeight.w600,
        screenAdaptation: false,
        useDefaultBack: true,
        rightBarItems: [
          TDNavBarItem(icon: TDIcons.home,iconSize: 24),
          TDNavBarItem(icon: TDIcons.ellipsis,iconSize: 24)
        ]
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _titleBelowNavbar(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: TDNavBar(
          height: 104,
          title: '返回',
          titleColor: const Color.fromRGBO(0, 0, 0, 0.9),
          belowTitleWidget: SizedBox(
            height: 56,
            child: TDText(titleText, font: Font(size: 28, lineHeight: 52), fontWeight: FontWeight.w600,),
          ),
          titleFont: Font(size: 16, lineHeight: 24),
          centerTitle: false,
          titleMargin: 0,
          screenAdaptation: false,
          useDefaultBack: false,
          leftBarItems: [
            TDNavBarItem(icon: TDIcons.chevron_left,iconSize: 24),
          ],
          rightBarItems: [
            TDNavBarItem(icon: TDIcons.home,iconSize: 24),
            TDNavBarItem(icon: TDIcons.ellipsis,iconSize: 24)
          ]
      ),
    );
  }</pre>

</td-code-block>
                                  

自定义颜色
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _setBgColorNavbar(BuildContext context) {
    return TDNavBar(
        height: 48,
        title: titleText,
        titleColor: Colors.white,
        backgroundColor: TDTheme.of(context).brandNormalColor,
        titleFontWeight: FontWeight.w600,
        useDefaultBack: false,
        screenAdaptation: false,
        leftBarItems: [
          TDNavBarItem(icon: TDIcons.chevron_left, iconSize: 24, iconColor: Colors.white),
        ],
        rightBarItems: [
          TDNavBarItem(icon: TDIcons.home, iconSize: 24, iconColor: Colors.white),
          TDNavBarItem(icon: TDIcons.ellipsis, iconSize: 24, iconColor: Colors.white)
        ]
    );
  }</pre>

</td-code-block>
                                  


## API
### TDNavBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| leftBarItems | List<TDNavBarItem>? | - | 左边操作项 |
| rightBarItems | List<TDNavBarItem>? | - | 右边操作项 |
| titleWidget | Widget? | - | 标题控件，优先级高于title文案 |
| title | String? | - | 标题文案 |
| titleColor | Color? | - | 标题颜色 |
| titleFont | Font? | - | 标题字体尺寸 |
| titleFontFamily | FontFamily? | - | 标题字体样式 |
| titleFontWeight | FontWeight? | FontWeight.w500 | 标题字体粗细 |
| centerTitle | bool | true | 标题是否居中 |
| opacity | double | 1.0 | 透明度 |
| backgroundColor | Color? | - | 背景颜色 |
| titleMargin | double | 16 | 中间文案左右两边间距 |
| padding | EdgeInsetsGeometry? | - | 内部填充 |
| height | double | 44 | 高度 |
| screenAdaptation | bool | true | 是否进行屏幕适配，默认true |
| useDefaultBack | bool | true | 是否使用默认的返回 |
| onBack | VoidCallback? | - | 返回事件 |
| useBorderStyle | bool | false | 是否使用边框模式 |
| border | TDNavBarItemBorder? | - | 边框 |
| belowTitleWidget | Widget? | - | belowTitleWidget navbar 下方的widget |

```
```
 ### TDNavBarItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| icon | IconData? | - | 图标 |
| iconColor | Color? | - | 图标颜色 |
| action | TDBarItemAction? | - | 操作回调 |
| iconSize | double? | 24.0 | 图标尺寸 |
| padding | EdgeInsetsGeometry? | - |  |
| iconWidget | Widget? | - | 图标组件，优先级高与icon |


  