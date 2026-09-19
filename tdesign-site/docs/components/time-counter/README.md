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

以下示例代码直接来自 Example App 的 `@ExampleCode(group: "timeCounter")` 生成资产，Web 文档不维护代码副本。

{{ flutter-example-group timeCounter }}

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
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| millisecond | bool | false | 是否开启毫秒级渲染 |
| onChange | Function(int time)? | - | 时间变化时触发回调 |
| onFinish | VoidCallback? | - | 计时结束时触发回调 |
| size | TTimeCounterSize | TTimeCounterSize.medium | 尺寸 |
| splitWithUnit | bool | false | 使用时间单位分割 |
| style | TTimeCounterStyle? | - | 自定义样式，有则优先用它，没有则根据size和theme选取 |
| theme | TTimeCounterTheme | TTimeCounterTheme.defaultTheme | 风格 |
| time | int | - | 必需；计时时长，单位毫秒 |


### TTimeCounterController
#### 简介
倒计时组件控制器，可控制开始(`start()`)/暂停(`pause()`)/继续(`resume()`)/重置(`reset([int? time])`)

### TTimeCounterStyle
#### 简介
计时组件样式

#### 工厂构造方法

##### TTimeCounterStyle.generateStyle

生成默认样式

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| size | TTimeCounterSize? | - | - |
| theme | TTimeCounterTheme? | - | - |
| splitWithUnit | bool? | - | - |

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


### TTimeCounterDirection
#### 简介
计时组件计时方向
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| down | 倒计时 |
| up | 正向计时 |


### TTimeCounterSize
#### 简介
计时组件尺寸
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | 小 |
| medium | 中等 |
| large | 大 |


### TTimeCounterTheme
#### 简介
计时组件风格
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| defaultTheme | 默认 |
| round | 圆形 |
| square | 方形 |


### TTimeCounterStatus
#### 简介
计时组件控制器转态
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| start | 开始 |
| pause | 暂停 |
| resume | 继续 |
| reset | 重置 |
| idle | 空，默认值 |


  