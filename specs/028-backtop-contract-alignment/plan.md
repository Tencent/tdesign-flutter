# 实施方案

## 技术方案

- 保留语义明确的 `shape` 实例参数并改为非空默认值，删除 Theme 中重复的 shape；新增实例级 `TBackTopColorScheme` 表达浅色/深色预设。
- 将显隐阈值收回实例并设为小程序公开契约的 200；通过首次帧后同步解决 Controller 尚未挂载时错误可见的问题。
- 把 `onPressed` 改为完成通知：点击能力由 `controller` 或回调任一来源决定，Controller 动画完成后再通知。
- 将 Figma 尺寸、间距、边框和文字样式集中到 `TBackTopThemeData`，默认颜色从 TDesign 语义 Token 解析。
- Example 使用两个公开分组项同屏展示 8 个状态，并让页面悬浮实例绑定同一 ScrollController 验证真实回顶。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `lib/src/components/backtop/` | 状态所有权、深色预设、显隐与点击语义、视觉字段 |
| 测试 | `test/components/backtop/`、集中式清单 | 行为、覆盖率、Theme 与导航矩阵 Golden |
| 示例 | `example/lib/page/t_backtop_page.dart`、Demo 测试 | 8 状态矩阵、真实回顶、light/dark Golden |
| 文档 | dartdoc、Spec、生成 API/示例资产 | breaking 迁移与默认行为 |

## API 变化

- Breaking：`shape` 从可空并可由 Theme 回退，改为非空、默认 `TBackTopShape.circle`。
- Breaking：`visibilityOffset` 从可空并可由 Theme 回退，改为非空、默认 `200`。
- Breaking：删除 `TBackTopThemeData.shape` 与 `defaultVisibilityOffset`，避免 Theme 保存结构和行为状态。
- Breaking：`onPressed == null` 不再代表视觉禁用；仅传 Controller 时仍可回顶。
- Feature：新增实例级 `TBackTopColorScheme.light/dark`。
- Feature：`TBackTopThemeData` 新增尺寸、间距、边框和文字样式字段。

## 风险与取舍

- 默认绑定 Controller 后会在 200 前隐藏，属于与公开上游契约一致的用户可见默认行为变化。
- 不把小程序四个 `theme` 字符串合成一个枚举；Flutter 拆成独立 shape 与 colorScheme，四组组合均有明确设计实例。
- 不新增 `disabled`；没有动作来源时只移除点击语义，不制造设计中不存在的透明禁用态。
- `showText` 保留为标准文案状态，不新增与其重复的 String/Widget 文案入口；完整内容自定义没有本次 Figma 或公开 Demo 证据。

## 验证策略

- 单元测试：视觉解析、尺寸、点击完成顺序、防抖、Controller 切换和首次挂载显隐。
- Demo 测试：完整滚动页面中的 8 个实例、分组顺序、关键参数和真实点击回顶。
- 覆盖率：BackTop 手写生产源码 `LH/LF >= 95%`。
- 静态检查：Flutter 3.32.0 与 latest 定向 analyze。
- 视觉验收：Flutter 3.32.0 Linux Demo light/dark Golden 与共享导航矩阵。
