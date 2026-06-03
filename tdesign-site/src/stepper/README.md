---
title: Stepper 步进器
description: 用于数量的增减。
spline: form
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在 `tdesign_flutter/tdesign_flutter.dart` 中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```


## 代码演示

[td_stepper_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_stepper_page.dart)

### 1 组件类型

基础步进器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildStepperWithBase(BuildContext context) {
    return _buildRow(context, [
      const TStepper(
        theme: TStepperTheme.filled,
      )
    ]);
  }</pre>

</td-code-block>
                                  
### 1 组件状态

最大最小状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildStepperWithMaxMinStatus(BuildContext context) {
    return _buildRow(context, [
      const TStepper(theme: TStepperTheme.filled, value: 0, min: 0),
      const TStepper(theme: TStepperTheme.filled, value: 999, max: 999),
    ]);
  }</pre>

</td-code-block>
                                  

禁用状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildStepperWithDisableStatus(BuildContext context) {
    return _buildRow(context, [
      const TStepper(
        theme: TStepperTheme.filled,
        disabled: true,
      ),
      const TStepper(
        theme: TStepperTheme.outline,
        disabled: true,
      ),
      const TStepper(
        theme: TStepperTheme.normal,
        disabled: true,
      ),
    ]);
  }</pre>

</td-code-block>
                                  
### 1 组件样式

步进器样式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildStepperWithTheme(BuildContext context) {
    return _buildRow(context, [
      const TStepper(theme: TStepperTheme.filled, value: 3),
      const TStepper(theme: TStepperTheme.outline, value: 3),
      const TStepper(theme: TStepperTheme.normal, value: 3),
    ]);
  }</pre>

</td-code-block>
                                  

步进器尺寸
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildStepperWithSize(BuildContext context) {
    return _buildRow(context, [
      const TStepper(
          size: TStepperSize.large, theme: TStepperTheme.filled, value: 3),
      const TStepper(
          size: TStepperSize.medium, theme: TStepperTheme.filled, value: 3),
      const TStepper(
          size: TStepperSize.small, theme: TStepperTheme.filled, value: 3),
    ]);
  }</pre>

</td-code-block>
                                  


## API
### TStepper
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| controller | TStepperController? | - | Stepper控制器 |
| defaultValue | int? | 0 | 默认值 |
| disabled | bool | false | 禁用全部操作 |
| disableInput | bool | false | 禁用输入框 |
| eventController | StreamController<TStepperEventType>? | - | 事件控制器 |
| inputWidth | double? | - | 禁用全部操作 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| max | int | 100 | 最大值 |
| min | int | 0 | 最小值 |
| onBlur | VoidCallback? | - | 输入框失去焦点时触发 |
| onChange | ValueChanged<int>? | - | 数值发生变更时触发 |
| onOverlimit | TStepperOverlimitFunction? | - | 数值超出限制时触发 |
| size | TStepperSize | TStepperSize.medium | 组件尺寸 |
| step | int | 1 | 步长 |
| theme | TStepperTheme | TStepperTheme.normal | 组件风格 |
| value | int? | 0 | 值 |


### TStepperSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | - |
| medium | - |
| large | - |


### TStepperTheme
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | - |
| filled | - |
| outline | - |


### TStepperIconType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| remove | - |
| add | - |


### TStepperOverlimitType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| minus | - |
| plus | - |


### TStepperEventType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| cleanValue | - |


### TStepperOverlimitFunction
#### 类型定义

```dart
typedef TStepperOverlimitFunction = void Function(TStepperOverlimitType type);
```


### TTapFunction
#### 类型定义

```dart
typedef TTapFunction = void Function();
```


  