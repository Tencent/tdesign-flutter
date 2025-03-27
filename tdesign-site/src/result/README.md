---
title: Result 结果
description: 反馈结果状态。
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

[td_result_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_result_page.dart)

### 1 组件类型

基础结果

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDResult _buildBasicResultSuccess(BuildContext context) {
    return const TDResult(
      title: '成功状态',
      theme: TDResultTheme.success,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDResult _buildBasicResultError(BuildContext context) {
    return const TDResult(
      title: '失败状态',
      theme: TDResultTheme.error,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDResult _buildBasicResultWarning(BuildContext context) {
    return const TDResult(
      title: '警示状态',
      theme: TDResultTheme.warning,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDResult _buildBasicResultDefault(BuildContext context) {
    return const TDResult(
      title: '默认状态',
      theme: TDResultTheme.defaultTheme,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDResult _buildBasicResultSuccess(BuildContext context) {
    return const TDResult(
      title: '成功状态',
      theme: TDResultTheme.success,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDResult _buildBasicResultError(BuildContext context) {
    return const TDResult(
      title: '失败状态',
      theme: TDResultTheme.error,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDResult _buildBasicResultWarning(BuildContext context) {
    return const TDResult(
      title: '警示状态',
      theme: TDResultTheme.warning,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDResult _buildBasicResultDefault(BuildContext context) {
    return const TDResult(
      title: '默认状态',
      theme: TDResultTheme.defaultTheme,
    );
  }</pre>

</td-code-block>
                

带描述的结果

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDResult _buildResultWithDescriptionSuccess(BuildContext context) {
    return const TDResult(
      title: '成功状态',
      theme: TDResultTheme.success,
      description: '描述文字',
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDResult _buildResultWithDescriptionError(BuildContext context) {
    return const TDResult(
      title: '失败状态',
      theme: TDResultTheme.error,
      description: '描述文字',
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDResult _buildResultWithDescriptionWarning(BuildContext context) {
    return const TDResult(
      title: '警示状态',
      theme: TDResultTheme.warning,
      description: '描述文字',
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDResult _buildResultWithDescriptionDefault(BuildContext context) {
    return const TDResult(
      title: '默认状态',
      theme: TDResultTheme.defaultTheme,
      description: '描述文字',
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDResult _buildResultWithDescriptionSuccess(BuildContext context) {
    return const TDResult(
      title: '成功状态',
      theme: TDResultTheme.success,
      description: '描述文字',
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDResult _buildResultWithDescriptionError(BuildContext context) {
    return const TDResult(
      title: '失败状态',
      theme: TDResultTheme.error,
      description: '描述文字',
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDResult _buildResultWithDescriptionWarning(BuildContext context) {
    return const TDResult(
      title: '警示状态',
      theme: TDResultTheme.warning,
      description: '描述文字',
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDResult _buildResultWithDescriptionDefault(BuildContext context) {
    return const TDResult(
      title: '默认状态',
      theme: TDResultTheme.defaultTheme,
      description: '描述文字',
    );
  }</pre>

</td-code-block>
                

自定义结果

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDResult _buildCustomResultContent(BuildContext context) {
    return TDResult(
      title: '自定义结果',
      icon: Image.asset('assets/img/illustration.png'),
      description: '描述文字',
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDResult _buildCustomResultContent(BuildContext context) {
    return TDResult(
      title: '自定义结果',
      icon: Image.asset('assets/img/illustration.png'),
      description: '描述文字',
    );
  }</pre>

</td-code-block>
                

页面示例
      
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">暂无演示代码</pre>

</td-code-block>
                


## API
### TDResult
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| description | String? | - | 描述文本，用于提供额外信息 |
| icon | Widget? | - | 图标组件，用于在结果中显示一个图标 |
| titleStyle | TextStyle? | - | 自定义字体样式，用于设置标题文本的样式 |
| theme | TDResultTheme | TDResultTheme.defaultTheme | 主题样式，定义了结果组件的视觉风格 |
| title | String | '' | 标题文本，显示结果的主要信息 |


  