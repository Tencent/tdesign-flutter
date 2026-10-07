---
title: Popup 弹出层
description: 由其他控件触发，屏幕滑出或弹出一块自定义内容区域
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

{{ flutter-example-group popup }}

{{ flutter-api popup }}

## 如何创建
| 场景 | 推荐用法 |
|------|----------|
| 弹出方向已知 | `TPopupOptions.bottom`、`TPopupOptions.center`、`TPopupOptions.top`、`TPopupOptions.left`、`TPopupOptions.right` |
| 方向由变量决定 | 默认构造并设置 `placement`；传错字段会在 `TPopup.show` / `TPopupHandle.open` 时抛 `FlutterError` |
命名工厂只暴露当前方向生效的字段（例如 `TPopupOptions.bottom` 无 `width` 参数）。
## 字段与 `TPopupPlacement`
| `TPopupPlacement` | 头部 / 关闭区 | 尺寸 |
|-------------------|-------------|------|
| `TPopupPlacement.bottom` | `headerBuilder` | `height`、`inset` |
| `TPopupPlacement.center` | `closeBuilder` | `width`、`height` |
| `TPopupPlacement.top` | — | `height`、`inset` |
| `TPopupPlacement.left`、`TPopupPlacement.right` | — | `width`、`inset` |
`headerBuilder` 与 `closeBuilder` 默认均为 `null`，基础 Popup 只渲染
`child`。显式提供 builder 时才会渲染相应区域，builder 可调用 `close`
关闭浮层。
生命周期回调见 `onOpened`、`onClosed`、`onVisibleChange`；
蒙层行为见 `overlay`（`TPopupOverlayConfig`）。
