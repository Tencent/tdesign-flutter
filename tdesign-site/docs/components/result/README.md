---
title: Result 结果
description: 反馈结果状态。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[查看完整示例](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/page/t_result_page.dart)

### 基础结果

通过 `status` 设置成功、失败、警告或默认信息状态。

```dart
const TResult(
  status: TResultStatus.success,
  title: '成功状态',
)
```

### 带描述结果

```dart
const TResult(
  status: TResultStatus.error,
  title: '失败状态',
  description: '描述文字',
)
```

### 自定义结果

传入 `icon` 时将完整替换状态对应的默认图标，图标尺寸和样式由调用方控制。

```dart
TResult(
  icon: Image.asset('assets/img/illustration.png', height: 80),
  title: '自定义结果',
  description: '描述文字',
)
```

## API

### TResult

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| description | String? | - | 描述文本；为空时不占布局空间 |
| icon | Widget? | - | 自定义图标；传入后替换默认状态图标 |
| key | Key? | - | 组件标识 |
| status | TResultStatus | TResultStatus.info | 当前结果状态，决定默认图标、颜色和无障碍语义 |
| title | String | '' | 标题文本；为空时不占布局空间 |

### TResultStatus

| 名称 | 说明 |
| --- | --- |
| info | 默认信息状态 |
| success | 成功结果状态 |
| warning | 警告结果状态 |
| error | 错误结果状态 |
