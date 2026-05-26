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
  return const TNoticeBar(
    content: '这是一条普通的通知信息',
  );
}</pre>

</td-code-block>
                                  

可滚动的公告栏
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _scrollNoticeBar(BuildContext context) {
  return const TNoticeBar(
    content: '提示文字描述提示文字描述提示文字描述提示文字描述提示文字',
    marquee: true,
    speed: 50,
  );
}</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _scrollIconNoticeBar(BuildContext context) {
  return const TNoticeBar(
    content: '提示文字描述提示文字描述提示文字描述提示文字描述提示文字',
    speed: 50,
    prefixIcon: TIcons.sound,
    marquee: true,
  );
}</pre>

</td-code-block>
                                  

带图标的公告栏
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _iconNoticeBar(BuildContext context) {
  return const TNoticeBar(
    content: '这是一条普通的通知信息',
    prefixIcon: TIcons.error_circle_filled,
  );
}</pre>

</td-code-block>
                                  

带关闭的公告栏
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _closeNoticeBar(BuildContext context) {
  return const TNoticeBar(
    content: '这是一条普通的通知信息',
    prefixIcon: TIcons.error_circle_filled,
    suffixIcon: TIcons.close,
  );
}</pre>

</td-code-block>
                                  

带入口的公告栏
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _entranceNoticeBar1(BuildContext context) {
  return const TNoticeBar(
    content: '这是一条普通的通知信息',
    prefixIcon: TIcons.error_circle_filled,
    right: TButton(
      text: '文字按钮',
      type: TButtonType.text,
      theme: TButtonTheme.primary,
      size: TButtonSize.extraSmall,
      height: 22,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    ),
  );
}</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _entranceNoticeBar2(BuildContext context) {
  return const TNoticeBar(
    content: '这是一条普通的通知信息',
    prefixIcon: TIcons.error_circle_filled,
    suffixIcon: TIcons.chevron_right,
  );
}</pre>

</td-code-block>
                                  

自定义样式的公告栏
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _customNoticeBar(BuildContext context) {
  return TNoticeBar(
    content: '这是一条普通的通知信息',
    prefixIcon: TIcons.notification,
    suffixIcon: TIcons.chevron_right,
    style: TNoticeBarStyle.generateTheme(context, theme: TNoticeBarTheme.info)
      ..backgroundColor = TTheme.of(context).bgColorComponent,
  );
}</pre>

</td-code-block>
                                  
### 1 组件状态

普通通知
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _normalNoticeBar(BuildContext context) {
  return const TNoticeBar(
    content: '这是一条普通的通知信息',
    prefixIcon: TIcons.error_circle_filled,
    theme: TNoticeBarTheme.info,
  );
}</pre>

</td-code-block>
                                  

成功通知
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _successNoticeBar(BuildContext context) {
  return const TNoticeBar(
    content: '这是一条成功的通知信息',
    prefixIcon: TIcons.check_circle_filled,
    theme: TNoticeBarTheme.success,
  );
}</pre>

</td-code-block>
                                  

警示通知
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _warningNoticeBar(BuildContext context) {
  return const TNoticeBar(
    content: '这是一条警示的通知信息',
    prefixIcon: TIcons.error_circle_filled,
    theme: TNoticeBarTheme.warning,
  );
}</pre>

</td-code-block>
                                  

错误通知
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _errorNoticeBar(BuildContext context) {
  return const TNoticeBar(
    content: '这是一条错误的通知信息',
    prefixIcon: TIcons.error_circle_filled,
    theme: TNoticeBarTheme.error,
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
      color: TNoticeBarStyle.generateTheme(context).backgroundColor,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
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
          child: const TNoticeBar(
            content: '这是一条普通的通知信息',
            prefixIcon: TIcons.error_circle_filled,
            suffixIcon: TIcons.chevron_right,
          ),
        ),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: TTheme.of(context).bgColorContainer,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
        )
      ],
    ),
  );
}</pre>

</td-code-block>
                                  


## API
### TNoticeBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | dynamic | - | 文本内容（字符串或字符串数组等） |
| context | dynamic | - | 文本内容（请使用content属性） |
| direction | Axis? | Axis.horizontal | 滚动方向 |
| height | double | 22 | 文字高度 (当使用prefixIcon或suffixIcon时，icon大小值等于该属性） |
| interval | int? | 3000 | 步进滚动间隔时间（毫秒） |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| left | Widget? | - | 左侧内容（自定义左侧内容，优先级高于prefixIcon） |
| marquee | bool? | false | 跑马灯效果 |
| maxLines | int? | 1 | 文本行数（仅静态有效） |
| onTap | ValueChanged? | - | 点击事件 |
| prefixIcon | IconData? | - | 左侧图标 |
| right | Widget? | - | 右侧内容（自定义右侧内容，优先级高于suffixIcon） |
| speed | double? | 50 | 滚动速度 |
| style | TNoticeBarStyle? | - | 公告栏样式 [TNoticeBarStyle] |
| suffixIcon | IconData? | - | 右侧图标 |
| theme | TNoticeBarTheme? | TNoticeBarTheme.info | 主题 |


### TNoticeBarStyle
#### 简介
公告栏样式
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 公告栏背景色 |
| context | BuildContext? | - | 上下文 |
| leftIconColor | Color? | - | 公告栏左侧图标颜色 |
| padding | EdgeInsetsGeometry? | - | 公告栏内边距 |
| rightIconColor | Color? | - | 公告栏右侧图标颜色 |
| textStyle | TextStyle? | - | 公告栏内容样式 |


#### 工厂构造方法

##### TNoticeBarStyle.generateTheme

根据主题生成样式

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |
| theme | TNoticeBarTheme? | TNoticeBarTheme.info | - |


### TNoticeBarType
#### 简介
公告栏类型
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| none | 静止（默认） |
| scroll | 滚动 |
| step | 步进 |


### TNoticeBarTheme
#### 简介
公告栏主题
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| info | 信息（默认） |
| success | 成功 |
| warning | 警告 |
| error | 错误 |


  