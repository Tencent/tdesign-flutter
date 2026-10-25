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

1.0.1 将 `TPopupOverlayConfig` 改为 `final`，源码不兼容影响库外继承、实现及相关 mock；普通旧 `onClick` 调用仍可编译，并提示废弃。

- 配置类改为 `final`，库外不能再 `extends` 或 `implements`；已有业务子类和相关 mock 需改为直接构造或通过工厂组合。
- `onClick` 构造参数及成员保留并标记废弃，旧调用仍可编译使用；推荐改用 `onTap`。两者同时传入时，非空的 `onTap` 优先，只触发一次；旧 `onClick` 成员返回实际生效的回调。

旧入口会产生废弃提示；将提示视为错误的静态检查仍需适配。

例如，可将 `TPopupOverlayConfig(onClick: callback)` 改为 `TPopupOverlayConfig(onTap: callback)`。需要封装业务配置时可使用工厂函数：

```dart
TPopupOverlayConfig createOverlay({
  required bool showMask,
  VoidCallback? onMaskTap,
}) {
  return TPopupOverlayConfig(
    showOverlay: showMask,
    onTap: onMaskTap,
  );
}
```

Dart 的 `implements` 要求实现所有实例成员；改用配置组合可避免新增可选配置成员时，业务实现被动补齐。旧动态 getter 与配置快照不一定等价，需按业务状态重新创建配置；不能仅新增 `onTap` getter 或用 `noSuchMethod` 绕过 `final`。

其他蒙层配置的默认值、回调时机和关闭条件保持不变，Controller 绑定规则不变。

### 为什么重新打开后配置没有变化？

这是 1.0.0 已有行为，并非 1.0.1 新增限制：`handle.open()` 沿用创建句柄时的 `options`，不会应用新配置。

更换配置需重新构造 `TPopupOptions`，通过 `TPopup.show()` 创建新会话。新会话不会自动关闭旧会话；替换时请先关闭旧会话，并按下节处理保留的内容及资源。

沿用配置不等于保留内容 State，状态保留仍由对应生命周期规则决定。


### 从 1.0.0 升级到 1.0.1 后，替换会话需要注意什么？

以下同样适用于 `TPickerPopup`。1.0.1 中，`destroyOnClose: false`（默认）关闭后仍保留内容 State，所属 Navigator 卸载时释放；关闭不再表示原 `GlobalKey` 或 Controller 已可转交给新会话。

- **重开原会话**：使用 `handle.open()`，复用原 State、GlobalKey 和 Controller 绑定；配置不变。
- **更换配置、创建新会话**：默认保留旧内容时，请使用独立的 GlobalKey 和 Controller。复用原 GlobalKey 会产生重复 Key 诊断；共享 ScrollController 可能同时绑定多个滚动位置，访问单一 `position` 时失败。
- **需要转交同一资源**：创建旧会话时显式设置 `destroyOnClose: true`，确认旧内容已卸载后再 `show()`。已关闭的 false 会话仍保留内容，不能通过再次 `close()` 将其销毁。

false 时，`onClosed` 不代表内容已卸载，不要据此释放仍被内容使用的业务 Controller。Controller 的所有权和绑定规则未改，是否支持多绑定仍以各 Controller 原有规则为准，解绑时机随 State 保留延后；根 Navigator 长期存在时，已丢弃句柄的内容也可能长期保留。

Popup/Picker 设置 true 时，被不透明路由遮挡不再释放内容，关闭时销毁。Drawer 保持 1.0.0 的关闭释放和遮挡规则，不适用上述关闭保留变化。
