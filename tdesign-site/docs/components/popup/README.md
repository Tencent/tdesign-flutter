---
title: Popup 弹出层
description: 由其他控件触发，屏幕滑出或弹出一块自定义内容区域
spline: base
isComponent: true
---

## 代码演示

{{ flutter-example-group popup }}

{{ flutter-api popup }}

## FAQ

### 从 1.0.0 升级到 1.0.1 后，蒙层配置需要如何适配？

- `TPopupOverlayConfig` 改为 `final`：已有继承、`implements` 及相关 mock 需改用直接构造或工厂组合。这是源码不兼容变更；依赖动态 getter 的配置需按业务状态重新创建。
- 旧 `onClick` 构造参数和成员仍可用，但已废弃，推荐使用 `onTap`。非空 `onTap` 优先，否则使用 `onClick`，每次点击只通知一次。

将废弃提示视为错误的静态检查也需要适配。

### 为什么重新打开后配置没有变化？

`handle.open()` 沿用创建句柄时的 `options`，不会应用新配置。这是 1.0.0 已有行为。

更换配置需重新构造 `TPopupOptions`，通过 `TPopup.show()` 创建新会话。新会话不会自动关闭旧会话；替换时请先关闭旧会话，再按下一问处理保留内容和资源。

<div id="popup-session-reuse" style="position: relative; top: -128px"></div>

### 从 1.0.0 升级到 1.0.1 后，替换会话需要注意什么？

Popup 和 `TPickerPopup` 的 `destroyOnClose` 默认为 `false`，关闭后仍保留内容 State，所属 Navigator 卸载时释放。

- **复用原状态**：调用 `handle.open()`，沿用原配置。
- **创建新会话**：推荐使用独立的 GlobalKey 和 Controller，避免与旧内容冲突。
- **转交原有资源**：创建旧会话时设置 `destroyOnClose: true`，待内容卸载后再创建新会话。

`false` 时，`onClosed` 不代表内容已卸载。复用同一 GlobalKey 会触发重复 Key 诊断；共享 ScrollController 可能导致单位置访问失败。

Drawer 仍保持关闭后释放，不适用上述保留规则。
