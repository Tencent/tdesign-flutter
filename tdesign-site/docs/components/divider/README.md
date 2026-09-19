---
title: Divider 分割线
description: 用于分割、组织、细化有一定逻辑的组织元素内容和页面结构。
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

以下示例代码直接来自 Example App 的 `@ExampleCode(group: "divider")` 生成资产，Web 文档不维护代码副本。

{{ flutter-example-group divider }}

## API
### TDivider
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| alignment | TextAlignment | TextAlignment.center | 文字位置 |
| color | Color? | - | 线条颜色 |
| direction | Axis | Axis.horizontal | 方向，竖直虚线必须传 |
| gapPadding | EdgeInsetsGeometry? | - | 线条和中间文本之间的填充 |
| height | double | 0.5 | 高度，横向线条使用 |
| hideLine | bool | false | 隐藏线条，使用纯文本分割 |
| isDashed | bool | false | 是否为虚线 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| margin | EdgeInsetsGeometry? | - | 外部填充 |
| text | String? | - | 文本字符串，使用默认样式 |
| textStyle | TextStyle? | - | 自定义文本样式 |
| widget | Widget? | - | 中间控件，可自定义样式 |
| width | double? | - | 宽度，需要竖向线条时使用 |


### TextAlignment
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | - |
| center | - |
| right | - |


  