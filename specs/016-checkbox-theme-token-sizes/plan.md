# 实施方案

## 技术方案

使用现有 TDesign spacer、字体和行高 token 组合现有默认尺寸：48、64 直接读取对应 spacer；56 由 48 + 8 组合；20、28 由 16/24 + 4 组合。卡片高度由标题/副标题行高、4dp 文案间距及上下 16dp 内边距计算。卡片边框宽度和角标圆角由 `spacer4` 派生；角标使用 24dp 与 24 + 4dp token，内部图标和偏移使用相对于角标尺寸的几何比例。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `t_check_box.dart` | 块高、指示器和卡片高度改为 token 计算 |
| 共享布局 | `t_selection_card.dart` | 卡片组高度和角标尺寸改为 token 计算 |
| 测试 | Checkbox component tests | 覆盖默认值与自定义 token 路径 |

## API 变化

无公开 API 变化。

## 风险与取舍

- 默认 token 下计算结果必须与既有直接数值完全一致，避免 Golden 变化。
- 自定义 spacer/font token 后 Checkbox 尺寸会随主题变化，这是修复目的；既有未自定义主题的用户无感。
- 路径曲线、画笔比例等纯几何常量保留在绘制实现中。

## 验证策略

- Widget 测试验证默认尺寸及自定义 token 后的实际布局尺寸。
- Flutter 3.32.0 与 latest 运行 Checkbox/Group 测试和严格 analyze。
- Flutter 3.32.0 Linux 运行 Checkbox light/dark Golden，不更新基线时应直接通过。
