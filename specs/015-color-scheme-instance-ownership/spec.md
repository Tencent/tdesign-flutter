# 组件配色选择器实例所有权收敛

## 背景

`TTag`、`TSelectTag` 和 `TPopover` 已公开实例级 `colorScheme`，但 `TTagThemeData` 与 `TPopoverThemeData` 仍保存同类型的枚举选择器。调用方因此可以从实例和 Theme 两处决定同一组件的配色预设，形成重复状态源；`TPopoverColorScheme` 还定义在 ThemeData 文件中，与其实例 API 所有权不一致。

## 目标

- 由组件实例 `colorScheme` 唯一选择 Tag 与 Popover 的配色预设。
- 从 `TTagThemeData`、`TPopoverThemeData` 删除枚举型 `colorScheme`。
- 将 `TPopoverColorScheme` 移至组件 types 文件并保持包入口导出。
- 保持现有实例默认值、显式配色视觉和 Theme 具体样式覆盖行为不变。

## 非目标

- 不重命名实例 `colorScheme`、枚举类型或枚举值。
- 不改变 `TTagColorScheme`、`TPopoverColorScheme` 的颜色映射。
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

- `TTag.colorScheme` 未传时使用 `TTagColorScheme.defaultTheme`。
- 选中的 `TSelectTag.colorScheme` 未传时使用 `TTagColorScheme.primary`；未选中时使用 `TTagColorScheme.defaultTheme`。
- `TPopover.showPopover.colorScheme` 与 `TPopoverWidget.colorScheme` 是 Popover 配色预设的唯一公开输入；未传时维持现有默认深色解析。
- `TTagThemeData` 与 `TPopoverThemeData` 不再接受、复制、合并或插值组件枚举型 `colorScheme`。
- ThemeData 的具体颜色或样式字段继续按既有优先级覆盖由实例配色预设解析出的默认呈现。
- `TPopoverColorScheme` 继续从 `package:tdesign_flutter/tdesign_flutter.dart` 导出，调用方无需修改 import。
- 删除两个 ThemeData 构造参数属于 breaking API 变更；曾依赖 Theme 子树统一选择配色的调用方需把 `colorScheme` 显式传入对应组件实例。

## 验收标准

- [x] 全仓库不存在 `TTagThemeData(colorScheme: ...)` 或 `TPopoverThemeData(colorScheme: ...)`。
- [x] Tag 与 Popover 的实例级 `colorScheme` 测试通过，默认值保持不变。
- [x] ThemeData 的 copyWith、merge、lerp 测试不再依赖配色选择器。
- [x] `TPopoverColorScheme` 从独立 types 文件通过包入口正常导出。
- [x] Tag、Popover 针对性测试通过。
- [x] `flutter analyze` 为 0 error / 0 warning。
