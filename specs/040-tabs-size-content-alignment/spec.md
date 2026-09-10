# Tabs 尺寸与内容区样式对齐

## 背景与目标

Tabs 公开 Demo 的内容区文字为默认黑色，且组件样式区缺少设计稿中的大小尺寸。本次补齐明确的 Flutter 尺寸契约和 Demo。

## 行为契约

- 新增 `TTabsBarSize.small` 与 `TTabsBarSize.large`，默认 small。
- small 使用 `fontBodyMedium`，large 使用 `fontBodyLarge`；组件高度和交互行为保持不变。
- 内容区 Demo 使用 `textColorPlaceholder` 表达灰色辅助内容。
- Theme 显式 labelStyle 仍优先于 size 默认字体 Token。

## 非目标

- 不复制旧版 `TTabSize` 的逐 Tab 尺寸入口，尺寸由 TabBar 统一持有。
- 不硬编码字号或颜色值。
