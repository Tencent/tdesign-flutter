# Tag 与 Popover 视觉选择器实例所有权收敛

## 背景

`TTag`、`TSelectTag` 和 `TPopover` 已公开实例级 `colorScheme`，但 `TTagThemeData` 与 `TPopoverThemeData` 仍保存同类型的枚举选择器。Tag 的 `dark / light / outline / light-outline` 绘制形态还由 Theme 中 `isLight + isOutline` 两个布尔值隐式组合，普通实例无法直接表达；Popover 的 `dark / info / error` 配色名称也没有沿用 Button 已建立的 `defaultTheme / primary / danger` 词汇。仓库组件 Review skill 与外部安装副本还存在内容漂移，且没有充分说明 `variant / colorScheme / status` 的语义判定、Theme 默认值条件和历史 API 债务边界。

## 目标

- 由组件实例 `colorScheme` 唯一选择 Tag 与 Popover 的配色预设。
- 从 `TTagThemeData`、`TPopoverThemeData` 删除枚举型 `colorScheme`。
- 由实例 `TTagVariant` 完整表达 Tag 的四种绘制形态，删除 Theme 中重复的 `isLight / isOutline`。
- 在不改变视觉映射的前提下，将 Popover 配色统一为 `defaultTheme / primary / success / warning / danger / light`。
- 将 `TPopoverColorScheme` 移至组件 types 文件并保持包入口导出。
- 保持现有默认视觉、显式配色视觉和 Theme 具体样式覆盖行为不变。
- 以仓库 skill 为唯一维护源，统一当前加载副本，并补齐可复用的 API 所有权判定模型。

## 非目标

- 不重命名实例 `colorScheme` 或枚举类型。
- 不改变 `TTagColorScheme` 的取值和颜色映射。
- 不把 Popover 的视觉配色预设拆成 `status + colorScheme` 两个无独立组合契约的维度。
- 不删除 ThemeData 中的具体颜色、尺寸、形状、间距或完整样式字段。
- 不调整 Tag、Popover 的公开 Demo 结构和交互矩阵。
- 不在本 PR 迁移其他组件已经发布的历史 API；发现的冲突只记录债务，不作为复制先例。

## 范围

### 涉及

- `TTag`、`TSelectTag`、`TTagThemeData`
- `TPopover`、`TPopoverWidget`、`TPopoverThemeData`
- Popover 类型导出、相关 Widget 测试和 API 兼容说明
- 仓库组件 Review skill 及其入口说明

### 不涉及

- Flutter `ThemeData.colorScheme` 与 TDesign 全局 token
- 其他组件的配色、状态或形态 API
- 自动生成的 API Markdown 与示例代码片段

## 全仓库语义审计

| 现有契约 | 判断 | 本 PR 处理 |
| --- | --- | --- |
| `TButton.variant + colorScheme` | 绘制处理与调色板独立；`variant` nullable，`TButtonThemeData.defaultVariant` 有明确子树默认链 | 保持；修正文档中不存在的 Theme 配色回退 |
| `TSwitchThemeData.defaultVariant` | 实例 `variant` nullable，Theme 只提供呈现默认，符合 `instance → Theme → built-in` | 保持 |
| Tag `dark/light/outline/lightOutline + colorScheme` | 前者改变实色、浅色和描边处理，后者只替换调色板，存在有效交叉组合 | 收敛为两个实例维度 |
| Popover `colorScheme` | success/warning 等值只选择气泡调色板，不表达运行时状态、默认内容或行为 | 保留单一配色维度，不新增 `status` |
| `TFabDefaults.defaultColorScheme` | 内部内置默认常量，不是 ThemeExtension 选择器 | 不属于禁止范围 |
| `TLinkThemeData.defaultColorScheme` | Theme 与实例重复保存枚举型配色选择器，属于已发布历史债务 | 不在本 PR 扩大 breaking 范围；后续 Link 契约修改时单独迁移 |
| `TMessageStatus`、`TNoticeBarStatus` 的 info/success/warning/error | 表达消息或公告当前语义状态并决定默认图标 | 使用实例 `status` 作为唯一状态入口，Theme 不保存状态 |

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
- `variant` 按结构或填充/描边等绘制处理判断，`colorScheme` 按纯调色板选择判断，`status/state` 按业务或生命周期状态判断；枚举成员名称本身不决定维度。
- `defaultVariant` 仅允许用于真实的子树呈现默认需求，且实例字段必须 nullable，解析顺序为实例、Theme、内置默认值；`colorScheme` 与 `status` 不提供 Theme 回退。
- Theme 的样式解析器可以接收实例状态以派生颜色，但 Theme 不保存、选择或覆盖业务状态。
- Button 的 `colorScheme` dartdoc 明确回退到 `TButtonColorScheme.defaultTheme`，不再声称存在 Theme 配色选择器。
- 全仓库审计发现 `TLinkThemeData.defaultColorScheme` 是已发布的历史选择器。本 PR 不扩展到 Link 的 breaking 迁移；后续修改 Link 契约时需单独评估并禁止继续扩散。

## 验收标准

- [x] 全仓库不存在 `TTagThemeData(colorScheme: ...)` 或 `TPopoverThemeData(colorScheme: ...)`。
- [x] Tag 的四种实例 `variant` 与五种 `colorScheme` 均有测试覆盖，默认视觉保持不变。
- [x] Popover 六种新命名配色均有测试覆盖，旧值不存在残留。
- [x] ThemeData 的 copyWith、merge、lerp 测试不再依赖配色选择器。
- [x] `TTagThemeData` 不再公开 `isLight / isOutline`。
- [x] `TPopoverColorScheme` 从独立 types 文件通过包入口正常导出。
- [x] Tag、Popover 针对性测试通过。
- [x] `flutter analyze` 为 0 error / 0 warning。
- [x] 仓库 skill 与当前加载副本内容一致，且 skill 结构校验通过。
- [x] API 判定模型不含特定组件的一次性迁移指令，不与现有通用规范重复或冲突。
