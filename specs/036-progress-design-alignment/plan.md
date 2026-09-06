# 实施方案

## 技术方案

- 在 `TProgressVariant` 增加 `plump`，由形态决定默认 label 布局；保留 Theme 的 `progressLabelPosition` 作为历史显式覆盖。
- 增加 `TProgressStatus` 与可选 `status` 参数，内部统一解析默认颜色、图标和无障碍语义。
- 继续使用 `TProgressThemeData` 承载颜色、尺寸、圆角与动画；解析顺序为 Theme / Flutter 显式视觉字段优先，再落到状态语义 token。
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
- 新增 `TProgressStatus` 和可选 `status`，默认 `primary`。
- `linear` 的默认标签位置由 inside 调整为 right；需要旧内显效果时迁移到 `plump`，属于 breaking change。
- 不新增颜色、尺寸或 Controller 的重复入口。

## 风险与取舍

- 保留 Theme 的 `progressLabelPosition` 仅用于已发布定制兼容；新代码应优先选择 variant。
- 微型按钮复用 `micro + label + onTap`，其结构仍是微型圆环，不额外增加可由现有组合表达的 variant。
- 状态色与状态图标由同一 status 派生，避免 Demo 手工包 Theme 后失去语义。

## 验证策略

- 组件测试验证结构、颜色、标签、回调和边界。
- Demo 测试验证公开矩阵、标题、初始值及按钮操作后的进度变化。
- 功能正确后再生成固定 Linux Golden，并立即无更新复验。
- 双版本执行功能测试与严格 analyze；最后在运行中的 Demo 点击一次按钮进度并核对结果。
