# CNB 协作补充约定

本文是本仓库的静态平台约定，不是可执行 skill。创建或更新 CNB PR 时读取“PR 与 Issue”；仅在 CNB NPC 创建分支时应用“分支命名”。本地查看、Review 或联调 CNB PR，不会使本地工具进入 NPC 模式。

通用规范见 [`CONTRIBUTING.md`](../CONTRIBUTING.md) 和 [`specs/README.md`](../specs/README.md)，AI 执行入口见 [`AGENTS.md`](../AGENTS.md)。组件审查标准仍由仓库的 [`tdesign-component-align-review`](../.agents/skills/tdesign-component-align-review/SKILL.md) 维护。

## 分支命名（仅 CNB NPC 创建分支时）

- 根据 CNB Issue 创建分支：`<cnb.username>/cnb-issue-<issue.number>/<types>/<功能需求>`，如 `rss1102/cnb-issue-31/fix/branch-auto-close-issue`。
- 无关联 CNB Issue：`<cnb.username>/<types>/<功能需求>`，如 `rss1102/chore/update-ci-config`。用户名与 Issue 编号从当前平台事实取得，不猜测，不把 GitHub Issue 编号填入 CNB 前缀。
- `<types>` 按改动选择 `feat`、`fix`、`docs`、`refactor`、`chore`、`ci`、`test`、`style` 或 `release`；功能需求使用简短的小写 kebab-case。
- 本地工具遵循 `AGENTS.md` 与用户指定的分支规则，不因处理 CNB PR 而套用 NPC 前缀或改名已有分支。

## PR 与 Issue（所有 CNB PR 操作）

分支名可以含 CNB Issue 编号；CNB PR 标题和正文不携带 Issue 编号。标题遵循 Conventional Commits，正文完整保留 [PR 模板](../.github/PULL_REQUEST_TEMPLATE.md)，只勾选和填写，不删除未选项或 HTML 注释。

- 不添加 `close #xx`、Issue 编号或 GitHub/CNB 差异、关联提示；模板中的相关小节保留，无适用内容则留空。
- Issue 主阵地为 GitHub，需要的 `close #xx` 只在 GitHub 对应 PR 关联真实 GitHub Issue。
- 自查项按实际完成情况勾选，不编造链接或完成状态。

## 执行方式的归属

登录与鉴权、调用 `@codebuddy review`、触发任务和轮询结果等操作流程由 CNB 平台配置或本机工具 skill 维护，不放入本项目协作说明。执行时读取上述仓库约定；本文不授予创建、修改或发布 PR 的权限。
