---
name: issue-fix-workflow
description: 处理 Tencent/tdesign-flutter 仓库中的 GitHub issue 修复流程。适用于用户提供 issue 链接、issue 编号、要求按贡献指南修复 issue、生成 requirements 验收文档、提交 PR 等场景。
---

# Issue 修复工作流

用户给出 issue 链接后，按下面这条固定流程执行：

> 分析需求、编写用例（必要检查）、加载贡献指南、生成代码、检查必要操作、循环优化代码，知道检查通过、生成验收文档（按指定输出模版，方便人类验收）、提交pr

## 固定参考

开始前先读取并对照：

- `CONTRIBUTING.md`
- https://tdesign.tencent.com/flutter/develop 的 `4. 开发规范`
- https://tdesign.tencent.com/flutter/develop 的 `5.2 代码 Review 自检`
- https://tdesign.tencent.com/flutter/develop 的 `5.3 文档自检`

补充参考：

- `requirements/issue-924-fab-on-long-press/`
- `requirements/issue-900-tab-bar/`
- [reference.md](reference.md)

## 标准步骤

1. 用 `gh issue view` 读取 issue，输出问题描述、根因假设、修复方案和风险点。
2. 创建专用分支，默认格式：`fix/issue-<number>-<slug>`。
3. 运行 `node scripts/issue-workflow/init-issue-fix.mjs ...` 初始化 `requirements/issue-*/` 文档骨架。
4. 先补 `TaskContract.md` 与 `test-cases.md`，再开始实现代码。
5. 按贡献指南实现修复，并补充必要测试或 `ExamplePage.test` 用例；**不要**手工修改 `tdesign-site/src/**/README.md`（站点打包生成物，见 `rules/site/site-docs.mdc`）。
6. 按下列规则做 Review：
   - 类声明后先写构造方法，字段在构造方法下方
   - API 注释统一用 `///`
   - 新增组件类或 API 生成入口时检查 `tdesign-component/demo_tool/all_build.sh`
   - 组件内部样式 token 优先使用 `TTheme.of(context)`
   - 组件内部固定文案优先使用 `TResourceDelegate`
7. 跑最小必要验证，再运行 `node scripts/issue-workflow/check-issue-fix.mjs ...` 做强制检查。
8. 通过后补全 `code-review-report.md`、`acceptance-report.md` 与 `pr-body.md`（`pr-body.md` 须符合 `.harness/templates/issue-fix/pr-body.md.tpl` 结构，并遵守 `rules/core/github-pr.mdc` 的注意事项）。
9. 最后提交 commit 并创建 PR，目标分支默认是 `develop`；PR 正文以 `pr-body.md` 为底稿，提交前按 `github-pr` 规则删除说明注释并完成自查清单勾选。

## 输出要求

执行结束时，至少应交付：

- issue 修复分支
- 代码改动与测试
- `requirements/issue-*/` 下的完整文档
- PR 链接

## 注意事项

- 如果工作区里有与当前 issue 无关的未提交改动，先让用户决定如何处理。
- 若强制检查失败，不要跳过；修复后重新执行。
- 如果自动化无法稳定判定某一项，必须在 `code-review-report.md` 或 `acceptance-report.md` 中明确写出人工复核结论。
