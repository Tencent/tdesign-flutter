# 实施方案

## 技术方案

- 将 `TTabsBarVariant.filled/capsule/card` 一次性收敛为 `line/tag/card`，避免旧名称继续错误表达结构。
- 在 `TTabsBar` 解析默认视觉：Line 创建默认 `TTabsBarIndicator`，Tag/Card 使用空指示器；具体颜色和文字样式只从局部组件 Theme 与 TDesign Token 解析，底层 Material 组件不再回读 `TabBarThemeData` 等视觉默认值。
- 内部水平标签栏继续复用 Flutter `TabController` 动画和滚动模型；移除统一 `Opacity`，改为对禁用标签注入 `DefaultTextStyle` 与 `IconTheme`。
- `TTabsBarView` 改为无状态薄包装；Example 以每个示例局部 `DefaultTabController` 管理状态，内容区的 Bar 与 View 共享同一继承控制器。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `lib/src/components/tabs/` | 形态命名、默认视觉、禁用态与控制器用法 |
| 测试 | `test/components/tabs/`、回归调度器 | 行为、覆盖率和 Golden |
| 示例 | `example/lib/page/t_tabs_page.dart`、Demo 测试 | 去手工样式和冗余控制器，补齐 Line/Tag/Card |
| 文档 | dartdoc、Spec、生成 API/示例资产 | 记录 breaking 迁移和默认行为 |

## API 变化

- Breaking：`TTabsBarVariant.filled` 迁移为 `TTabsBarVariant.line`。
- Breaking：`TTabsBarVariant.capsule` 迁移为 `TTabsBarVariant.tag`。
- Breaking：`TTabsBarThemeData.selectedBgColor` 迁移为 `selectedTagBackgroundColor`。
- Breaking：`TTabsBarThemeData.unSelectedBgColor` 迁移为 `tagBackgroundColor`。
- 新增可选的 `TTabsBarThemeData.disabledLabelStyle`，不改变未配置时的 Token 默认值。
- 不新增 `TTabsBarSize`。
- 保留 `TabController? controller`；未传时继续使用 `DefaultTabController`。

## 风险与取舍

- 默认 Line 从无指示器变为 TDesign 指示器，是预期的用户可感知默认行为变化。
- 禁用态不再整体透明，显式指定颜色的自定义 `child` 仍被视为调用方完整样式逃逸，不强行改写。
- Material 仍负责标准 Controller、动画和手势基础设施，但不再成为 Tabs 的视觉 Theme 来源；需要子树级视觉定制时统一使用 `TTabsBarThemeData`。
- 显式 Controller 仍是复杂联动的必要能力；只简化 Example，不删除标准 Flutter 能力。
- 暂不增加尺寸 API，避免为没有明确第三档规范的视觉规格创造公共契约。

## 验证策略

- 单元测试：形态、默认指示器、主题覆盖、禁用文字/图标、点击与控制器同步。
- Demo 测试：分组、顺序、数量、关键参数，以及所有示例使用继承控制器。
- 覆盖率：Tabs 全部手写生产源码 `LH/LF >= 95%`。
- 静态检查：Flutter 3.32.0 与 latest `flutter analyze`。
- 视觉验收：Flutter 3.32.0 Linux light/dark Golden；真机截图另行记录。
