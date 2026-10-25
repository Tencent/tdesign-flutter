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

### 1.0.0 → 1.0.1 升级需要适配什么？

- `TPopupOverlayConfig` 改为 `final`：原继承、`implements` 和相关 mock 需改用构造或工厂组合；动态配置需重新创建。

<div id="popup-session-reuse" style="position: relative; top: -128px"></div>

### 替换会话时如何避免资源冲突？

- **复用状态**：默认 false 下，同一句柄在同一 Navigator 内调用 `open()`。
- **创建新会话**：使用独立 GlobalKey/Controller；转交原资源时，旧会话须设置 `destroyOnClose: true`，并等待内容卸载。
- **`destroyOnClose: false`（默认）**：关闭后内容保留至 Navigator 卸载，丢弃句柄不释放，`onClosed` 不代表已卸载；定时器和订阅需业务管理。
- **`destroyOnClose: true`**：关闭后销毁；被不透明路由遮挡时仍保留，与 1.0.0 不同。

Drawer 保留原规则；ActionSheet 的参数限制见[其 FAQ](/flutter/components/action-sheet?tab=api#faq)。
