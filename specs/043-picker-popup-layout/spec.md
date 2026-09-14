# Picker 弹层布局契约

## 背景

Figma 中通用底部 Popup 高 240px，Picker 弹层则是 58px 标准头部加 200px 滚轮，总高 258px。既有 Picker 和 DateTimePicker Demo 各自手写高度计算，Form Demo 遗漏后落到 Popup 的 240px 默认值，导致滚轮被压缩为 182px。

## 目标

- 由 Picker 组件域统一管理标准弹层的高度契约。
- 默认弹层保持 258px，滚轮完整保持 200px。
- 自定义 `TPickerThemeData.height` 时，弹层总高同步变为滚轮高度加 58px。
- Picker、DateTimePicker 和 Form 使用同一弹层入口，不再在 Demo 中重复尺寸计算。

## 范围与非目标

- 新增 `TPickerPopup.show`，仅封装 Picker 专用的 Popup 路由与尺寸。
- `TPicker` 和 `TDateTimePicker` 仍是纯滚轮面板，不内置业务状态或确认/取消行为。
- 不修改 `TPopup` 通用默认高度 240px。
- 不改变 Picker 的受控值、滚动和主题契约。

## 验收标准

- 默认主题下 Popup 总高 258px，头部 58px，滚轮 200px。
- 主题滚轮高度为 240px 时 Popup 总高 298px。
- 三个 Demo 调用链均使用 `TPickerPopup.show`。
- Picker 组件回归、三个 Demo 功能测试、严格 analyze 和必要的 Golden 比对通过。
