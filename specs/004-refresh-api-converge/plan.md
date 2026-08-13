# 实施方案

## 技术方案

1. **收敛 `TRefreshHeader` 构造参数**：删除 spring / 二楼 / 无限刷新 / triggerWhen* 等
   高级透传参数，super 构造只传保留参数。`clamping` 不再暴露，默认沿用 `float ?? false`，
   保持与原默认一致。断言逻辑不变。
2. **补全 `TRefreshThemeData`**：新增 `loadingIconColor` / `loadingTextColor`，补齐
   `merge` / `copyWith` / `lerp`；`_buildLoading()` 改为"主题优先、全局回退"的取色链路；
   删除冗余 `lerpDouble`。
3. **示例修复**：`onRefresh` 改为返回 `Future` 的 async 写法。
4. **同步更新**：单元 / Widget 测试、示例代码 txt、API 文档、站点文档。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `t_refresh_header.dart` | 构造参数收敛（breaking）；loading 取色链路变化 |
| 组件 | `t_refresh_theme_data.dart` | 新增两个字段、删除 `lerpDouble` |
| 测试 | `t_refresh_test.dart` | 适配参数收敛与新增主题字段 |
| 示例 | `t_refresh_page.dart`、`refresh._buildRefresh.txt` | 修复 `onRefresh` |
| 文档 | `pull-down-refresh_api.md`、站点 README | 收敛 API 表、修复示例 |
| Spec | `specs/004-refresh-api-converge/` | 新增 |

## API 变化

- `TRefreshHeader`：删除 `clamping`、`enableInfiniteRefresh`、`infiniteOffset`、
  `infiniteHitOver`、`spring`、`horizontalSpring`、`readySpringBuilder`、
  `horizontalReadySpringBuilder`、`springRebound`、`frictionFactor`、
  `horizontalFrictionFactor`、`safeArea`、`hitOver`、`secondary*`、
  `notifyWhenInvisible`、`listenable`、`triggerWhen*`、`maxOverOffset`（**breaking**）。
- `TRefreshThemeData`：新增 `loadingIconColor`、`loadingTextColor`；删除 `lerpDouble`。

## 风险与取舍

- **Breaking change**：移除的 20+ 个参数对使用高级能力的调用方不兼容。取舍：这些参数
  `easy_refresh` 原生 `Header` 全部可用，TDesign 收敛暴露面、降低认知负担，符合本 Issue
  诉求。迁移方式为改用 `easy_refresh` 原生 `Header` 包装。
- loading 颜色默认值：`loadingIconColor` / `loadingTextColor` 为空时回退全局品牌色 /
  占位文案色，保持默认外观不变，避免视觉回归。

## 验证策略

- 单元测试：主题 merge / copyWith / lerp；构造默认值与断言。
- Widget 测试：默认渲染、无 onRefresh 渲染、主题视觉默认值、实例优先于主题。
- 静态检查：`dart analyze`。
- 测试运行：`flutter test`（tdesign-component 下）。
- 人工验收：在示例页下拉刷新，确认计数与"刷新完成"动画同步。
