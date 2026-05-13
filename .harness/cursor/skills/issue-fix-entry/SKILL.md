---
name: issue-fix-entry
description: 一键启动 Tencent/tdesign-flutter 的 GitHub issue 修复流程。适用于用户提供 issue 链接或编号并说「按 harness 修 issue」「一键 issue」「开始修 issue」等场景；串联贡献指南、requirements 模板初始化、强制检查与 PR 收尾。
---

# Issue 修复一键入口

收到 issue 链接或编号后，**不要先写代码**。按下面顺序执行；详细步骤与规范说明见同目录下的 [issue-fix-workflow/SKILL.md](../issue-fix-workflow/SKILL.md)。

## 0. 前置检查（必做）

- 若工作区有与当前 issue **无关**的未提交改动，先向用户确认是暂存、另分支还是继续。
- 确认可执行：`gh`、`git`、`node`；能访问 GitHub（`gh issue view` 成功）。

## 1. 加载贡献指南（必做）

- 阅读仓库根目录 [CONTRIBUTING.md](../../../../CONTRIBUTING.md)。
- 对照 [TDesign Flutter 贡献指南](https://tdesign.tencent.com/flutter/develop)：**4. 开发规范**、**5.2 代码 Review 自检**、**5.3 文档自检**。

## 2. 拉取 issue 并定分支名（必做）

```bash
gh issue view <ISSUE_NUMBER> --repo Tencent/tdesign-flutter
```

从标题提炼 `slug`（小写、连字符），分支名建议：

```text
fix/issue-<ISSUE_NUMBER>-<slug>
```

创建并切换分支：

```bash
git fetch origin develop
git checkout -b fix/issue-<ISSUE_NUMBER>-<slug> origin/develop
```

（若团队约定从其他分支拉取，以用户或仓库约定为准。）

## 3. 初始化 requirements 骨架（必做）

将占位符换成实际值后执行：

```bash
node scripts/issue-workflow/init-issue-fix.mjs \
  --issue-number <ISSUE_NUMBER> \
  --issue-url "https://github.com/Tencent/tdesign-flutter/issues/<ISSUE_NUMBER>" \
  --issue-title "<从 gh issue view 复制的标题>" \
  --slug "<slug>" \
  --component "<组件名或主题，如 TFab>"
```

若目录已存在且需覆盖，加 `--force`。

## 4. 执行完整修复流程（必做）

从这一步起，**严格按** [issue-fix-workflow/SKILL.md](../issue-fix-workflow/SKILL.md) 执行，包括：

- 在 `TaskContract.md`、`test-cases.md` 中写清根因、方案与用例后再改代码。
- 实现、测试、`ExamplePage.test`（如适用）、站点/API 文档（如适用）。
- 按需委托子代理：`issue-analyst`、`flutter-issue-reviewer`、`acceptance-writer`（见 `.harness/cursor/agents/`）。

## 5. 强制检查（必做，未通过不得收尾）

按实际路径传入 `--requirements-dir` 与 `--component-file` 等：

```bash
node scripts/issue-workflow/check-issue-fix.mjs \
  --requirements-dir requirements/issue-<ISSUE_NUMBER>-<slug> \
  --component-file tdesign-component/lib/src/components/<path>/<file>.dart \
  --class-name <ClassName> \
  --all-build tdesign-component/demo_tool/all_build.sh \
  --require-all-build-class
```

说明：若本次**未新增**需在 `all_build.sh` 中登记的类，可去掉 `--require-all-build-class`（以贡献指南 5.3 为准）。

检查失败则修代码或文档后**重新运行**，直至通过。

## 6. 同步 harness 到 Cursor（若刚改过 `.harness`）

```bash
node scripts/init-cursor-harness.mjs
```

## 7. 提交与 PR（必做）

- 提交信息建议：`fix(<scope>): <简述> (fixes #<ISSUE_NUMBER>)` 或团队约定格式。
- PR 目标分支默认 **`develop`**；正文可基于 `requirements/issue-*/pr-body.md` 粘贴并补全。
- PR 中关联 issue（链接或 `fixes #xxx`）。

## 一键记忆口诀

**读 issue → 开分支 → init requirements → 按 workflow 改 → check 通过 → 提交 PR。**
