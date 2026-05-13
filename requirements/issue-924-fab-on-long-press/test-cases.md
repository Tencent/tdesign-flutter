# 测试用例 — issue #924 TFab 长按事件

## TC-01：长按悬浮按钮应触发 onLongPress

- **前置条件**：渲染一个传入 `onLongPress` 的 `TFab`
- **操作**：对组件执行长按
- **期望**：`onLongPress` 回调被触发一次

## TC-02：点击不应误触发 onLongPress

- **前置条件**：渲染一个传入 `onLongPress` 的 `TFab`
- **操作**：对组件执行普通点击
- **期望**：`onLongPress` 回调不触发

## TC-03：onClick 与 onLongPress 可独立工作

- **前置条件**：渲染同时传入 `onClick` 与 `onLongPress` 的 `TFab`
- **操作**：
  1. 点击一次组件
  2. 长按一次组件
- **期望**：
  - 点击后仅 `onClick` 计数增加
  - 长按后仅 `onLongPress` 计数增加

## TC-04：示例页提供人工验收入口

- **前置条件**：打开 `TFab` 示例页
- **操作**：进入 `ExamplePage.test` 自动生成的“单元测试”区域，查看“长按事件”用例
- **期望**：页面可直接用于人工长按验收，且代码片段可展示

## TC-05：站点 API 文档补充 onLongPress

- **前置条件**：打开 `tdesign-site/src/fab/README.md`
- **操作**：检查 `TFab` API 表格
- **期望**：存在 `onLongPress | GestureLongPressCallback? | - | 长按事件` 这一行
