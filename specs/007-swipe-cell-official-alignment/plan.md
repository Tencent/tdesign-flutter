# TSwipeCell 官方对齐修复 - 技术方案

## 技术方案

### 1. 阈值对齐

在 `TSwipeCellPanel.build` 中，将默认阈值由 `extentRatio / 2` 改为 `extentRatio * 0.3`：

```dart
openThreshold: openThreshold ?? (extentRatio * 0.3),
closeThreshold: closeThreshold ?? (extentRatio * 0.3),
```

`openThreshold` / `closeThreshold` 仍为可空，显式传入优先。注释同步更新为“默认面板宽度的 30%”。

### 2. 动画时长对齐

`TSwipeCell.getDuration` 兜底默认值 `Duration(milliseconds: 200)` → `Duration(milliseconds: 600)`。`TSwipeCellThemeData.duration` 保持可空，`null` 时使用内置 600ms。注释同步更新。

### 3. 点击外部 / 本格关闭

`TSwipeCell` 新增参数：

```dart
final bool? closeOnTapOutside;
```

`null` 视为 `true`（对齐官方）。在 `_TSwipeCellState` 中：

- 面板展开（`_handleActionPanelTypeChanged` 命中 `start` / `end`）且 `closeOnTapOutside != false` 时，注册全局指针路由 `WidgetsBinding.instance.pointerRouter.addRoute(_handlePointerDown)`；
- 面板关闭（`ActionPaneType.none`）或 `dispose` 时移除该路由；
- `_handlePointerDown`：用 `context.findRenderObject()` 拿到本格 RenderBox，将 `event.position` 转本地坐标；若落在本格外，则 `controller.close(duration: ...)`；
- 本格内容关闭：在 `build` 中给 `child` 包一层 `Listener(onPointerDown: ...)`，面板展开且点在 child 上时关闭。操作项按钮位于 Slidable 的 ActionPane（child 之外），不会被该 Listener 触发。

### 4. 视觉默认值

`TSwipeCellAction.build`：

- `effectiveIconSize` 兜底 `18` → `20`；
- `effectiveSpacing` 兜底 `2` → `8`；
- 操作项 `Container` 增加 `padding: EdgeInsets.symmetric(horizontal: 16)`（左右各 16px），可被 `TSwipeCellThemeData.actionPadding` 覆盖（新增可空字段，`copyWith` / `merge` / `lerp` 实现）。
- 修正 `flex` dartdoc“失踪”→“始终”。

### 5. 文档 / 示例

- 站点 README 参数表补 `closeOnScroll`（默认 true）与 `closeOnTapOutside`；
- 示例 `_buildSwiperCell` 移除 `print` 调试输出，并同步更新 `assets/code/SwipeCell._buildSwiperCell.txt`。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `t_swipe_cell_panel.dart` | 默认阈值 50%→30%（breaking，默认行为变更） |
| 组件 | `t_swipe_cell.dart` | 默认动画 200ms→600ms（breaking）；新增 `closeOnTapOutside` |
| 组件 | `t_swipe_cell_theme_data.dart` | 新增 `actionPadding` 字段 |
| 组件 | `t_swipe_cell_action.dart` | 图标 20、间距 8、内边距 16；`flex` 注释 |
| 示例 | `t_swipe_cell_page.dart` + 生成代码 txt | 移除 `print` |
| 文档 | 站点 `swipe-cell/README.md` | 补 `closeOnScroll` / `closeOnTapOutside` |
| 测试 | `t_swipe_cell_test.dart` | 阈值、时长、点击关闭、视觉默认值断言 |

## API 变化

- 新增：`TSwipeCell.closeOnTapOutside`（`bool?`，`null` 视为 true）。
- 新增：`TSwipeCellThemeData.actionPadding`（`EdgeInsetsGeometry?`）。
- 变化：`TSwipeCellAction` 图标 / 间距 / 内边距内置默认值（`18→20`、`2→8`、新增 16px）。
- 变化：`TSwipeCellPanel` 默认阈值（`extentRatio/2 → extentRatio*0.3`）。
- 变化：`TSwipeCell.getDuration` 默认动画（`200ms → 600ms`）。

## 风险与取舍

- **Breaking change**：阈值、动画时长、视觉默认值的改变属于默认行为变更，会改变既有页面手感与视觉。须在 Changelog 加 `⚠️` 标记，并在 PR 描述中说明。
- **点击关闭**：全局指针路由监听生命周期需在 open/close/dispose 精确管理，避免内存泄漏与误触发。操作项按钮点击不触发全局关闭，避免与 `autoClose` / 二次确认冲突。
- **双版本兼容**：使用 `Listener` / `pointerRouter` / `WidgetsBinding`，在 `flutter@3.32.0` 与 `flutter@latest` 均可用。

## 验证策略

- 单元测试：`openThreshold` / `closeThreshold` 默认 30% 且显式优先；`getDuration` 默认 600ms 且 Theme 可覆盖。
- Widget 测试：`closeOnTapOutside` 默认展开后点击本格 / 外部关闭；`false` 时不关闭；操作项按钮点击不触发全局关闭。
- 静态检查：`flutter analyze` 0 error / 0 warning。
- 人工验收：示例滑动手感、展开后点击空白关闭、图标间距与内边距视觉。
