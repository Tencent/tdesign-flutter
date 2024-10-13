---
title: NoticeBar 公告栏
description: 在导航栏下方，用于给用户显示提示消息。
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

[td_notice-bar_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_notice-bar_page.dart)

### 1 组件类型

纯文字的公告栏
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _textNoticeBar(BuildContext context) {
  return const TDNoticeBar(context: '这是一条普通的通知信息');
}</pre>

</td-code-block>
                                  

可滚动的公告栏
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _scrollNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    context: '提示文字描述提示文字描述提示文字描述提示文字描述提示文字',
    marquee: true,
    speed: 50,
  );
}</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _scrollIconNoticeBar(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.only(top: 16),
    child: TDNoticeBar(
      context: '提示文字描述提示文字描述提示文字描述提示文字描述提示文字',
      speed: 50,
      prefixIcon: TDIcons.sound,
      marquee: true,
    ),
  );
}</pre>

</td-code-block>
                                  

带图标的公告栏
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _iconNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    context: '这是一条普通的通知信息',
    prefixIcon: TDIcons.error_circle_filled,
  );
}</pre>

</td-code-block>
                                  

带关闭的公告栏
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _closeNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    context: '这是一条普通的通知信息',
    prefixIcon: TDIcons.error_circle_filled,
    suffixIcon: TDIcons.close,
  );
}</pre>

</td-code-block>
                                  

带入口的公告栏
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _entranceNoticeBar1(BuildContext context) {
  return const TDNoticeBar(
    context: '这是一条普通的通知信息',
    prefixIcon: TDIcons.error_circle_filled,
    right: TDButton(
      text: '文字按钮',
      type: TDButtonType.text,
      theme: TDButtonTheme.primary,
      size: TDButtonSize.extraSmall,
      height: 22,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    ),
  );
}</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _entranceNoticeBar2(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.only(top: 16),
    child: TDNoticeBar(
      context: '这是一条普通的通知信息',
      prefixIcon: TDIcons.error_circle_filled,
      suffixIcon: TDIcons.chevron_right,
    ),
  );
}</pre>

</td-code-block>
                                  

自定义样式的公告栏
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _customNoticeBar(BuildContext context) {
  return TDNoticeBar(
    context: '这是一条普通的通知信息',
    prefixIcon: TDIcons.notification,
    suffixIcon: TDIcons.chevron_right,
    style: TDNoticeBarStyle(backgroundColor: TDTheme.of(context).grayColor3),
  );
}</pre>

</td-code-block>
                                  
### 1 组件状态

普通通知
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _normalNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    context: '这是一条普通的通知信息',
    prefixIcon: TDIcons.error_circle_filled,
    theme: TDNoticeBarTheme.info,
  );
}</pre>

</td-code-block>
                                  

成功通知
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _successNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    context: '这是一条普通的通知信息',
    prefixIcon: TDIcons.error_circle_filled,
    theme: TDNoticeBarTheme.success,
  );
}</pre>

</td-code-block>
                                  

警示通知
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _warningNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    context: '这是一条普通的通知信息',
    prefixIcon: TDIcons.error_circle_filled,
    theme: TDNoticeBarTheme.warning,
  );
}</pre>

</td-code-block>
                                  

错误通知
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _errorNoticeBar(BuildContext context) {
  return const TDNoticeBar(
    context: '这是一条普通的通知信息',
    prefixIcon: TDIcons.error_circle_filled,
    theme: TDNoticeBarTheme.error,
  );
}</pre>

</td-code-block>
                                  
### 1 组件样式

卡片顶部
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _cardNoticeBar(BuildContext context) {
  var size = MediaQuery.of(context).size;
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: TDNoticeBarStyle.generateTheme(context).backgroundColor,
      borderRadius: const BorderRadius.all(Radius.circular(9)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0d000000),
          blurRadius: 8,
          spreadRadius: 2,
          offset: Offset(0, 2),
        ),
        BoxShadow(
          color: Color(0x0f000000),
          blurRadius: 10,
          spreadRadius: 1,
          offset: Offset(0, 8),
        ),
        BoxShadow(
          color: Color(0x1a000000),
          blurRadius: 5,
          spreadRadius: -3,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          width: size.width - 32,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          clipBehavior: Clip.hardEdge,
          child: const TDNoticeBar(
            context: '这是一条普通的通知信息',
            prefixIcon: TDIcons.error_circle_filled,
            suffixIcon: TDIcons.chevron_right,
          ),
        ),
        Container(
          height: 150,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        )
      ],
    ),
  );
}</pre>

</td-code-block>
                                  


## API
### TDNoticeBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| context | dynamic | - | 文本内容 |
| style | TDNoticeBarStyle? | - | 公告栏样式 |
| left | Widget? | - | 左侧内容（自定义左侧内容，优先级高于prefixIcon） |
| right | Widget? | - | 侧内容（自定义右侧内容，优先级高于suffixIcon） |
| marquee | bool? | false | 跑马灯效果 |
| speed | double? | 50 | 滚动速度 |
| interval | int? | 3000 | 步进滚动间隔时间（毫秒） |
| direction | Axis? | Axis.horizontal | 滚动方向 |
| theme | TDNoticeBarThemez? | TDNoticeBarThemez.info | 主题 |
| prefixIcon | IconData? | - | 左侧图标 |
| suffixIcon | IconData? | - | 右侧图标 |
| onTap | ValueChanged<dynamic>? | - | 点击事件 |

```
```
### TDNoticeBarStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext? | - | 上下文 |
| backgroundColor | Color? | - | 公告栏的背景色 |
| leftIconColor | Color? | - | 公告栏左侧图标的颜色 |
| rightIconColor | Color? | - | 公告栏右侧图标的颜色 |
| padding | EdgeInsetsGeometry? | EdgeInsets.only(top: 13, bottom: 13, left: 16, right: 12) | 公告栏的内边距 |
| textStyle | TextStyle? | TextStyle(color: TDTheme.of(context).fontGyColor1, fontSize: 16, height: 1) | 公告栏内容的文本样式 |



  