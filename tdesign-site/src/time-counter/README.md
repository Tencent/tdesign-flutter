---
title: TimeCounter 计时器
description: 用于实时展示计时数值。
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

[td_time-counter_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_time-counter_page.dart)

### 1 组件类型

时分秒
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildSimple(BuildContext context) {
  return const TTimeCounter(time: 60 * 60 * 1000);
}</pre>

</td-code-block>
                                  

带毫秒
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildMillisecondSimple(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    millisecond: true,
  );
}</pre>

</td-code-block>
                                  

正向计时
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildUpSimple(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    millisecond: true,
    direction: TTimeCounterDirection.up,
  );
}</pre>

</td-code-block>
                                  

带方形底
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildSquareSimple(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    theme: TTimeCounterTheme.square,
  );
}</pre>

</td-code-block>
                                  

带圆形底
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildRoundSimple(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    theme: TTimeCounterTheme.round,
  );
}</pre>

</td-code-block>
                                  

带单位
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildUnitSimple(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    theme: TTimeCounterTheme.square,
    splitWithUnit: true,
  );
}</pre>

</td-code-block>
                                  

无底色带单位
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildCustomUnitSimple(BuildContext context) {
  var style = TTimeCounterStyle.generateStyle(context);
  style.timeColor = TTheme.of(context).errorNormalColor;
  return TTimeCounter(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}</pre>

</td-code-block>
                                  
### 1 组件尺寸

纯数字

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildSmallSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.small,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildMediumSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.medium,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildLargeSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.large,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildSmallSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.small,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildMediumSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.medium,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildLargeSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.large,
  );
}</pre>

</td-code-block>
                

带方形底

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildSquareSmallSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.small,
    theme: TTimeCounterTheme.square,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildSquareMediumSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.medium,
    theme: TTimeCounterTheme.square,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildSquareLargeSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.large,
    theme: TTimeCounterTheme.square,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildSquareSmallSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.small,
    theme: TTimeCounterTheme.square,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildSquareMediumSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.medium,
    theme: TTimeCounterTheme.square,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildSquareLargeSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.large,
    theme: TTimeCounterTheme.square,
  );
}</pre>

</td-code-block>
                

带圆形底

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildRoundSmallSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.small,
    theme: TTimeCounterTheme.round,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildRoundMediumSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.medium,
    theme: TTimeCounterTheme.round,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildRoundLargeSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.large,
    theme: TTimeCounterTheme.round,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildRoundSmallSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.small,
    theme: TTimeCounterTheme.round,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildRoundMediumSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.medium,
    theme: TTimeCounterTheme.round,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildRoundLargeSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.large,
    theme: TTimeCounterTheme.round,
  );
}</pre>

</td-code-block>
                

带单位

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildUnitSmallSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.small,
    theme: TTimeCounterTheme.square,
    splitWithUnit: true,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildUnitMediumSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.medium,
    theme: TTimeCounterTheme.square,
    splitWithUnit: true,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildUnitLargeSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.large,
    theme: TTimeCounterTheme.square,
    splitWithUnit: true,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildUnitSmallSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.small,
    theme: TTimeCounterTheme.square,
    splitWithUnit: true,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildUnitMediumSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.medium,
    theme: TTimeCounterTheme.square,
    splitWithUnit: true,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildUnitLargeSize(BuildContext context) {
  return const TTimeCounter(
    time: 60 * 60 * 1000,
    size: TTimeCounterSize.large,
    theme: TTimeCounterTheme.square,
    splitWithUnit: true,
  );
}</pre>

</td-code-block>
                

无底色带单位

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildCustomUnitSmallSize(BuildContext context) {
  var style =
      TTimeCounterStyle.generateStyle(context, size: TTimeCounterSize.small);
  style.timeColor = TTheme.of(context).errorNormalColor;
  return TTimeCounter(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildCustomUnitMediumSize(BuildContext context) {
  var style =
      TTimeCounterStyle.generateStyle(context, size: TTimeCounterSize.medium);
  style.timeColor = TTheme.of(context).errorNormalColor;
  return TTimeCounter(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildCustomUnitLargeSize(BuildContext context) {
  var style =
      TTimeCounterStyle.generateStyle(context, size: TTimeCounterSize.large);
  style.timeColor = TTheme.of(context).errorNormalColor;
  return TTimeCounter(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildCustomUnitSmallSize(BuildContext context) {
  var style =
      TTimeCounterStyle.generateStyle(context, size: TTimeCounterSize.small);
  style.timeColor = TTheme.of(context).errorNormalColor;
  return TTimeCounter(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildCustomUnitMediumSize(BuildContext context) {
  var style =
      TTimeCounterStyle.generateStyle(context, size: TTimeCounterSize.medium);
  style.timeColor = TTheme.of(context).errorNormalColor;
  return TTimeCounter(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TTimeCounter _buildCustomUnitLargeSize(BuildContext context) {
  var style =
      TTimeCounterStyle.generateStyle(context, size: TTimeCounterSize.large);
  style.timeColor = TTheme.of(context).errorNormalColor;
  return TTimeCounter(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}</pre>

</td-code-block>
                


## API
### TTimeCounter
#### 简介
计时组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| autoStart | bool | true | 是否自动开始倒计时 |
| content | dynamic | 'default' | 'default' / Widget Function(int time) / Widget |
| controller | TTimeCounterController? | - | 控制器，可控制开始/暂停/继续/重置 |
| direction | TTimeCounterDirection | TTimeCounterDirection.down | 计时方向，默认倒计时 |
| format | String | 'HH:mm:ss' | 时间格式，DD-日，HH-时，mm-分，ss-秒，SSS-毫秒（分隔符必须为长度为1的非空格的字符） |
| key |  | - |  |
| millisecond | bool | false | 是否开启毫秒级渲染 |
| onChange |  Function(int time)? | - | 时间变化时触发回调 |
| onFinish | VoidCallback? | - | 计时结束时触发回调 |
| size | TTimeCounterSize | TTimeCounterSize.medium | 尺寸 |
| splitWithUnit | bool | false | 使用时间单位分割 |
| style | TTimeCounterStyle? | - | 自定义样式，有则优先用它，没有则根据size和theme选取 |
| theme | TTimeCounterTheme | TTimeCounterTheme.defaultTheme | 风格 |
| time | int | - | 必需；计时时长，单位毫秒 |

```
```

### TTimeCounterController
#### 简介
倒计时组件控制器，可控制开始(`start()`)/暂停(`pause()`)/继续(`resume()`)/重置(`reset([int? time])`)
```
```

### TTimeCounterStyle
#### 简介
计时组件样式
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| space | double? | - | 时间与分隔符的间隔 |
| splitColor | Color? | - | 分隔符字体颜色 |
| splitFontHeight | double? | - | 分隔符字体行高 |
| splitFontSize | double? | - | 分隔符字体尺寸 |
| splitFontWeight | FontWeight? | - | 分隔符字体粗细 |
| timeBox | BoxDecoration? | - | 时间容器装饰 |
| timeColor | Color? | - | 时间字体颜色 |
| timeFontFamily | FontFamily? | - | 时间字体 |
| timeFontHeight | double? | - | 时间字体行高 |
| timeFontSize | double? | - | 时间字体尺寸 |
| timeFontWeight | FontWeight? | - | 时间字体粗细 |
| timeHeight | double? | - | 时间容器高度 |
| timeMargin | EdgeInsets? | - | 时间容器外边距 |
| timePadding | EdgeInsets? | - | 时间容器内边距 |
| timeWidth | double? | - | 时间容器宽度 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TTimeCounterStyle.generateStyle  | 生成默认样式 |


  