# TDesign Flutter 仓库协作约定

本文件是 `tdesign-flutter` 仓库的协作约定**入口索引**，供所有在本仓库工作的 AI 助手（包括 CNB 平台的 NPC，以及支持读取 `AGENTS.md` 的 Codex / Cursor 等工具）参考。

> **规范本体**（唯一事实来源）：
> - 开发 / 协作 / PR / 更新日志规范 → [`CONTRIBUTING.md`](./CONTRIBUTING.md)
> - Spec 专项规范 → [`specs/README.md`](./specs/README.md)
>
> **面向所有 AI 助手的通用协作约定** → 仓库级 skill：`.agents/skills/tdesign-flutter-general/SKILL.md`
> （含「何时创建 Spec / 何时写更新日志」四种情况、Flutter 双版本兼容、breaking change 分析、文档与注释规范、脚本生成的产物（供 AI 理解，贡献者无需关注）、lint 零告警等平台无关约定）
>
> **组件公开 Demo / API / Theme / Golden 对齐 Review** → 仓库级 skill：`.agents/skills/tdesign-component-align-review/SKILL.md`
> （用于组件对齐与 PR Review，约束跨端证据、API 收敛、`variant` / `colorScheme` / `status` 所有权、Theme 优先级及视觉回归门禁）
>
> **CNB 协作补充说明** → [`.cnb/CONTRIBUTING.md`](./.cnb/CONTRIBUTING.md)
> （操作 CNB PR 时读取 Issue 约定；NPC 分支命名仅适用于 CNB NPC 创建分支。本地查看、Review 或联调 CNB PR 不会启用 NPC 模式。平台操作流程由 CNB 配置或本机工具维护。）

执行涉及分支 / PR / 组件改动的任务时，请先阅读对应规范：

1. **分支 / PR 规范**：分支名 `<cnb.username/>/<types>/<功能需求>`；PR 标题遵循 Conventional Commits。CNB NPC 创建分支时另见 [CNB 补充说明](./.cnb/CONTRIBUTING.md)，通用规范见 [`CONTRIBUTING.md`](./CONTRIBUTING.md)。
2. **提交 PR 遵守模板**：按 `.github/PULL_REQUEST_TEMPLATE.md` **完整保留原模板结构**（所有选项含未勾选的 `[ ]`、所有 HTML 注释原样保留），只打勾 / 填写、不删减；PR 描述「更新日志」**只记录用户可感知的变更**（目标受众是用户，非开发者 / 维护者），内部 / CI / 文档结构调整等用户无需感知的改动**不写日志**，勾选「本条 PR 不需要纳入 Changelog」即可；**breaking change 使用 `breaking` commit type**（如 `- breaking(toast): 调整 xxx 默认行为`），会自动归入 CHANGELOG 的 Breaking Changes 分组。commit type 与最终分组的对应关系见 [`CONTRIBUTING.md`](./CONTRIBUTING.md)。`tdesign-component/CHANGELOG.md` 由 CLI 自动生成，无需人工维护。格式细则见 [`CONTRIBUTING.md`](./CONTRIBUTING.md)。
3. **关联相关 Issue**：Issue 主阵地是 GitHub，按 [`CONTRIBUTING.md`](./CONTRIBUTING.md) 关联；操作 CNB PR 时遵循 [CNB 补充说明](./.cnb/CONTRIBUTING.md) 的平台限制。
4. **Spec 规范对齐**：组件 API 变更 / 重构 / 跨目录改动按 [`specs/README.md`](./specs/README.md) 创建 Spec，提交代码须与 Spec 行为契约一致并同步更新。注意**「是否需要 Spec」与「是否需要更新日志」是两件独立的事**：Spec 看改动复杂度 / 是否碰公共契约，更新日志看用户是否感知。**最容易出错**：行为不变的纯内部重构**要 Spec**（属于重构）但**不写更新日志**。四种情况详见 `.agents/skills/tdesign-flutter-general/SKILL.md`「何时创建 Spec / 何时写更新日志」一节。
5. **Flutter 双版本兼容**：同时兼容 `flutter@3.32.0` 与 `flutter@latest`。
6. **breaking change 分析**：组件改动时判断是否改变公开 API 签名 / 默认行为 / 删除能力。
7. **脚本生成的产物（供 AI 理解，贡献者无需关注）**：`API 文档`（`sh ./demo_tool/all_build.sh` → `example/assets/api/*.md`）、`示例代码片段`（`dart run tool/generate_example_code.dart` → `example/assets/code/*.txt`）、`README 副本`（`node scripts/sync-readme.mjs` → `tdesign-component/README*.md` 与 `tdesign-site/site/docs/getting-started.md`）均由脚本从源码生成，`.github/workflows/autofix.yml` 会在 PR 时自动运行并修正，**贡献者无需关注**；AI 需理解这些脚本做什么，改动相关源文件后产物会由 CI 自动重新生成，必要时可手动运行并一并提交（详见 `.agents/skills/tdesign-flutter-general/SKILL.md`「脚本生成的产物」一节）。
8. **文档与注释**：组件公开 API 的 `///` dartdoc 注释就是用户文档，改动公开 API 时须随代码同步更新注释；复杂需求 / 重构按 Spec 记录设计；PR「更新日志」只写用户可感知的变更；`CHANGELOG.md` 由 CLI 生成勿手动编辑（详见 `.agents/skills/tdesign-flutter-general/SKILL.md`「文档来源与注释规范」一节）。
9. **代码质量 / lint 零告警**：提交前须过 `flutter analyze`（0 error / 0 warning），能用 `const`/`final` 的地方必须用、避免 lambda 替代 tear-off、遵循 `directives_ordering` 等，全部对齐 `analysis_options.yaml`；CI 的 `.cnb.yml` 已加 analyze 兜底（详见 `.agents/skills/tdesign-flutter-general/SKILL.md`「代码质量 / lint 零告警」一节）。

## 回答风格

- 回答使用与提问相同的语言（中文 / 英文）。
- 结论先行，给出明确判断，再附必要依据与可操作建议。
- 需要执行平台操作（建分支、提 PR、评论等）时，先核对上述规范再动手。
