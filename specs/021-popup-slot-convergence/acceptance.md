# Popup 内容插槽收敛 - 验收记录

## 行为验收

- 未传 `headerBuilder` 的 bottom Popup 不占用头部空间。
- 未传 `closeBuilder` 的 center Popup 不显示关闭按钮。
- 显式传入的 `TPopupHeader` 正确布局可选取消按钮、标题和确认按钮。
- headerBuilder 或 closeBuilder 内调用 close 只关闭一次；headerBuilder 上报
  `custom`，closeBuilder 上报 `close`。
- 取消或确认业务逻辑由 `TPopupHeader` 按钮自身回调处理，不依赖 Popup 关闭触发枚举。
- top、left、right 的无效 builder 组合仍被校验拒绝。
- ActionSheet、Dialog 与公开 Popup Demo 无多余的 null 参数。

## 自动化验证

- Flutter 3.32.0：`flutter analyze --fatal-infos` 0 error / 0 warning；本轮 Popup 聚焦回归 101 项及 Options 契约回归 11 项通过。
- Flutter latest 3.47.0：`flutter analyze --fatal-infos` 0 error / 0 warning；本轮 Popup 聚焦回归 101 项通过。
- Popup 生产源码覆盖率：`520/533 = 97.56%`。
- Popup Demo 结构与行为测试 4 项通过。
- Popup Demo、Form、Cascader、TreeSelect、DateTimePicker 的结构、取消、确认和受控选择交互测试 16 项通过。
- Popup API 文档已重新生成；示例代码生成器 `--check` 与 `git diff --check` 通过。

## 视觉验证边界

- Popup Demo 已有 Flutter 3.32.0 Linux 明暗主题 Golden，本次不在 macOS 重录 Linux 基线。
- 下游页面 Golden 在 macOS 与 Linux 基线存在字体像素差异；本轮混跑差异为 0.51%–5.10%，交互用例已独立过滤并通过，不将本机差异作为代码失败或跨端像素一致证据。

## 结论

- [x] 已满足 spec.md 行为契约和验收标准。
