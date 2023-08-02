---
title: 圆角--基础
description: 
spline: other
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

### 1 数值型

3px 极小组件圆角
                  
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRadiusSmall(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          color: TDTheme.of(context).brandNormalColor,
          borderRadius: BorderRadius.circular(TDTheme.of(context).radiusSmall)),
    );
  }</pre>

</td-code-block>
                                        

6px 组件圆角
                  
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRadiusDefault(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          color: TDTheme.of(context).brandNormalColor,
          borderRadius:
              BorderRadius.circular(TDTheme.of(context).radiusDefault)),
    );
  }</pre>

</td-code-block>
                                        

9px 卡片圆角
                  
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRadiusLarge(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          color: TDTheme.of(context).brandNormalColor,
          borderRadius: BorderRadius.circular(TDTheme.of(context).radiusLarge)),
    );
  }</pre>

</td-code-block>
                                        

12px 面板圆角
                  
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRadiusExtraLarge(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          color: TDTheme.of(context).brandNormalColor,
          borderRadius:
              BorderRadius.circular(TDTheme.of(context).radiusExtraLarge)),
    );
  }</pre>

</td-code-block>
                                        
### 1 特殊

胶囊型
                  
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRadiusRound(BuildContext context) {
    // 胶囊型，数值设置较大
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          color: TDTheme.of(context).brandNormalColor,
          borderRadius: BorderRadius.circular(TDTheme.of(context).radiusRound)),
    );
  }</pre>

</td-code-block>
                                        

圆型
                  
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRadiusCircle(BuildContext context) {
    //  圆形与胶囊型一致，如果长款一致即是圆形
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: TDTheme.of(context).brandNormalColor,
          borderRadius:
              BorderRadius.circular(TDTheme.of(context).radiusCircle)),
    );
  }</pre>

</td-code-block>
                                        


## API
### radius
TDTheme内置radiusXXX系列参数，可参考radius演示代码实现圆角组件


  
