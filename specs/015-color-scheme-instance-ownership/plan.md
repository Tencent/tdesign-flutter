# 实施方案

## 技术方案

删除 `TTagThemeData.colorScheme` 与 `TPopoverThemeData.colorScheme` 及其传播逻辑。Tag 新增非空实例 `variant`，由枚举在内部派生既有 `isLight / isOutline` 绘制分支，并从 ThemeData 删除这两个公开布尔值。Popover 将 `dark / info / error` 等价重命名为 `defaultTheme / primary / danger`，把枚举迁移到 `t_popover_types.dart` 并保持包入口导出。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | Tag、SelectTag、Popover | 配色和 Tag 绘制形态只由实例持有 |
| Theme | TTagThemeData、TPopoverThemeData | 删除枚举型 `colorScheme` |
| 类型导出 | t_popover_types.dart、tdesign_flutter.dart | 调整类型定义归属，包入口不变 |
| 测试 | Tag、Popover Widget 测试 | 删除 Theme 选择器用例并保留实例回归 |
| 示例 | Tag、Popover Demo | 实例调用已显式传值，无结构变化 |
| 文档 | Dartdoc、Spec | 记录唯一状态源和迁移方式 |

## API 变化

- breaking：删除 `TTagThemeData.colorScheme`。
- breaking：删除 `TPopoverThemeData.colorScheme`。
- breaking：删除 `TTagThemeData.isLight / isOutline`，新增 `TTag.variant / TSelectTag.variant`。
- breaking：`TPopoverColorScheme.dark / info / error` 重命名为 `defaultTheme / primary / danger`。
- 保留 `TTag.colorScheme`、`TSelectTag.colorScheme`、`TPopover.showPopover.colorScheme`、`TPopoverWidget.colorScheme`。
- 保留 `TPopoverColorScheme` 的包入口导出。

## 风险与取舍

- 使用 Theme 子树批量设置 Tag 或 Popover 配色的调用方必须迁移为实例显式传参。
- 使用 Theme 子树设置 Tag 浅色或描边形态的调用方必须迁移到实例 `variant`。
- 不保留 deprecated Theme 别名，避免继续维护两个状态源。
- Popover 只重命名配色，不增加没有独立组合语义的 `status / variant`。
- 具体颜色和完整样式仍可通过 ThemeData 覆盖，不影响主题定制能力。

## 验证策略

- 单元测试：ThemeData copyWith、merge、lerp 不包含配色选择器。
- Widget 测试：Tag、SelectTag、Popover 的实例配色和默认值继续渲染。
- 静态检查：针对变更文件格式化并运行 `flutter analyze`。
- 人工验收：确认 Demo 无需改变结构，公开实例调用保持可编译。
