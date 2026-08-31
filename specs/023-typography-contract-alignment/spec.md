# TDesign Flutter Typography 契约对齐（TText / TTitle / TParagraph）

## 背景

TDesign H5 / 小程序把 Typography 做成一个「父组件 + 3 个子组件」的家族：
`Text`（基础文本 + 修饰 + 复制 + 省略）、`Title`（h1~h6 标题）、`Paragraph`（语义段落）。
Flutter 侧当前只有 `TText`（Flutter 原生 `Text` 的 Token 薄封装），
**没有** `TTitle` / `TParagraph`，**没有**复制、展开/收起等交互能力，
且 `specs/011-text-flutter-contract-alignment` 曾把复制/展开/省略明确列为「非目标」。

本次任务要求「实现尽量对齐 tdesign api 设计」，因此把这些能力重新纳入契约，
并按 H5 / 小程序公开 API 对齐 Flutter 组件族结构与 Props / Events。

## 目标

- 新增 `TTypography` 命名空间父组件（静态暴露 `text` / `title` / `paragraph`）。
- 扩展 `TText`：新增 `copyable`、`expandable`、`expanded`、`onExpandedChange`、`onCopied`。
- 新增 `TTitle`（`level` h1~h6）与 `TParagraph`（语义段落 + 省略），基于 `TText` 组合实现。
- 对齐「组件类型 / 组合用法 / 主题样式 / 可复制 / 文本省略」公开 Demo。
- 保持 `TText` 现有 API 兼容，不破坏已有用法。

## 非目标

- 不实现 `ul` / `ol` 列表（结构复杂，候选能力，后续单独评估）。
- 不实现 `secondary` theme 的独立 API（用颜色 Token 表达）。
- 不实现 `start` / `middle` 省略的自定义绘制（原生 `Text` 仅支持 `end`），`ellipsisMode` 本轮只做 `end`。
- 不实现可变字体 `FontVariation`（候选能力）。
- 不接收子组件 ThemeData（继承当前 Theme 子树）。

## 范围

### 涉及

- `tdesign-component/lib/src/components/typography/`（TText 扩展、新增 TTitle / TParagraph / TTypography）
- `tdesign-component/lib/tdesign_flutter.dart`（导出）
- `tdesign-component/example/lib/page/t_text_page.dart`（Demo）
- `specs/011-text-flutter-contract-alignment`（同步更新「非目标」）

### 不涉及

- `tdesign-component/CHANGELOG.md`（由 CLI 自动生成）
- 站点文档生成产物（由 CI 自动重新生成）

## 行为契约

### 组件族结构

```
TTypography            （命名空间父组件，静态入口）
├── TTypography.text(...)      → TText（基础文本 + 修饰 + 复制 + 省略）
├── TTypography.title(...)     → TTitle（h1~h6 标题）
└── TTypography.paragraph(...) → TParagraph（语义段落 + 省略）
```

三个子组件均为 `TText` 的组合扩展，继承当前 Theme 子树，不接收子组件 ThemeData。

### TText 新增能力

- `copyable`（`bool`，默认 `false`）：为 true 时在文本后显示复制图标，点击写入剪贴板（`Clipboard.setData`），成功后短暂切换为 check 图标并回调 `onCopied`。
- `expandable`（`bool`，默认 `false`）：为 true 且内容超出 `maxLines` 时，显示「展开 / 收起」操作。
- `expanded`（`bool?`，受控）：展开状态；为 null 时内部自管理，非 null 时受控驱动。
- `onExpandedChange`（`ValueChanged<bool>?`）：展开状态变化回调。
- `onCopied`（`VoidCallback?`）：复制成功回调。
- `maxLines`（透传原生）：`expandable` 的省略行数。
- 展开/收起默认文案走多语言：`zh`「展开 / 收起」，`en`「Expand / Collapse」。

### TTitle

- `data`（`String`，必填）。
- `level`（`TTitleLevel` 枚举，默认 `h1`）：h1~h6 映射 TDesign Font token，**固定消费 TDesign token，不随 Flutter 平台 `TextTheme` 本地化**：
  - h1 → `fontHeadlineLarge`（36/44）
  - h2 → `fontHeadlineMedium`（28/36）
  - h3 → `fontHeadlineSmall`（24/32）
  - h4 → `fontTitleLarge`（18/26）
  - h5 → `fontTitleMedium`（16/24）
  - h6 → `fontTitleSmall`（14/22）
- 省略/展开：同 `TText` 的 `expandable` / `expanded` / `maxLines` / `onExpandedChange`。

### TParagraph

- `data`（`String`，必填）。
- 默认字号：`fontBodyMedium`（14/22），**不能**依赖 `TText` 默认的 `fontBodyLarge`（16/24），构造时显式指定。
- 省略/展开：同 `TText`。

### 样式优先级

保持 `TText` 现有解析链：`实例 style > 实例便利参数 > TTextThemeData > DefaultTextStyle > Material TextTheme > Token`，不破坏已有 API。

### 复制行为

- 复制内容默认整段 `data`。
- 复制成功写入系统剪贴板后，图标短暂切换为 check，随后恢复，并回调 `onCopied`。

## 验收标准

- [ ] `TText` 现有用法全部保持兼容，无 breaking API。
- [ ] `TTitle` / `TParagraph` / `TTypography` 可正常构造与渲染，`level` 映射正确。
- [ ] `copyable` 点击可写入剪贴板并回调 `onCopied`。
- [ ] `expandable` 内容超 `maxLines` 时可展开/收起并回调 `onExpandedChange`。
- [ ] `flutter analyze` 0 error / 0 warning。
- [ ] 组件相关测试通过。
