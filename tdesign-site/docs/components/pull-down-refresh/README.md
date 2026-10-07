---
title: PullDownRefresh 下拉刷新
description: 用于快速刷新页面信息，刷新可以是整页刷新也可以是页面的局部刷新。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

通过统一入口引入 TDesign Flutter 组件：

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

{{ flutter-example-group PullDownRefresh }}

## 主题配置

默认刷新头的背景及提示文字使用 [TThemeData](/flutter/components/theme?tab=api#tthemedata) 的全局 Token。刷新中复用 [TLoadingThemeData](/flutter/components/loading?tab=api#tloadingthemedata)，布局固定为横向；未设置 `textColor` 时使用禁用文字色，其余 Loading 主题配置继续继承。

{{ flutter-api pull-down-refresh }}
