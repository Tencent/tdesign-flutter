# TDesign Flutter 仓库协作约定

本文件是 `tdesign-flutter` 仓库的协作约定**入口索引**，供所有在本仓库工作的 AI 助手（包括 CNB 平台的 NPC，以及支持读取 `AGENTS.md` 的 Codex / Cursor 等工具）参考。

> **规范本体**（唯一事实来源）：
> - 开发 / 协作 / PR / 更新日志规范 → [`CONTRIBUTING.md`](./CONTRIBUTING.md)
> - Spec 专项规范 → [`specs/README.md`](./specs/README.md)
>
> **面向 CNB 平台 NPC 的执行约定** → 仓库级 skill：`.agents/skills/tdesign-flutter-conventions/SKILL.md`
> （含 `cnb-issue-<issue.number>` 等仅 CNB 平台可用的细化规则，通用工具以其可读取到的实际上下文为准）

执行涉及分支 / PR / 组件改动的任务时，请先阅读对应规范：

1. **分支 / PR 规范**：分支名 `<cnb.username/>/<types>/<功能需求>`；PR 标题遵循 Conventional Commits。CNB 平台 NPC 若基于 Issue 创建，使用 `cnb-issue-<issue.number>` 前缀（见 SKILL.md）。详情见 [`CONTRIBUTING.md`](./CONTRIBUTING.md)。
2. **提交 PR 遵守模板**：按 `.github/PULL_REQUEST_TEMPLATE.md` **完整保留原模板结构**（所有选项含未勾选的 `[ ]`、所有 HTML 注释原样保留），只打勾 / 填写、不删减；PR 描述「更新日志」**只记录用户可感知的变更**（目标受众是用户，非开发者 / 维护者），内部 / CI / 文档结构调整等用户无需感知的改动**不写日志**，勾选「本条 PR 不需要纳入 Changelog」即可（`tdesign-component/CHANGELOG.md` 由 CLI 自动生成，无需人工维护）。格式细则见 [`CONTRIBUTING.md`](./CONTRIBUTING.md)。
3. **关联相关 Issue**：Issue 主阵地是 GitHub。**CNB 平台生成的 PR 不携带任何 Issue 编号**（不以 `close #xx` 关联 CNB Issue，正文任何小节不写明 CNB Issue 编号），也**不写差异 / 关联提示**，正文内容**仅按 `.github/PULL_REQUEST_TEMPLATE.md` 原始模板填写**；真正的 `close #xx` 关联在 GitHub 侧 PR 中填写，与 CNB 侧无关。
4. **Spec 规范对齐**：组件 API 变更 / 重构 / 跨目录改动按 [`specs/README.md`](./specs/README.md) 创建 Spec，提交代码须与 Spec 行为契约一致并同步更新。
5. **Flutter 双版本兼容**：同时兼容 `flutter@3.32.0` 与 `flutter@latest`。
6. **breaking change 分析**：组件改动时判断是否改变公开 API 签名 / 默认行为 / 删除能力。

## 回答风格

- 回答使用与提问相同的语言（中文 / 英文）。
- 结论先行，给出明确判断，再附必要依据与可操作建议。
- 需要执行平台操作（建分支、提 PR、评论等）时，先核对上述规范再动手。
