---
title: Progress 进度条
description: 用于展示任务当前的进度
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

[td_progress_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_progress_page.dart)

### 1 组件类型

线性进度条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRightLabelLinear(BuildContext context) {
    return TDProgress(
        type: TDProgressType.linear,
        value: 0.8,
        strokeWidth: 6,
        progressLabelPosition: TDProgressLabelPosition.right);
  }</pre>

</td-code-block>
                                  

百分比内显
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildInsideLabelLinear(BuildContext context) {
    return TDProgress(type: TDProgressType.linear, value: 0.8);
  }</pre>

</td-code-block>
                                  

环形进度条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCircle(BuildContext context) {
    return TDProgress(type: TDProgressType.circular, value: 0.3);
  }</pre>

</td-code-block>
                                  

微型环形进度条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildMicro(BuildContext context) {
    return TDProgress(type: TDProgressType.micro, value: 0.75);
  }</pre>

</td-code-block>
                                  

按钮进度条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildButton(BuildContext context) {
    return TDProgress(
        type: TDProgressType.button,
        onTap: _toggleProgress,
        onLongPress: _resetProgress,
        value: progressValue,
        label: buttonLabel);
  }</pre>

</td-code-block>
                                  

微型按钮进度条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildMicroButton(BuildContext context) {
    return TDProgress(
      type: TDProgressType.micro,
      value: microProgressValue,
      onTap: _toggleMicroProgress,
      label: TDIconLabel(isPlaying ? Icons.pause : Icons.play_arrow,
          color: TDTheme.of(context).brandNormalColor),
    );
  }</pre>

</td-code-block>
                                  
### 1 组件状态

线性进度条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPrimary(BuildContext context) {
    return TDProgress(
        type: TDProgressType.linear,
        progressStatus: TDProgressStatus.primary,
        value: 0.8,
        strokeWidth: 6,
        progressLabelPosition: TDProgressLabelPosition.right);
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildWarning(BuildContext context) {
    return TDProgress(
        type: TDProgressType.linear,
        progressStatus: TDProgressStatus.warning,
        value: 0.8,
        strokeWidth: 6,
        progressLabelPosition: TDProgressLabelPosition.right,
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDanger(BuildContext context) {
    return TDProgress(
        type: TDProgressType.linear,
        progressStatus: TDProgressStatus.danger,
        value: 0.8,
        strokeWidth: 6,
        progressLabelPosition: TDProgressLabelPosition.right);
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSuccess(BuildContext context) {
    return TDProgress(
        type: TDProgressType.linear,
        progressStatus: TDProgressStatus.success,
        value: 0.8,
        strokeWidth: 6,
        progressLabelPosition: TDProgressLabelPosition.right);
  }</pre>

</td-code-block>
                                  

环形进度条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCirclePrimary(BuildContext context) {
    return TDProgress(
        type: TDProgressType.circular,
        progressStatus: TDProgressStatus.primary,
        value: 0.3);
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCircleWarning(BuildContext context) {
    return TDProgress(
        type: TDProgressType.circular,
        progressStatus: TDProgressStatus.warning,
        value: 0.3);
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCircleDanger(BuildContext context) {
    return TDProgress(
        type: TDProgressType.circular,
        progressStatus: TDProgressStatus.danger,
        value: 0.3);
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCircleSuccess(BuildContext context) {
    return TDProgress(
        type: TDProgressType.circular,
        progressStatus: TDProgressStatus.success,
        value: 1);
  }</pre>

</td-code-block>
                                  


## API

暂无对应api


  