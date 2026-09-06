# 实施方案

## 技术方案

- 默认多行间距改用 `spacer8`，块颜色改用 `bgColorSecondaryContainer`。
- 图片预设和组合示例使用 `radiusDefault`，文本块继续使用 `radiusSmall`，图文卡片继续使用 `radiusExtraLarge`。
- nullable Theme 数值仅在两端均显式配置时连续插值；一端未配置时在中点切换来源，不再产生 0 圆角或 0 间距。
- 公开 Demo 使用准确说明和“骨架屏类型 / 组件动效”分组，所有组合使用 TDesign token。

## 影响范围

| 范围 | 影响 |
| --- | --- |
| 组件 | 修正默认颜色、行距和图片圆角 |
| Theme | 修复 nullable 数值插值，增加非负约束 |
| Demo | 修正文案、分组与组合圆角/间距 |
| 测试 | 组件、Demo、动画帧、Golden、覆盖率与集中回归登记 |

## 验证策略

- 组件测试测量所有预设几何、token/Theme 覆盖、插值边界和动画生命周期。
- Demo 测试逐项验证公开矩阵，并确认两个动画实例在推进时间后产生不同绘制状态。
- 功能合理后生成固定 Linux 明暗主题 Golden 并立即无更新复验。
- Flutter 3.32.0 与 latest 分别运行功能测试和严格 analyze；最终在 Web Demo 观察两种动画。
