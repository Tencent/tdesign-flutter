# 实施方案

## 技术方案

新增 `TAvatarShape` 作为主形状 API，保留 `TAvatarVariant` 兼容层；组件内部统一解析实例、Theme 和默认值。通过 `DefaultTextStyle` 与 `IconTheme` 为任意字符/图标 child 提供可继承样式。头像组保持接收任意 Widget，仅增加布局所需的边长和方向感知绘制层级参数，不接管成员数据；成员为 `TAvatar` 时由成员形状决定外框，其他 Widget 使用 Theme 或圆形默认值。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `lib/src/components/avatar/` | 新增形状、实例样式和组布局能力 |
| 测试 | Avatar 组件与 Demo 测试 | 覆盖优先级、兼容入口、层叠和视觉状态 |
| 示例 | `example/lib/page/t_avatar_page.dart` | 对齐公开展示结构与规格 |
| 文档 | 生成 API、代码片段与本 Spec | 同步公开契约和验收证据 |

## API 变化

- 新增 `TAvatar.shape`、`backgroundColor`、`foregroundColor`、`textStyle`。
- 新增 `TAvatarGroup.dimension`、`cascading`；不增加与成员 `shape` 重复且容易产生双重形状的组级 API。
- 新增 `TAvatarShape`、`TAvatarGroupCascading`。
- `TAvatar.variant` 与 `TAvatarThemeData.variant` 标记弃用但继续兼容。

## 风险与取舍

- 保留旧 API 和既有右侧成员在上层的默认行为，避免立即 breaking；纯展示 Demo 显式选择左侧在上。同时禁止新旧形状参数并用，消除优先级歧义。
- 头像组不强制 children 类型，维持 Flutter 组合能力；组会安全裁剪成员外框，但不会覆盖 `TAvatar` 自身的形状选择。
- 层叠枚举使用 `startUp` / `endUp`，与 `PositionedDirectional` 的布局方向保持同一语义。
- Theme 数值从空值过渡到显式值时按组件有效默认值插值；运行时 token 颜色无法脱离 `BuildContext` 求值，单边配置采用离散切换以避免透明色闪烁。
- Golden 仅在固定 Linux + Flutter 3.32 环境更新，避免宿主差异污染基线。

## 验证策略

- 单元测试：尺寸、形状、主题优先级、文字样式、图片回退、点击、截断和层叠。
- 集成或 Widget 测试：公开 Demo 结构、数量、头像组规格和明暗 Golden。
- 静态检查：双 Flutter 版本 `flutter analyze`、生成物 check、集中 runner 自测。
- 人工验收：逐项核对 Figma 类型、数量、间距、色彩、图标、字号与字重。
