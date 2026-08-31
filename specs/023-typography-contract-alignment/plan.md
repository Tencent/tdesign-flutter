# 实施方案

## 技术方案

在 `tdesign-component/lib/src/components/typography/` 下：

1. **扩展 `TText`**：新增 `copyable`、`expandable`、`expanded`、`onExpandedChange`、`onCopied` 参数。
   - `expanded == null` 时内部用 `StatefulWidget` 自管理；非 null 时受控。
   - `copyable` / 展开收起操作在文本后追加图标区，用 `Column`/`Row` 布局。
   - 复制用 `Clipboard.setData`，成功后 `Timer` 1.5s 切回图标并回调 `onCopied`。

2. **新增 `TTitle`**：`StatelessWidget`，构造时按 `level` 映射 `TTitleLevel` → TDesign Font token，组合 `TText`。

3. **新增 `TParagraph`**：`StatelessWidget`，构造时指定 `fontBodyMedium`，组合 `TText`。

4. **新增 `TTypography`**：命名空间父组件，提供静态方法 `text(...)` / `title(...)` / `paragraph(...)`。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `lib/src/components/typography/t_text.dart` | 新增交互能力（保持兼容） |
| 组件 | `lib/src/components/typography/t_title.dart`（新增） | 新组件 |
| 组件 | `lib/src/components/typography/t_paragraph.dart`（新增） | 新组件 |
| 组件 | `lib/src/components/typography/t_typography.dart`（新增） | 命名空间父组件 |
| 导出 | `lib/tdesign_flutter.dart` | 新增导出 |
| 示例 | `example/lib/page/t_text_page.dart` | 新增复制 / 展开收起 Demo |
| 测试 | `test/components/typography/` | 新增组件测试 |
| 文档 | `specs/011-text-flutter-contract-alignment` | 同步「非目标」 |

## API 变化

**新增（非 breaking）：**
- `TText.copyable`（`bool`，默认 `false`）
- `TText.expandable`（`bool`，默认 `false`）
- `TText.expanded`（`bool?`，受控）
- `TText.onExpandedChange`（`ValueChanged<bool>?`）
- `TText.onCopied`（`VoidCallback?`）
- `TTitle`（新组件，`data` + `level`）
- `TParagraph`（新组件，`data`）
- `TTypography`（命名空间）

## 风险与取舍

- `TText` 由 `StatelessWidget` 转为需支持内部状态（复制图标切换、展开自管理），可能需改造为 `StatefulWidget`。为保持兼容，仅在 `copyable`/`expandable` 使用时走 Stateful 分支；纯展示路径保持轻量。实际取舍：统一升级为 `StatefulWidget`，因 Flutter 中 StatefulWidget 成本可忽略，且不改变 API 签名。
- `expanded` 受控时复制/展开状态需避免双源：受控时不内部置位，仅回调。
- 复制图标需用 `TIcons`，具体图标名以 `tdesign_flutter_icons` 提供为准（复制用 `copy`，成功态用 `check`）。
- 中文环境默认文案「展开 / 收起」，英文「Expand / Collapse」。

## 验证策略

- 单元测试：`TTitle.level` 映射、`TParagraph` 默认字号。
- Widget 测试：`copyable` 点击复制回调、`expandable` 展开收起回调。
- 静态检查：`cd tdesign-component && flutter analyze`（0 error / 0 warning）。
- 人工验收：示例页检查复制与展开收起视觉与交互。
