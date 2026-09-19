---
title: Slider 滑动选择器
description: 用于选择横轴上的数值、区间、档位。
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

以下示例代码直接来自 Example App 的 `@ExampleCode(group: "slider")` 生成资产，Web 文档不维护代码副本。

{{ flutter-example-group slider }}

## API
### TSlider
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| boxDecoration | Decoration? | - | 自定义盒子样式 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| leftLabel | String? | - | 左侧标签 |
| onChanged | ValueChanged<double>? | - | 滑动变化监听 |
| onChangeEnd | ValueChanged<double>? | - | 滑动结束监听 |
| onChangeStart | ValueChanged<double>? | - | 滑动开始监听 |
| onTap | Function(Offset offset, double value)? | - | Thumb 点击事件 坐标、当前值 |
| onThumbTextTap | Function(Offset offset, double value)? | - | Thumb 点击浮标文字 坐标、当前值 |
| rightLabel | String? | - | 右侧标签 |
| sliderThemeData | TSliderThemeData? | - | 样式 |
| value | double | - | 默认值 |


### TRangeSlider
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| boxDecoration | Decoration? | - | 自定义盒子样式 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| leftLabel | String? | - | 左侧标签 |
| onChanged | ValueChanged<RangeValues>? | - | 滑动变化监听 |
| onChangeEnd | ValueChanged<RangeValues>? | - | 滑动结束监听 |
| onChangeStart | ValueChanged<RangeValues>? | - | 滑动开始监听 |
| onTap | Function(Position position, Offset offset, double value)? | - | Thumb 点击事件 位置、坐标、当前值 |
| onThumbTextTap | Function(Position position, Offset offset, double value)? | - | Thumb 点击浮标文字 位置、坐标、当前值 |
| rightLabel | String? | - | 右侧标签 |
| sliderThemeData | TSliderThemeData? | - | 样式 |
| value | RangeValues | - | 默认值 |


### Position
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| start | - |
| end | - |


  