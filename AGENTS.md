# TDesign Flutter 仓库协作约定

本文件是 `tdesign-flutter` 仓库的协作约定入口，供所有在本仓库工作的 AI 助手（包括 CNB 平台的 NPC，以及支持读取 `AGENTS.md` 的 Codex / Cursor 等工具）参考。

> 完整、可执行的约定由仓库级 skill 承载：`.agents/skills/tdesign-flutter-conventions/SKILL.md`。
> 本文档是它的精简索引，二者内容一致，避免重复维护。

执行涉及分支 / PR / 组件改动的任务时，请先遵循以下核心约定（详细规则以 skill 为准）：

1. **分支 / PR 规范**：根据 Issue 创建的分支名 `<cnb.username/>/<issue.number>/<types>/<功能需求>`（无关联 Issue 时用 `<cnb.username/>/<types>/<功能需求>`）；PR 标题遵循 Conventional Commits。
2. **提交 PR 遵守模板**：按 `.github/PULL_REQUEST_TEMPLATE.md` 逐项填写；更新日志须按条分开，格式 `fix(组件): 修复 xxx`、`feat(组件): 新增 xxx`。
3. **关联相关 Issue**：有相关 Issue 时，在 PR 正文以 `close #xx`（如 `close #22`）形式携带关联。
4. **Spec 规范对齐**：组件 API 变更 / 重构 / 跨目录改动按 `specs/README.md` 创建 Spec，提交代码须与 Spec 行为契约一致并同步更新。
5. **Flutter 双版本兼容**：同时兼容 `flutter@3.32.0` 与 `flutter@latest`。
6. **breaking change 分析**：组件改动时判断是否改变公开 API 签名 / 默认行为 / 删除能力。

## 回答风格

- 回答使用与提问相同的语言（中文 / 英文）。
- 结论先行，给出明确判断，再附必要依据与可操作建议。
- 需要执行平台操作（建分支、提 PR、评论等）时，先核对上述规范再动手。
