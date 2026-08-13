# TRefreshHeader 暴露面收敛与示例修复

## 背景

`TRefreshHeader` 继承 `easy_refresh` 的 `Header`，但当前构造函数透传了 30+ 个参数
（spring / friction / secondary 二楼 / infinite 无限刷新 / triggerWhen* 等）。这些参数
绝大多数是 `easy_refresh` 原生 `Header` 能力，TDesign 只是原样透传，对普通用户形成
严重认知负担，也导致 API 文档冗长。

同时，示例代码 `t_refresh_page.dart` 中 `onRefresh` 回调没有返回 `Future`，导致
`easy_refresh` 认为刷新立即成功，出现"弹窗已完成、刷新次数却延迟更新"的体验问题。

此外，`TRefreshThemeData` 只暴露了 `loadingIcon` 和 `backgroundColor`，loading 的
图标颜色 / 文案颜色仍硬编码从全局 theme 取色，用户无法在组件 / 子树层面单独覆盖。

## 目标

- 收敛 `TRefreshHeader` 构造参数暴露面，只保留 TDesign 层关心的视觉参数 + 最常用行为参数。
- 修复示例 `onRefresh` 未返回 `Future` 导致的刷新状态与计数更新不同步问题。
- 补全 `TRefreshThemeData` 主题控制层级，让 loading 颜色 / 文案颜色可经主题覆盖。

## 非目标

- 不改变 `easy_refresh` 底层能力；高级参数（spring、二楼、无限刷新等）仍可通过直接使用
  `easy_refresh` 原生 `Header` 实现，不在本 PR 内新增其他暴露方式。
- 不改动刷新头的手势识别、状态机等内部逻辑。

## 范围

### 涉及

- `tdesign-component/lib/src/components/refresh/t_refresh_header.dart`
- `tdesign-component/lib/src/components/refresh/t_refresh_theme_data.dart`
- `tdesign-component/test/components/refresh/t_refresh_test.dart`
- `tdesign-component/example/lib/page/t_refresh_page.dart`
- `tdesign-component/example/assets/code/refresh._buildRefresh.txt`
- `tdesign-component/example/assets/api/pull-down-refresh_api.md`
- `tdesign-site/docs/components/pull-down-refresh/README.md`
- `specs/004-refresh-api-converge/`

### 不涉及

- `easy_refresh` 依赖本身。
- 其他 TDesign 组件。

## 行为契约

### `TRefreshHeader` 构造参数收敛

- **保留**：`key`、`extent`、`triggerDistance`、`float`、`processedDuration`、
  `completeDuration`、`hapticFeedback`、`enableHapticFeedback`、`overScroll`、
  `loadingIcon`、`backgroundColor`、`position`。
- **移除**（用户需改用 `easy_refresh` 原生 `Header`）：`clamping`、`enableInfiniteRefresh`、
  `infiniteOffset`、`infiniteHitOver`、`spring`、`horizontalSpring`、
  `readySpringBuilder`、`horizontalReadySpringBuilder`、`springRebound`、
  `frictionFactor`、`horizontalFrictionFactor`、`safeArea`、`hitOver`、
  `secondaryTriggerOffset`、`secondaryVelocity`、`secondaryDimension`、
  `secondaryCloseTriggerOffset`、`notifyWhenInvisible`、`listenable`、
  `triggerWhenReach`、`triggerWhenRelease`、`triggerWhenReleaseNoWait`、`maxOverOffset`。
- 保留参数的默认值与透传行为与收敛前一致（`clamping` 默认沿用 `float ?? false`）。
- 构造器行为契约不变：`triggerDistance > 0`、`extent >= 0`、`clamping/float` 与
  `triggerDistance >= extent` 的断言逻辑保持一致。

### `TRefreshThemeData` 补全

- 新增 `loadingIconColor`、`loadingTextColor` 两个可空字段，`merge` / `copyWith` / `lerp`
  同步支持，`lerp` 对颜色使用 `Color.lerp`。
- `_buildLoading()` 中 loading 的 `iconColor` 优先取 `theme?.loadingIconColor`，回退全局
  `context.tTheme.brandNormalColor`；`textColor` 优先取 `theme?.loadingTextColor`，回退全局
  `context.tTheme.textColorPlaceholder`。
- 移除 `TRefreshThemeData` 中冗余的 `lerpDouble` 工具方法。

### 示例修复

- `onRefresh` 改为 `Future<void> Function()` 写法，返回 `Future` 并在异步完成后 `setState`，
  保证刷新状态与计数更新同步。

## 验收标准

- [ ] `TRefreshHeader` 构造参数从 30+ 收敛到 12 个，保留参数默认值与行为与收敛前一致。
- [ ] 移除的高级参数不再出现在 `TRefreshHeader` 构造器与 API 文档中。
- [ ] `TRefreshThemeData` 支持 `loadingIconColor` / `loadingTextColor` 主题覆盖，且实例 / 全局回退链路正确。
- [ ] 示例 `onRefresh` 返回 `Future`，刷新完成动画与计数更新同步。
- [ ] 单元与 Widget 测试全部通过。
- [ ] 明确标注该改动为 breaking change 并在 PR 更新日志中说明迁移方式。
