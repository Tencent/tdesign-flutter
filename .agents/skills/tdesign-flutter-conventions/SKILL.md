---
name: tdesign-flutter-conventions
description: CNB 平台 NPC 的 TDesign Flutter 分支命名与 Issue 关联约定。仅在 CNB 平台执行时使用；通用 PR、Spec、Changelog、lint 和测试规则由 tdesign-flutter-general 维护。
---

# TDesign Flutter CNB 平台约定

仅补充 CNB 平台差异。先按 [`tdesign-flutter-general`](../tdesign-flutter-general/SKILL.md) 执行通用流程；组件对齐审查使用 [`tdesign-component-align-review`](../tdesign-component-align-review/SKILL.md)。规范本体为 [`CONTRIBUTING.md`](../../../CONTRIBUTING.md) 与 [`specs/README.md`](../../../specs/README.md)，本文不重复 PR 模板、Spec、更新日志、文档、双版本或 lint 要求。

## 分支命名

- CNB NPC 根据 CNB Issue 创建分支时，使用 `<cnb.username>/cnb-issue-<issue.number>/<types>/<功能需求>`，如 `rss1102/cnb-issue-31/fix/branch-auto-close-issue`。
- 无关联 CNB Issue 时使用 `<cnb.username>/<types>/<功能需求>`，如 `rss1102/chore/update-ci-config`。用户名与 Issue 编号从当前平台事实取得，不猜测，也不把 GitHub Issue 编号填入 CNB 前缀。
- `<types>` 按改动选择 `feat`、`fix`、`docs`、`refactor`、`chore`、`ci`、`test`、`style` 或 `release`；功能需求使用简短的小写 kebab-case。
- 以上前缀只约束 CNB NPC 创建的分支。通用工具按 `AGENTS.md` 和用户指定的分支规则执行，不因审查 CNB PR 而改名已有分支。

## PR 与 Issue

分支名可以含 CNB Issue 编号；PR 标题和正文不携带 Issue 编号，两者职责不同。PR 标题遵循 Conventional Commits，正文按通用 skill 完整保留 `.github/PULL_REQUEST_TEMPLATE.md`：

- CNB PR 不添加 `close #xx`、CNB Issue 编号或 GitHub/CNB 差异、关联提示；模板中的相关小节与 HTML 注释保留，无适用内容则留空。
- Issue 主阵地为 GitHub，需要的 `close #xx` 只在 GitHub 对应 PR 中关联真实 GitHub Issue。
- 模板自查项按实际完成情况勾选，不为满足检查而编造链接或已完成事项。

平台操作沿用当前任务授权；加载本 skill 不代表获准创建、修改或发布 PR。
