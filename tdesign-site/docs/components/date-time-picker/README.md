---
title: DateTimePicker 时间选择器
description: 纯滚轮选择日期/时间，选中值通过 onChange 回调。
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

{{ flutter-example-group date-time-picker }}

## 主题配置

滚轮复用 [TPickerThemeData](/flutter/components/picker?tab=api#tpickerthemedata) 的 `height` 和 `itemCount`，通过 `ThemeData.extensions` 配置。日期时间选择器没有独立的 Theme 类。

{{ flutter-api date-time-picker }}
