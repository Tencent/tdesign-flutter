# 实施方案

## 技术方案

调整 Checkbox 行布局和分割线缩进；根据实际文字排版在单行居中与多行顶部对齐之间切换；由组件绘制带 1.5dp 圆角的方形指示器；为禁用未选状态绘制独立填充与描边，并按字段保留组件 Theme 与显式 Material Theme 的覆盖优先级；让卡片内容按边框宽度派生内部 16dp 间距；同步 Demo 文案，并修正默认主题的移动端 Gy3/Gy4/Gy5/Gy11。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | Checkbox | 默认视觉和布局对齐 |
| 主题 | 默认 Gy3/Gy4/Gy5/Gy11 | 分别统一为 `#E7E7E7` / `#DCDCDC` / `#C5C5C5` / `#383838`，影响共享 Token 的默认视觉 |
| 测试 | Checkbox Widget/Demo | 覆盖颜色、对齐和间距 |
| Golden | Gy4 消费组件 | 仅更新 Flutter 3.32.0 Linux 实际发生预期色差的基线 |
| 示例 | Checkbox Demo | 标题和分组文案对齐 |
| 文档 | Spec | 记录视觉契约 |

## API 变化

- 无。

## 风险与取舍

- 默认视觉发生用户可感知变化，但不改变 API 或交互语义。
- Gy4 是共享 Token，需要用全量 Linux 视觉回归确认所有消费者，没有仅为消除失败而批量接受快照。
- 禁用未选从单色图标改为填充与描边分离后，必须继续兼容既有 `disableColor`，同时避免把 Flutter 自动默认主题误判为显式覆盖。

## 验证策略

- 单元测试：Checkbox 和 CheckboxGroup 聚焦测试。
- 集成或 Widget 测试：Checkbox Demo 结构与 Golden。
- 静态检查：`flutter analyze --fatal-infos`。
- 人工验收：Android 真机滚动核对完整页面。
