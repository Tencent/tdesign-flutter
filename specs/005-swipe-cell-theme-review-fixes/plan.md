# TSwipeCell 组件 Review 修复 - 技术方案

## 方案

### 1. `TSwipeCellThemeData` 补齐视觉字段

新增可空字段并实现 `copyWith` / `merge` / `lerp`：

- `actionBackgroundColor`（`Color?`）：操作项默认背景色
- `actionIconColor`（`Color?`）：操作项图标默认色
- `actionTextStyle`（`TextStyle?`）：操作项文字默认样式
- `actionIconSize`（`double?`）：操作项图标默认尺寸
- `actionSpacing`（`double?`）：操作项图标与文字默认间距

### 2. `TSwipeCellAction` 优先级解析与布局对称

- 在 `build` 中读取 `Theme.of(context).extension<TSwipeCellThemeData>()`，按 P0 > P1 > P4 解析生效值。
- `iconSize` / `spacing` 改为可空，解析时兜底原默认值（18 / 2）。
- 图标与文字统一用 `Flexible(fit: FlexFit.loose)` 包裹，保证主轴布局对称，文字 `overflow: ellipsis` 防溢出。

### 3. 二次确认稳定匹配

- 新增 `TSwipeCellAction.id`（`String?`）。
- `_TSwipeCellState.actionClick` 优先按 `id` 查找索引，未配置时回退 `indexOf`。

### 4. 文档补充

- `groupTag`：强调需全局唯一。
- `closeOnScroll`：说明与 `initialOpenSide` 的组合粘滞语义。
- `TSwipeCellPanel.confirms`：说明实例复用约束与 `id` 用法。

## 影响范围

- 仅 `swipe_cell` 目录下的组件与 theme 文件，以及对应测试。
- 不改动 `flutter_slidable` 的 API 使用方式。

## API 变化

- 新增：`TSwipeCellThemeData` 的 5 个可空视觉字段。
- 新增：`TSwipeCellAction.id`（`String?`）。
- 变化：`TSwipeCellAction.iconSize` / `spacing` 由非空默认值改为可空（解析逻辑兜底保持默认值，行为不变）。

## 风险与验证

- **Breaking change**：无。全部为新增可空字段 / 保持默认行为。既有调用方无需改动。
- **验证**：新增单元测试与主题验收测试；依赖 CI 跑 `flutter analyze` 与双版本构建（`flutter@3.32.0` / `flutter@latest`）。
