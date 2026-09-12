# 实施方案

## 技术方案

- 将公开形态一次收敛为 `linear`、`plump`、`circular`、`microCircular`、`button`、`microButton`；形态唯一决定结构、默认尺寸、标签布局和交互边界。
- 增加 `TProgressStatus` 与可选 `status` 参数，内部统一解析默认颜色和图标；常规状态命名为 `normal`，不以色相名称冒充状态。
- 删除 `TProgressLabelPosition` 及 Theme 中的标签位置、显示开关、标签宽度/对齐和无界兜底宽度等历史兼容字段。
- 继续使用 `TProgressThemeData` 承载颜色、尺寸、圆角与动画；增加逐实例 `LinearGradient` 完整填充样式，解析顺序为实例渐变、Theme / Flutter 显式视觉字段、状态语义 token。
- 对齐 Flutter 的 `semanticsLabel` / `semanticsValue`，交互形态补充按钮语义与 44px 触控区域。
- Demo 状态仅由页面持有，按钮操作通过 `setState` 推进，不把 Timer 或 Controller 泄漏到组件 API。

## 影响范围

| 范围 | 影响 |
| --- | --- |
| 组件 | 新增 plump 形态与状态语义，修正默认布局及圆角 |
| Demo | 重建设计稿示例矩阵与按钮交互 |
| 文档 | 更新 dartdoc、生成 API、代码片段与 Spec |
| 测试 | 组件、Demo、Golden 及集中回归登记 |

## API 变化

- 新增 `TProgressVariant.plump`。
- 新增 `TProgressStatus` 和可选 `status`，默认 `normal`。
- `micro` 替换为语义明确的 `microCircular` 与 `microButton`。
- 新增逐实例 `gradient`、`semanticsLabel` 与 `semanticsValue`。
- 删除 `TProgressLabelPosition`、`progressLabelPosition`、`showLabel`、`labelWidgetWidth`、`labelWidgetAlignment` 和 `fallbackLinearWidth`。
- `linear` 的默认标签位置由 inside 调整为 right；需要旧内显效果时迁移到 `plump`，属于 breaking change。
- 不新增颜色、尺寸或 Controller 的重复入口。

## 风险与取舍

- 不保留历史兼容分支；迁移必须显式选择新的 variant 或传入 label。
- 微型环形和微型按钮分别建模，避免由 label / callback 是否存在隐式改变组件职责。
- 状态色与状态图标由同一 status 派生，避免 Demo 手工包 Theme 后失去语义。

## 验证策略

- 组件测试验证结构、颜色、标签、回调和边界。
- Demo 测试验证公开矩阵、标题、初始值及按钮操作后的进度变化。
- 功能正确后再生成固定 Linux Golden，并立即无更新复验。
- 双版本执行功能测试与严格 analyze；最后在运行中的 Demo 点击一次按钮进度并核对结果。
