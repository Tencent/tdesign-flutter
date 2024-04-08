---
title: CountDown 倒计时
description: 用于实时展示倒计时数值。
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

时分秒

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildSimple(BuildContext context) {
  return const TDCountDown(time: 60 * 60 * 1000);
}</pre>

</td-code-block>
                

带毫秒

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildMillisecondSimple(BuildContext context) {
  return const TDCountDown(time: 60 * 60 * 1000, millisecond: true);
}</pre>

</td-code-block>
                

带方形底

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildSquareSimple(BuildContext context) {
  return const TDCountDown(
      time: 60 * 60 * 1000, theme: TDCountDownTheme.square);
}</pre>

</td-code-block>
                

带圆形底

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildRoundSimple(BuildContext context) {
  return const TDCountDown(time: 60 * 60 * 1000, theme: TDCountDownTheme.round);
}</pre>

</td-code-block>
                

带单位

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildUnitSimple(BuildContext context) {
  return const TDCountDown(
      time: 60 * 60 * 1000,
      theme: TDCountDownTheme.square,
      splitWithUnit: true);
}</pre>

</td-code-block>
                

无底色带单位

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildCustomUnitSimple(BuildContext context) {
  var style = TDCountDownStyle.generateStyle(context);
  style.timeColor = TDTheme.of(context).errorColor6;
  return TDCountDown(time: 60 * 60 * 1000, splitWithUnit: true, style: style);
}</pre>

</td-code-block>
                
### 1 组件尺寸

纯数字

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildSmallSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.small,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildMediumSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.medium,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildLargeSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.large,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildSmallSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.small,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildMediumSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.medium,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildLargeSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.large,
  );
}</pre>

</td-code-block>
                

带方形底

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildSquareSmallSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.small,
    theme: TDCountDownTheme.square,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildSquareMediumSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.medium,
    theme: TDCountDownTheme.square,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildSquareLargeSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.large,
    theme: TDCountDownTheme.square,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildSquareSmallSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.small,
    theme: TDCountDownTheme.square,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildSquareMediumSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.medium,
    theme: TDCountDownTheme.square,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildSquareLargeSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.large,
    theme: TDCountDownTheme.square,
  );
}</pre>

</td-code-block>
                

带圆形底

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildRoundSmallSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.small,
    theme: TDCountDownTheme.round,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildRoundMediumSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.medium,
    theme: TDCountDownTheme.round,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildRoundLargeSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.large,
    theme: TDCountDownTheme.round,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildRoundSmallSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.small,
    theme: TDCountDownTheme.round,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildRoundMediumSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.medium,
    theme: TDCountDownTheme.round,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildRoundLargeSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.large,
    theme: TDCountDownTheme.round,
  );
}</pre>

</td-code-block>
                

带单位

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildUnitSmallSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.small,
    theme: TDCountDownTheme.square,
    splitWithUnit: true,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildUnitMediumSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.medium,
    theme: TDCountDownTheme.square,
    splitWithUnit: true,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildUnitLargeSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.large,
    theme: TDCountDownTheme.square,
    splitWithUnit: true,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildUnitSmallSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.small,
    theme: TDCountDownTheme.square,
    splitWithUnit: true,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildUnitMediumSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.medium,
    theme: TDCountDownTheme.square,
    splitWithUnit: true,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildUnitLargeSize(BuildContext context) {
  return const TDCountDown(
    time: 60 * 60 * 1000,
    size: TDCountDownSize.large,
    theme: TDCountDownTheme.square,
    splitWithUnit: true,
  );
}</pre>

</td-code-block>
                

无底色带单位

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildCustomUnitSmallSize(BuildContext context) {
  var style =
      TDCountDownStyle.generateStyle(context, size: TDCountDownSize.small);
  style.timeColor = TDTheme.of(context).errorColor6;
  return TDCountDown(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildCustomUnitMediumSize(BuildContext context) {
  var style =
      TDCountDownStyle.generateStyle(context, size: TDCountDownSize.medium);
  style.timeColor = TDTheme.of(context).errorColor6;
  return TDCountDown(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildCustomUnitLargeSize(BuildContext context) {
  var style =
      TDCountDownStyle.generateStyle(context, size: TDCountDownSize.large);
  style.timeColor = TDTheme.of(context).errorColor6;
  return TDCountDown(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildCustomUnitSmallSize(BuildContext context) {
  var style =
      TDCountDownStyle.generateStyle(context, size: TDCountDownSize.small);
  style.timeColor = TDTheme.of(context).errorColor6;
  return TDCountDown(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildCustomUnitMediumSize(BuildContext context) {
  var style =
      TDCountDownStyle.generateStyle(context, size: TDCountDownSize.medium);
  style.timeColor = TDTheme.of(context).errorColor6;
  return TDCountDown(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
TDCountDown _buildCustomUnitLargeSize(BuildContext context) {
  var style =
      TDCountDownStyle.generateStyle(context, size: TDCountDownSize.large);
  style.timeColor = TDTheme.of(context).errorColor6;
  return TDCountDown(
    time: 60 * 60 * 1000,
    splitWithUnit: true,
    style: style,
  );
}</pre>

</td-code-block>
                


## API

暂无对应api


  