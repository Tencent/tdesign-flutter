# Popup 内容插槽收敛 - 验收记录

## 行为验收

- 未传 `headerBuilder` 的 bottom Popup 不占用头部空间。
- 未传 `closeBuilder` 的 center Popup 不显示关闭按钮。
- 显式传入的 `TPopupHeader` 正确布局可选取消按钮、标题和确认按钮。
- headerBuilder 或 closeBuilder 内调用 close 只关闭一次；headerBuilder 默认上报
  `custom`，显式传入时正确上报 `cancel` 或 `confirm`，closeBuilder 上报 `close`。
- top、left、right 的无效 builder 组合仍被校验拒绝。
- ActionSheet、Dialog 与公开 Popup Demo 无多余的 null 参数。

## 自动化验证

- Flutter 3.32.0：`flutter analyze --no-pub` 0 error / 0 warning；Popup 完整组件回归 169 项通过。
- Flutter latest 3.47.0：`flutter analyze --no-pub` 通过；核心 Popup 契约测试 72 项通过。
- Popup 生产源码覆盖率：`520/533 = 97.56%`。
- Popup Demo 结构与行为测试 4 项通过。
- Cascader、TreeSelect、DateTimePicker 的取消、确认和受控选择交互测试 11 项通过。
- Popup API 文档已重新生成；示例代码生成器 `--check` 与 `git diff --check` 通过。

## 视觉验证边界

- Popup Demo 已有 Flutter 3.32.0 Linux 明暗主题 Golden，本次不在 macOS 重录 Linux 基线。
- 下游页面 Golden 在 macOS 与 Linux 基线存在字体像素差异；交互用例已独立过滤并通过，不将本机差异作为代码失败或跨端像素一致证据。

## 结论

- [x] 已满足 spec.md 行为契约和验收标准。
