# TSwipeCell 组件 Review 修复

## 背景

对 `TSwipeCell` 组件实现进行 review 后发现以下问题，本次修复落地：

1. **P1 组件级 Theme 覆盖能力不足（重点）**：`TSwipeCellThemeData` 仅有 `duration` 一个字段，操作项的背景色、图标色、文字样式、图标尺寸与间距均只能靠 P0 实例参数或 P4 Token 兜底，无法通过组件级 Theme 在子树批量覆盖，未完整闭环多层级主题控制方案。
2. **DOM 布局不对称**：`TSwipeCellAction.build` 中图标为裸 `Widget`，文字被 `Flexible` 包裹，二者在主轴上地位不对称。
3. **API 健壮性**：
   - `groupTag` 类型为 `Object?`，`==` 相同的值（如同字符串）易意外串组，缺唯一性说明；
   - `actionClick` 依赖 `children.indexOf(action)` 的实例引用相等，`copyWith` 重建的等价实例会使二次确认静默失效；
   - `closeOnScroll` 与 `initialOpenSide` 组合行为缺文档说明。

## 目标

- 补齐 `TSwipeCellThemeData` 视觉字段，让 P1 组件级 Theme 可覆盖操作项默认样式，遵循 P0 > P1 > P4 优先级。
- 统一操作项图标与文字的布局包裹，保证主轴对称。
- 为 `groupTag` 唯一性与 `closeOnScroll` 组合行为补充文档；为二次确认提供按稳定 `id` 匹配的能力。

## 非目标

- 不改变 `groupTag` 的公开类型（保持 `Object?`，与 `flutter_slidable` 的 `groupTag` 一致，避免 breaking）。
- 不改变二次确认基于 `confirmIndex`（children 索引）匹配的核心机制。
- 不引入新的 TDesign 主题 Token（继续复用现有 P4 Token）。

## 范围

### 涉及

- `tdesign-component/lib/src/components/swipe_cell/t_swipe_cell_theme_data.dart`
- `tdesign-component/lib/src/components/swipe_cell/t_swipe_cell_action.dart`
- `tdesign-component/lib/src/components/swipe_cell/t_swipe_cell.dart`
- `tdesign-component/lib/src/components/swipe_cell/t_swipe_cell_panel.dart`
- `tdesign-component/test/components/swipe_cell/t_swipe_cell_test.dart`
- `tdesign-component/test/acceptance/theme_acceptance_test.dart`

### 不涉及

- 不修改 `flutter_slidable` 的 API 使用方式。
- 不改变 `TSwipeCell` 的公开行为契约。

## 行为契约

1. **P1 主题覆盖**：`TSwipeCellThemeData` 新增可空字段 `actionBackgroundColor`、`actionIconColor`、`actionTextStyle`、`actionIconSize`、`actionSpacing`。实现 `copyWith` / `merge` / `lerp`。
2. **优先级解析**：在 `TSwipeCellAction.build` 中按 **P0 实例参数 > P1 组件 Theme > P4 Token（或内置兜底）** 解析：
   - 背景色：`backgroundColor` → `theme.actionBackgroundColor` → `null`
   - 图标色：`iconColor` → `theme.actionIconColor` → `labelStyle?.color` → `context.tTheme.textColorAnti`
   - 文字样式：`labelStyle` → `theme.actionTextStyle` → `context.tTheme.fontMarkMedium` → 内置兜底
   - 图标尺寸：`iconSize` → `theme.actionIconSize` → `18`
   - 间距：`spacing` → `theme.actionSpacing` → `2`
3. **DOM 对称**：图标与文字均以 `Flexible(fit: FlexFit.loose)` 包裹。
4. **二次确认 id 匹配**：`TSwipeCellAction` 新增可空 `String? id`。`actionClick` 优先按 `id` 在 `children` 中查找索引，未配置 `id` 时回退到 `indexOf` 实例引用匹配。
5. **兼容性**：`iconSize` / `spacing` 从构造器默认值改为可空，解析逻辑兜底保持原默认值（18 / 2），不改变既有调用方行为。

## 验收标准

- [ ] `TSwipeCellThemeData` 新增字段均可空，`copyWith` / `merge` / `lerp` 正确。
- [ ] 通过 `Theme.mergeExtension(TSwipeCellThemeData(...))` 可批量覆盖操作项背景色 / 图标色。
- [ ] P0 实例参数优先于 P1 主题。
- [ ] 图标与文字在 `Flex` 中均以 `Flexible` 包裹，布局对称。
- [ ] 二次确认支持按 `id` 匹配重建的等价 action；未配置 `id` 时保持实例引用匹配。
- [ ] 新增测试通过，`flutter analyze` 无新增告警。
- [ ] 同时兼容 `flutter@3.32.0` 与 `flutter@latest`。
