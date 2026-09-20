---
title: BackTop 返回顶部
description: 用于当页面过长往下滑动时，帮助用户快速回到页面顶部。
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

{{ flutter-example-group backtop }}

## API
### TBackTop
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| controller | ScrollController? | - | 页面滚动的控制器 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onClick | VoidCallback? | - | 按钮点击事件 |
| showText | bool | false | 是否展示文字 |
| style | TBackTopStyle | TBackTopStyle.circle | 样式，圆形和半圆 |
| theme | TBackTopTheme | TBackTopTheme.light | 主题 |


### TBackTopTheme
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| light | - |
| dark | - |


### TBackTopStyle
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | - |
| halfCircle | - |


  