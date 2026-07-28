# 测试用例 — issue #924 [TDFab] 暴露 onLongPress 方法

## TC-01

- **前置条件**：使用 `TTheme` + `MaterialApp` 包裹 `TFab`，并设置非空的 `onLongPress` 回调。
- **操作**：对 `TFab` 执行 `longPress` 手势。
- **期望**：`onLongPress` 被调用一次。

## TC-02

- **前置条件**：同一 `TFab` 上同时设置 `onClick` 与 `onLongPress`。
- **操作**：先 `tap`，再 `longPress`。
- **期望**：单击只触发 `onClick`，不触发 `onLongPress`；长按触发 `onLongPress`。

## TC-03

- **前置条件**：运行示例应用，进入「Fab」示例页；打开「单元测试」折叠区，或进入主内容区「交互」模块。
- **操作**：长按展示「长按」文案的悬浮按钮。
- **期望**：出现内容为「已长按」的 `SnackBar`（人工走查）。
