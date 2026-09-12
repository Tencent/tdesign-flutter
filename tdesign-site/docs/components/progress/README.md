---
title: Progress 进度条
description: 用于展示任务当前的进度。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[查看完整 Demo 源码](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_progress_page.dart)

### 组件类型

```dart
Column(
  children: [
    TProgress(variant: TProgressVariant.linear, value: 0.8),
    TProgress(variant: TProgressVariant.plump, value: 0.8),
    TProgress(variant: TProgressVariant.circular, value: 0.3),
    TProgress(variant: TProgressVariant.microCircular, value: 0.3),
    TProgress(
      variant: TProgressVariant.button,
      value: 0,
      label: const Text('开始'),
      semanticsLabel: '上传进度',
      onTap: () {},
    ),
    TProgress(
      variant: TProgressVariant.microButton,
      value: 0.3,
      label: const Icon(TIcons.play),
      onTap: () {},
    ),
  ],
)
```

`linear` 固定为标签外显，`plump` 固定为标签内显；只读微型环形与可交互微型按钮分别使用 `microCircular`、`microButton`。

### 组件状态与渐变

```dart
Column(
  children: [
    TProgress(variant: TProgressVariant.linear, value: 0.8),
    TProgress(
      variant: TProgressVariant.linear,
      value: 0.8,
      status: TProgressStatus.warning,
    ),
    TProgress(
      variant: TProgressVariant.plump,
      value: 0.8,
      status: TProgressStatus.error,
    ),
    TProgress(
      variant: TProgressVariant.circular,
      value: 1,
      status: TProgressStatus.success,
    ),
    TProgress(
      variant: TProgressVariant.linear,
      value: 0.8,
      gradient: const LinearGradient(
        colors: [Color(0xFF0052D9), Color(0xFF00A870)],
      ),
    ),
  ],
)
```

## API

### TProgress

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| variant | TProgressVariant | 必填 | 进度条形态 |
| value | double? | - | 进度值，限制在 0～1；`null` 表示不确定进度 |
| status | TProgressStatus | `normal` | 任务状态，决定默认颜色与状态图标 |
| label | Widget? | - | 自定义标签；未指定时按形态和状态生成默认标签 |
| gradient | LinearGradient? | - | 线性填充渐变，仅支持 `linear`、`plump`、`button` |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称 |
| semanticsValue | String? | - | 辅助技术播报的进度值 |
| onTap | VoidCallback? | - | `button`、`microButton` 的点击回调 |
| onLongPress | VoidCallback? | - | `button`、`microButton` 的长按回调 |

### TProgressVariant

| 名称 | 说明 |
| --- | --- |
| linear | 标签外显的线性进度条 |
| plump | 标签内显的胶囊进度条 |
| circular | 环形进度条 |
| microCircular | 紧凑、只读的环形进度条 |
| button | 按钮外观的线性进度条 |
| microButton | 带按钮语义的微型环形进度操作 |

### TProgressStatus

| 名称 | 说明 |
| --- | --- |
| normal | 常规进行中状态 |
| warning | 警告状态 |
| error | 错误状态 |
| success | 成功状态 |

### TProgressThemeData

组件 Theme 可配置颜色、轨道色、粗细、圆角、环形半径和动画参数。实例 `gradient` 优先于 Theme 与状态默认色；形态语义不能由 Theme 改写。
