# Cursor Harness 说明

这个目录是当前仓库 Cursor 项目级规则、技能和子代理配置的唯一维护源。

## 目录结构

```text
.harness/
  cursor/
    AGENTS.md
    rules/
    skills/
    agents/
  templates/
    issue-fix/
```

## 映射关系

- `.harness/cursor/rules/**` -> `.cursor/rules/**`
- `.harness/cursor/skills/**` -> `.cursor/skills/**`
- `.harness/cursor/agents/**` -> `.cursor/agents/**`
- `.harness/cursor/AGENTS.md` -> `AGENTS.md`

生成产物由 `scripts/init-cursor-harness.mjs` 统一管理。
不要直接修改 `.cursor/**` 或仓库根目录下的 `AGENTS.md`；请在这里更新源文件后重新执行初始化脚本。

## 常用命令

```bash
node scripts/init-cursor-harness.mjs
node scripts/init-cursor-harness.mjs --check
node scripts/init-cursor-harness.mjs --clean
node scripts/init-cursor-harness.mjs --force
node scripts/issue-workflow/init-issue-fix.mjs --help
node scripts/issue-workflow/check-issue-fix.mjs --help
```

## 维护方式

1. 在 `.harness/cursor/` 下新增或修改 rule、skill、subagent，或更新 `AGENTS.md`。
2. 执行 `node scripts/init-cursor-harness.mjs`。
3. 等生成后的 `.cursor` 文件刷新完成后，再在仓库中使用 Cursor。

## Issue Workflow

这套 harness 额外沉淀了一条面向 issue 修复的标准流程，覆盖：

1. 读取 issue 与贡献指南
2. 创建分支
3. 分析根因与修复方案
4. 编写测试与必要检查
5. 按规范实现代码
6. 生成 `requirements/` 下的验收文档
7. 执行强制检查
8. 整理 PR

相关资产分布：

- `.harness/cursor/skills/issue-fix-entry/`：**一键入口** skill（从 issue 链接到 init、检查、PR 的最短路径）
- `.harness/cursor/skills/issue-fix-workflow/`：主流程 skill（详细步骤与注意事项）
- `.harness/cursor/rules/`：issue 修复与 Flutter 代码规范规则
- `.harness/cursor/agents/`：问题分析、Review、验收文档编写等子代理
- `.harness/templates/issue-fix/`：`requirements/` 文档模板
- `scripts/issue-workflow/`：初始化模板与强制检查脚本

示例参考：

- `requirements/issue-924-fab-on-long-press/`

## 说明

- 同步脚本会写入 `.cursor/.harness-manifest.json`，用于记录受管理的生成文件。
- 默认只会覆盖或清理 manifest 管理的文件。
- 仓库文档同步仍然沿用现有的 `scripts/sync-readme.mjs` 流程。
- issue workflow 的脚本面向“给定 issue 链接后由 AI 协助执行”的场景，强制检查只负责能被机器稳定判定的部分，仍需结合 code review 清单做人工复核。
