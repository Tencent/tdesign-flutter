# Tag 与 Popover 视觉选择器实例所有权收敛

## 背景

`TTag`、`TSelectTag` 和 `TPopover` 已公开实例级 `colorScheme`，但 `TTagThemeData` 与 `TPopoverThemeData` 仍保存同类型的枚举选择器。Tag 的 `dark / light / outline / light-outline` 绘制形态还由 Theme 中 `isLight + isOutline` 两个布尔值隐式组合，普通实例无法直接表达；Popover 的 `dark / info / error` 配色名称也没有沿用 Button 已建立的 `defaultTheme / primary / danger` 词汇。

## 目标

- 由组件实例 `colorScheme` 唯一选择 Tag 与 Popover 的配色预设。
- 从 `TTagThemeData`、`TPopoverThemeData` 删除枚举型 `colorScheme`。
- 由实例 `TTagVariant` 完整表达 Tag 的四种绘制形态，删除 Theme 中重复的 `isLight / isOutline`。
- 在不改变视觉映射的前提下，将 Popover 配色统一为 `defaultTheme / primary / success / warning / danger / light`。
- 将 `TPopoverColorScheme` 移至组件 types 文件并保持包入口导出。
- 保持现有默认视觉、显式配色视觉和 Theme 具体样式覆盖行为不变。

## 非目标

- 不重命名实例 `colorScheme` 或枚举类型。
- 不改变 `TTagColorScheme` 的取值和颜色映射。
- 不把 Popover 的视觉配色预设拆成 `status + colorScheme` 两个无独立组合契约的维度。
- 不删除 ThemeData 中的具体颜色、尺寸、形状、间距或完整样式字段。
- 不调整 Tag、Popover 的公开 Demo 结构和交互矩阵。

## 范围

### 涉及

- `TTag`、`TSelectTag`、`TTagThemeData`
- `TPopover`、`TPopoverWidget`、`TPopoverThemeData`
- Popover 类型导出、相关 Widget 测试和 API 兼容说明

### 不涉及

- Flutter `ThemeData.colorScheme` 与 TDesign 全局 token
- 其他组件的配色、状态或形态 API
- 自动生成的 API Markdown 与示例代码片段

## 行为契约

- `TTag.colorScheme` 默认使用 `TTagColorScheme.defaultTheme`；`TTag.variant` 默认使用 `TTagVariant.dark`。
- `TTagVariant.dark / light / outline / lightOutline` 分别对应既有 `isLight / isOutline` 的四种组合，视觉映射不变。
- `TSelectTag.colorScheme` 默认使用 `TTagColorScheme.primary`，仅决定选中态配色；未选中时使用 `TTagColorScheme.defaultTheme`。`variant` 同时传递给选中和未选中的内部 Tag。
- `TTagThemeData` 不再接受、复制或插值 `isLight / isOutline`。
- `TPopover.showPopover.colorScheme` 与 `TPopoverWidget.colorScheme` 是 Popover 配色预设的唯一公开输入；未传时维持现有默认深色解析。
- `TPopoverColorScheme.dark / info / error` 分别迁移为 `defaultTheme / primary / danger`；`light / success / warning` 保持名称和视觉映射。
- `TTagThemeData` 与 `TPopoverThemeData` 不再接受、复制、合并或插值组件枚举型 `colorScheme`。
- ThemeData 的具体颜色或样式字段继续按既有优先级覆盖由实例配色预设解析出的默认呈现。
- `TPopoverColorScheme` 继续从 `package:tdesign_flutter/tdesign_flutter.dart` 导出，调用方无需修改 import。
- 删除两个 ThemeData 的 `colorScheme`、删除 `TTagThemeData.isLight / isOutline`、收紧实例选择器空值和重命名 Popover 枚举值均属于 breaking API 变更。调用方需将 Tag 形态迁移到实例 `variant`，并按映射表迁移 Popover 枚举值。

## 验收标准

- [x] 全仓库不存在 `TTagThemeData(colorScheme: ...)` 或 `TPopoverThemeData(colorScheme: ...)`。
- [x] Tag 的四种实例 `variant` 与五种 `colorScheme` 均有测试覆盖，默认视觉保持不变。
- [x] Popover 六种新命名配色均有测试覆盖，旧值不存在残留。
- [x] ThemeData 的 copyWith、merge、lerp 测试不再依赖配色选择器。
- [x] `TTagThemeData` 不再公开 `isLight / isOutline`。
- [x] `TPopoverColorScheme` 从独立 types 文件通过包入口正常导出。
- [x] Tag、Popover 针对性测试通过。
- [x] `flutter analyze` 为 0 error / 0 warning。
