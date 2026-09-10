# 实施方案

## 技术方案

调整 Checkbox 行布局和分割线缩进；为禁用未选状态绘制独立填充与描边；让卡片内容按边框宽度派生内部 16dp 间距；同步 Demo 文案。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | Checkbox | 默认视觉和布局对齐 |
| 测试 | Checkbox Widget/Demo | 覆盖颜色、对齐和间距 |
| 示例 | Checkbox Demo | 标题和分组文案对齐 |
| 文档 | Spec | 记录视觉契约 |

## API 变化

- 无。

## 风险与取舍

- 默认视觉发生用户可感知变化，但不改变 API 或交互语义。

## 验证策略

- 单元测试：Checkbox 和 CheckboxGroup 聚焦测试。
- 集成或 Widget 测试：Checkbox Demo 结构与 Golden。
- 静态检查：`flutter analyze --fatal-infos`。
- 人工验收：Android 真机滚动核对完整页面。
