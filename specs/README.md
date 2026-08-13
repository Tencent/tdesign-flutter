# Specs 方案

specs/ 用于记录复杂需求、重构、公共 API 变更和跨目录修复。它是普通的工程文档，不依赖 Cursor、Codex 或其他 AI 工具。

## 什么时候创建 Spec

以下情况建议先创建 Spec：

- 修改公共组件 API 或行为契约；
- 组件重构涉及多个文件、状态或交互路径；
- 需要同时修改组件、示例、测试和站点文档；
- Bug 根因复杂，或需要明确边界条件和人工验收步骤。

单行文案、格式调整和简单局部修复不要求创建完整 Spec。

## 标准目录

    specs/
    ├── README.md
    ├── _template/
    │   ├── spec.md
    │   ├── plan.md
    │   ├── tasks.md
    │   └── acceptance.md
    └── <number>-<short-name>/
        ├── spec.md
        ├── plan.md
        ├── tasks.md
        └── acceptance.md

目录编号按创建顺序递增，名称使用小写 kebab-case。已完成的 Spec 保留在仓库中，作为设计决策和验收记录。

## 操作流程

1. 复制 specs/_template/，创建新的编号目录。
2. 在 spec.md 中写清背景、目标、范围、非目标、行为契约和验收标准。
3. 在 plan.md 中记录技术方案、影响范围、API 变化、风险和验证策略。
4. 在 tasks.md 中拆分可执行任务，按 TODO、DOING、DONE 更新状态。
5. 实现代码、测试、示例和文档；不要只更新 Spec 而不落地代码。
6. 在 acceptance.md 中记录实际执行的命令、结果、未覆盖项和人工验收结论。
7. Review 时同时检查实现是否满足 spec.md，以及 Spec 是否准确反映最终实现。
8. 提交的代码必须与 spec.md 定义的行为契约、验收标准一致；若实现偏离 Spec，需先修订 Spec 再改代码，避免文档与实现长期分叉。
9. PR 描述「更新日志」小节应逐条反映实际变更：一个 PR 含多个功能 / 修复时按条目分开，遵循 `fix(组件): 修复 xxx`、`feat(组件): 新增 xxx` 等格式，与实现一一对应。（`tdesign-component/CHANGELOG.md` 由 CLI 自动生成，无需人工维护。）

## 文档边界

- spec.md 记录“要解决什么问题”和“最终应满足什么行为”。
- plan.md 记录“准备如何实现”。
- tasks.md 记录“还剩哪些工作”。
- acceptance.md 记录“实际验证了什么”。

如果实现过程中方案发生变化，先更新 Spec，再继续修改代码；不要让文档和实现长期分叉。
