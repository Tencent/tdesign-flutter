# TDesign Flutter 工作区

- 仓库级 Cursor 资产统一维护在 `.harness/cursor/` 下。修改后请通过 `node scripts/init-cursor-harness.mjs` 重新生成 `.cursor/**` 和当前文件。
- 请把改动控制在正确的目录范围内：`tdesign-component/` 负责 Flutter 组件库与示例，`tdesign-site/` 负责文档站点，`tdesign-adaptation/` 负责兼容适配相关内容。
- 遵循现有仓库自动化边界。仓库级 Cursor 初始化逻辑放在 `scripts/` 下，Flutter 环境初始化仍放在 `tdesign-component/init.sh` 中。
- 修改仓库根目录的引导文档时，请将 `README.md` 与 `README_zh_CN.md` 视为源文件，并使用 `node scripts/sync-readme.mjs` 进行下游同步。
- 当用户提供 GitHub issue 链接并要求修复时，优先使用 skill **`issue-fix-entry`** 作为一键入口，再按 **`issue-fix-workflow`** 展开细节；并配合 issue workflow 相关 rules、agents、模板与 `scripts/issue-workflow/` 下的辅助脚本。强制检查通过后建议委托 **`code-review`** 子代理做 checklist 复审（见 `.harness/cursor/agents/code-review.md`）。
- issue 修复的分析、测试计划、验收报告与 PR 摘要应优先沉淀到 `requirements/issue-*/` 目录中，便于人类验收与后续追踪。
- **不要**手工修改 `tdesign-site/src/**/README.md`（站点打包生成物）；见 `rules/site/site-docs.mdc`。
- 提交 GitHub PR 时，正文须符合团队模版与注意事项，见 `rules/core/github-pr.mdc`（与 `.harness/templates/issue-fix/pr-body.md.tpl` 一致）。
- 优先保持小而聚焦的改动，遵循既有约定，并对变更影响范围执行针对性验证。
