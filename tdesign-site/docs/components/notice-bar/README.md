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

[t_notice_bar_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_notice_bar_page.dart)

### 01 组件类型

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
    prefixIcon: TIcons.sound,
    marquee: true,
    speed: 50,
  );
}</pre>

</td-code-block>

垂直滚动的公告栏

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _stepNoticeBar(BuildContext context) {
  return const TNoticeBar(
    prefixIcon: TIcons.sound,
    items: [
      '君不见黄河之水天上来',
      '奔流到海不复回',
      '君不见',
      '这是一条很长很长的消息提醒内容测试这是一条很长很长的消息提醒内容测试',
    ],
    direction: Axis.vertical,
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
  return TNoticeBar(
    content: '这是一条普通的通知信息',
    prefixIcon: TIcons.error_circle_filled,
    suffixIcon: TIcons.close,
    onPressed: (target) {
      if (target == TNoticeBarTapTarget.suffix) {
        TToast.showText('点击了关闭按钮', context: context);
      }
    },
  );
}</pre>

</td-code-block>

带入口的公告栏

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _entranceNoticeBar1(BuildContext context) {
  return TNoticeBar(
    content: '这是一条普通的通知信息',
    prefixIcon: TIcons.error_circle_filled,
    right: TButton(
      child: const Text('文字按钮'),
      variant: TButtonVariant.text,
      colorScheme: TButtonColorScheme.primary,
      size: TButtonSize.extraSmall,
      onPressed: () => TToast.showText('点击了文字按钮', context: context),
    ),
  );
}</pre>

</td-code-block>


<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _entranceNoticeBar2(BuildContext context) {
  return TNoticeBar(
    content: '这是一条普通的通知信息',
    prefixIcon: TIcons.error_circle_filled,
    suffixIcon: TIcons.chevron_right,
    onPressed: (target) {
      if (target == TNoticeBarTapTarget.suffix) {
        TToast.showText('点击了入口图标', context: context);
      }
    },
  );
}</pre>

</td-code-block>

自定义内容的公告栏

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _leftNoticeBar(BuildContext context) {
  return TNoticeBar(
    content: '这是一条普通的通知信息',
    suffixIcon: TIcons.chevron_right,
    left: TButton(
      child: const Text('文本'),
      variant: TButtonVariant.text,
      colorScheme: TButtonColorScheme.primary,
      size: TButtonSize.extraSmall,
      onPressed: () => TToast.showText('点击了文字按钮', context: context),
    ),
    onPressed: (target) {
      if (target == TNoticeBarTapTarget.suffix) {
        TToast.showText('点击了入口图标', context: context);
      }
    },
  );
}</pre>

</td-code-block>

自定义样式的公告栏

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _customNoticeBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      TNoticeBarThemeData(
        variant: TNoticeBarVariant.info,
        backgroundColor: context.tTheme.bgColorComponent,
      ),
    ),
    child: const TNoticeBar(
      content: '这是一条普通的通知信息',
      prefixIcon: TIcons.notification,
      suffixIcon: TIcons.chevron_right,
    ),
  );
}</pre>

</td-code-block>
### 02 组件状态

普通通知

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _normalNoticeBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      const TNoticeBarThemeData(
        variant: TNoticeBarVariant.info,
      ),
    ),
    child: const TNoticeBar(
      content: '这是一条普通的通知信息',
      prefixIcon: TIcons.error_circle_filled,
    ),
  );
}</pre>

</td-code-block>

成功通知

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _successNoticeBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      const TNoticeBarThemeData(
        variant: TNoticeBarVariant.success,
      ),
    ),
    child: const TNoticeBar(
      content: '这是一条成功的通知信息',
      prefixIcon: TIcons.check_circle_filled,
    ),
  );
}</pre>

</td-code-block>

警示通知

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _warningNoticeBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      const TNoticeBarThemeData(
        variant: TNoticeBarVariant.warning,
      ),
    ),
    child: const TNoticeBar(
      content: '这是一条警示的通知信息',
      prefixIcon: TIcons.error_circle_filled,
    ),
  );
}</pre>

</td-code-block>

错误通知

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _errorNoticeBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      const TNoticeBarThemeData(
        variant: TNoticeBarVariant.error,
      ),
    ),
    child: const TNoticeBar(
      content: '这是一条错误的通知信息',
      prefixIcon: TIcons.error_circle_filled,
    ),
  );
}</pre>

</td-code-block>
## API
### TNoticeBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | String | '' | 单条公告内容 |
| direction | Axis | Axis.horizontal | 滚动方向 |
| interval | Duration | const Duration(seconds: 3) | 垂直轮播的切换间隔 |
| items | List<String> | const <String>[] | 多条公告内容，主要用于垂直轮播 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| left | Widget? | - | 左侧内容（自定义左侧内容，优先级高于prefixIcon） |
| marquee | bool | false | 是否启用滚动展示 |
| maxLines | int | 1 | 文本行数（仅静态有效） |
| onPressed | ValueChanged<TNoticeBarTapTarget>? | - | 点击事件 |
| prefixIcon | IconData? | - | 左侧图标；`left` 非空时不渲染。 |
| right | Widget? | - | 右侧内容（自定义右侧内容，优先级高于suffixIcon） |
| speed | double | 50 | 每秒滚动的逻辑像素 |
| suffixIcon | IconData? | - | 右侧图标；`right` 非空时不渲染。 |


### TNoticeBarTapTarget
#### 简介
公告栏点击区域
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| prefix | 左侧图标 |
| content | 公告内容 |
| suffix | 右侧图标 |


### TNoticeBarThemeData
#### 简介
公告栏组件级 ThemeExtension，通过 Theme 子树注入控制默认公告栏样式。
#### 字段

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| variant | TNoticeBarVariant? | 语义色变体 |
| height | double? | 文字高度 |
| backgroundColor | Color? | 公告栏背景色 |
| textStyle | TextStyle? | 公告栏内容样式 |
| leftIconColor | Color? | 公告栏左侧图标颜色 |
| rightIconColor | Color? | 公告栏右侧图标颜色 |
| padding | EdgeInsetsGeometry? | 公告栏内边距 |


### TNoticeBarVariant
#### 简介
公告栏语义色
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| info | 信息（默认） |
| success | 成功 |
| warning | 警告 |
| error | 错误 |
