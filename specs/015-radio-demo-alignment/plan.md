# 实施方案

## 技术方案

在现有 `_TRadioIndicatorPainter` 中增加样式分支，复用既有状态色解析和 `TRadioSize` 尺寸，不引入 Demo 私有绘制。Group 仅透传单项已存在的文本能力与新增图标样式。Demo 使用 `cardMode`、Theme extension 和现有布局能力组合公开示例。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `lib/src/components/radio/t_radio.dart` | 新增图标样式枚举与 Group 透传参数 |
| 测试 | Radio component/example tests | 覆盖图标状态、透传、生命周期和 Golden |
| 示例 | `example/lib/page/t_radio_page.dart` | 对齐小程序公开 Demo |
| 文档 | dartdoc、Spec、生成示例片段 | 说明新增 API 和行为契约 |

## API 变化

- 新增 `TRadioIconType`：`dot`、`check`、`fill`。
- `TRadio` 新增 `iconType`，默认 `TRadioIconType.fill`。
- `TRadioGroup` 新增 `iconType`、`titleMaxLines`、`subTitleMaxLines`，默认值保持现状。

## 风险与取舍

- `iconType` 为可选参数，但默认视觉由圆点调整为小程序的实心勾选，属于用户可感知的默认行为变化，需要按 breaking change 记录。
- 横向示例仅通过局部 Radio Theme token 调整内边距，不为单个 Demo 扩展布局 API。
- 卡片示例复用 `cardMode`，不保留重复的 Demo 私有绘制。

## 验证策略

- 单元测试：指示器样式、状态色、尺寸、构建器优先级、Group 透传。
- 集成或 Widget 测试：Demo 交互、调试模块隔离、页面 Golden。
- 静态检查：Flutter 3.32.0 与 latest `flutter analyze` 零告警。
- 人工验收：Android 真机逐段截图，与小程序 375 宽公开模拟器截图对照。
