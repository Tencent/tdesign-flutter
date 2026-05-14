---
name: issue-fix-workflow
description: 处理 Tencent/tdesign-flutter 仓库中的 GitHub issue 修复流程。适用于用户提供 issue 链接、issue 编号、要求按贡献指南修复 issue、生成 requirements 验收文档、提交 PR 等场景。
---

# Issue 修复工作流

用户给出 issue 链接后，按下面这条固定流程执行：

> 分析需求、编写用例（必要检查）、加载贡献指南、生成代码、跑强制检查、**checklist 复审**、循环优化代码，直到检查与复审结论收敛、生成验收文档（按指定输出模版，方便人类验收）、提交 PR

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
5. 按贡献指南实现修复，测试与示例分两条落实（**不要**手工修改 `tdesign-site/src/**/README.md`，站点打包生成物见 `rules/site/site-docs.mdc`）：
   - **单元 / 集成测试**：在 `tdesign-component/test/`（等）补充或更新用例，用于锁定逻辑与回归，保证 `flutter test` 可重复执行。
   - **示例验收（Example）**：若需人工走查 UI/交互或与示例稿对齐，在对应组件示例页的 `ExamplePage(..., test: [...])` 中增加 `ExampleItem`；用于人类验收，**不替代**上一条。
6. 按下列规则做 Self Review：
   - 类声明后先写构造方法，字段在构造方法下方
   - API 注释统一用 `///`
   - 新增组件类或 API 生成入口时检查 `tdesign-component/demo_tool/all_build.sh`
   - 组件内部样式 token 优先使用 `TTheme.of(context)`
   - 组件内部固定文案优先使用 `TResourceDelegate`
7. 跑最小必要验证，再运行 `node scripts/issue-workflow/check-issue-fix.mjs ...` 做强制检查。
8. **委托 `code-review` 子代理**（见 `.harness/cursor/agents/code-review.md`）：在脚本通过后对照 checklist 复审（含脚本未覆盖项：Example.test、文档与 requirements 一致性等）；将结论同步进 `code-review-report.md`，必要时返工后再跑步骤 7。
9. 通过后补全 `code-review-report.md`、`acceptance-report.md` 与 `pr-body.md`（`pr-body.md` 须符合 `.harness/templates/issue-fix/pr-body.md.tpl` 结构，并遵守 `rules/core/github-pr.mdc` 的注意事项）。
10. 最后提交 commit 并**优先自动创建 PR**（见下节「发起 PR」）；目标分支默认 **`develop`**；PR 正文以 `pr-body.md` 为底稿，提交前按 `github-pr` 规则删除说明注释并完成自查清单勾选。

## 发起 PR（优先自动化）

在本地 commit 完成后，**应先自行执行**（或由具备终端与 GitHub 权限的自动化执行），不要默认假定用户会手工开 PR：

1. `git push -u origin <修复分支>`
2. 若该分支尚无 PR：`gh pr create --base develop --head <修复分支> --title "<符合团队格式的标题>" --body-file requirements/issue-*/pr-body.md`（已存在 PR 时可用 `gh pr view` 确认链接即可）。

**仅当 `git push` 或 `gh pr create` 失败**（无远端写权限、`gh` 未登录、网络错误、需走 fork 工作流等）时，才在回复中说明失败原因，并给出需用户本地执行的补救步骤（如 `gh auth login`、配置 fork remote、在网页端从分支创建 PR 等）。成功时应在收尾输出中给出 **PR 链接**。

## PR 提交后的下一步建议

在已成功发起 PR 并向用户交付 **PR 链接** 后，收尾回复中应**补充一段下一步建议**（与团队 CI 实际产物表述一致即可），例如：

1. **等待构建**：关注该 PR 在 GitHub Actions（或仓库约定流水线）中的检查结果，待 **demo 示例 APK**（或等价产物名称）构建成功并完成归档/上传。
2. **安装验收**：下载并安装上述 APK，按 `requirements/issue-*/test-cases.md` 与示例页场景做人工走查验收。
3. **闭环修改**：若验收中发现问题，在 PR 或关联 issue 中反馈现象与复现路径，再回到本 workflow 做小步修复、推送更新分支并等待新一轮构建，直至验收通过。

## 输出要求

执行结束时，至少应交付：

- issue 修复分支
- 代码改动与测试（含单元/集成测试；按需含 Example `test` 区块）
- `requirements/issue-*/` 下的完整文档
- PR 链接
- **PR 提交后的下一步建议**（见上节「PR 提交后的下一步建议」，便于人类等待 demo APK 并安装验收、有问题再反馈迭代）

## 注意事项

- 如果工作区里有与当前 issue 无关的未提交改动，先让用户决定如何处理。
- 若强制检查失败，不要跳过；修复后重新执行。
- 如果自动化无法稳定判定某一项，必须在 `code-review-report.md` 或 `acceptance-report.md` 中明确写出人工复核结论。
- **发起 PR**：默认定序为「尝试自动 push + `gh pr create` → 失败再提示本地操作」，避免把本可由代理完成的步骤默认推给用户。
