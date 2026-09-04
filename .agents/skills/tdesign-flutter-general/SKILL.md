---
name: tdesign-flutter-general
description: TDesign Flutter 仓库面向所有 AI 助手（通用 Codex / Cursor 等）的通用协作约定，重点给出「何时创建 Spec」与「何时写更新日志」的判断规则（含每次组件修改 / 简单外部改动 / 用户可感知行为的四种情况），以及 Flutter 3.32.0 与 latest 双版本兼容、组件 breaking change 分析、文档来源与注释规范、代码质量 / lint 零告警等平台无关约定。平台无关规范以 CONTRIBUTING.md / specs/README.md 为唯一事实来源，本文档只做面向 AI 的落地提炼；CNB 平台专属执行细则见 .agents/skills/tdesign-flutter-conventions/SKILL.md。
---

# TDesign Flutter 仓库通用协作约定（AI 版）

本文档面向**所有**在本仓库工作的 AI 助手（通用 Codex / Cursor，以及 CNB 平台 NPC），提供平台无关的协作约定提炼。通用规范的**唯一事实来源**是 [`CONTRIBUTING.md`](../../../CONTRIBUTING.md) 与 [`specs/README.md`](../../../specs/README.md)，本文档只做面向 AI 的落地提炼，不重复维护权威内容；CNB 平台专属细则（分支命名 `cnb-issue-<issue.number>`、PR 不携带 Issue 编号等）见 `.agents/skills/tdesign-flutter-conventions/SKILL.md`。

Skills 按职责补充规范：本 skill 管通用协作与 CI 登记；[`tdesign-component-align-review`](../tdesign-component-align-review/SKILL.md) 管 Demo、API、Theme 与验收证据；[`tdesign-flutter-conventions`](../tdesign-flutter-conventions/SKILL.md) 仅管 CNB 分支及 Issue 差异。遇到冲突先核对规范本体与用户当前要求，不通过叠加规则扩大任务范围。

## 一、何时创建 Spec / 何时写更新日志（核心判断规则）

**「是否需要 Spec」与「是否需要更新日志」是两件独立的事**，由两套不同标准触发，不能互相推导：

- **要不要 Spec** → 看**改动复杂度 / 是否碰公共契约**（面向开发者 / 维护者）。
- **要不要写更新日志** → 看**用户感不感知得到**（面向用户，只写用户可感知的变更）。

两轴交叉即四种情况（完整细则见 [`CONTRIBUTING.md`](../../../CONTRIBUTING.md)「PR 更新日志规范」）：

| 用户是否可感知 ↓ | 可感知 | 无感 |
| --- | --- | --- |
| 复杂需求 / 公共契约变更 / 组件重构 / 跨目录改动（需 Spec） | **两者都要** | **只要 Spec**、不写日志 |
| 简单局部修复 / 文案 / 格式等（无需完整 Spec） | **只要日志** | **两者都不需要** |

**最容易出错**：把"勾选「本条 PR 不需要纳入 Changelog」"等同于"不需要 Spec"——这是错误的。行为不变的纯内部重构（用户无感、不写日志）仍属于组件修改，**需要 Spec**（Review 结合实际改动判定，属于重构）。

## 二、提交 PR 与更新日志格式

- PR 标题遵循 Conventional Commits：`type(scope): 描述`；平台 Issue 规则见 CNB skill，通用分支规则见 `AGENTS.md`。
- PR 正文**完整保留 `.github/PULL_REQUEST_TEMPLATE.md` 原模板结构**（所有勾选项含未选 `[ ]`、所有 HTML 注释原样保留），只打勾 / 填写，不删减。
- 更新日志条目遵循 Conventional Commits 的 commit type，与最终分组固定对应（完整见 [`CONTRIBUTING.md`](../../../CONTRIBUTING.md)）：

  | commit type | 最终分组 | 示例 |
  | --- | --- | --- |
  | `breaking` | Breaking Changes | breaking(toast): 调整 xxx 默认行为 |
  | `feat` | Features | feat(TButton): 新增渐变背景能力 |
  | `fix` | Bug Fixes | fix(TInput): 修复密文模式下无法粘贴的问题 |
  | `perf`、`refactor` | Performance | refactor(toast): 优化 xxx |
  | `docs` | Documentation | docs: 更新主题生成器文档 |
  | 其他（`chore` 等） | Others | chore: 升级依赖 |

- **Breaking change 一律用 `breaking` commit type**（如 - breaking(toast): 调整 xxx 默认行为），自动归入 Breaking Changes 分组。
- `tdesign-component/CHANGELOG.md` 由 CLI 自动生成，**无需人工维护**。

## 三、Spec 流程

第一节判定需要 Spec 后，按 [`specs/README.md`](../../../specs/README.md) 创建或更新对应 `specs/<编号>-<短名称>/`（spec / plan / tasks / acceptance）；提交代码须与 Spec 行为契约一致，方案变更先更新 Spec 再改代码，并在 PR 附对应目录链接。

## 四、Flutter 双版本兼容

同时兼容 `flutter@3.32.0` 与 `flutter@latest`（stable 最新版）。改动时确认所用 API 在两版本均可用且行为一致，避免 low 版不可用 / high 版已移除；结论中标注对两版本的兼容性影响。

## 五、组件变更的 breaking change 分析

- 改公开 API 签名 / 默认行为 / 删除能力 → breaking change，需重点提示并评估迁移策略。
- 仅新增可选参数且不改变既有行为，通常不算 breaking；新增必填参数或改变默认值需谨慎。
- 输出时明确：是 / 否 breaking change、影响范围、受影响 API、迁移建议。

## 六、文档来源与注释规范（注释即文档）

| 文档载体 | 职责 | 何时维护 |
|---------|------|---------|
| **dartdoc 注释**（`///`） | 组件公开 API 的**用户文档** | 新增 / 修改公开 API 时**必须同步** |
| **Spec** | 复杂需求 / 重构的设计文档 | 见「何时创建 Spec / 何时写更新日志」一节，先 Spec 后代码 |
| **PR 更新日志** | 面向使用方用户的变更说明 | 见「何时创建 Spec / 何时写更新日志」一节，只写用户可感知的变更 |
| **CHANGELOG.md** | 由 CLI 自动生成 | 不手动编辑 |
| **CONTRIBUTING.md / specs/README.md** | 规范唯一事实来源 | 需引用时统一指向 |

公开字段 / 参数 / 回调 / 枚举 / 类的 `///` 注释要写清"是什么、默认值、生效条件、三态语义、与相关字段关系"，注释必须与实现一致。

## 七、脚本生成的产物（供 AI 理解，贡献者无需关注）

本仓库的 **API 文档、示例代码片段、README 副本** 均由脚本从源码生成，`.github/workflows/autofix.yml` 会在 PR 时**自动运行**这些脚本并提交修正，因此**贡献者（人类）无需手动关注 / 运行它们**。但 **AI 助手需要理解每个脚本具体做什么**，以便在改动相关源文件时知道哪些产物是自动生成的、是否需要手动运行或校验：

1. **API 文档**：`sh ./demo_tool/all_build.sh`（等价 `node tool/generate_api.mjs`，manifest 驱动），从组件 API 生成 `example/assets/api/<component>_api.md`；新增 / 迁移组件时先更新 `tool/components.json`。改动设计 / 组件 API 时该产物会随之变化。
2. **示例代码片段**：`dart run tool/generate_example_code.dart`，从带 `@ExampleCode` 注解的示例方法生成 `example/assets/code/*.txt`；CI 用 `--check` 校验片段与源码同步。改动示例方法时该产物会随之变化。
3. **README 副本**：`node scripts/sync-readme.mjs`，把根目录 `README.md` / `README_zh_CN.md` 同步到 `tdesign-component/README*.md` 与 `tdesign-site/site/docs/getting-started.md`。改动根目录 README 时副本会随之同步。

自动生成与本地验收不是同一件事：贡献者无需手工维护产物；组件对齐任务需要核对示例时，按 Review skill 校验生成片段，变化只能来自源文件，不能直接修改产物。

## 八、组件测试与 CI 回归门禁

仓库使用集中式回归调度器，新增组件或为既有组件新增测试时，须按 [`CONTRIBUTING.md`](../../../CONTRIBUTING.md)「组件测试与 CI 回归门禁」登记：

- 组件测试文件加入 `tool/run_component_regression.dart` 的 `componentTestSuites`；
- 生产源码范围加入 `tool/check_component_coverage.dart` 的 `componentTargets`，手写生产 Dart 行覆盖率 `LH/LF >= 95%`；
- Demo 结构、功能与交互测试登记到 GitHub / CNB 的双版本功能回归入口；纯 Golden 测试加入 `tool/run_visual_regression.dart` 的 `visualTestSuites`。执行环境与两类测试的分流要求见 Review skill 第 5 节；不得用视觉入口代替功能入口。
- 运行调度器自测，确认三个清单同步且登记文件存在。

测试文件存在、Golden 已提交或本地单独运行通过，不代表 CI 已执行；必须读取 CI 实际入口并确认测试已被调度。

## 九、代码质量 / lint 零告警

提交前运行 `flutter analyze --fatal-infos`，要求无诊断问题。能用 `const` 必须 `const`、优先 `final`、避免 lambda 替代 tear-off，并遵循当前 `analysis_options.yaml`；CI 配置仅证明已设门禁，是否通过需读取实际运行结果。

## 回答风格

- 回答使用与提问相同的语言（中文 / 英文）。
- 结论先行，给出明确判断，再附必要依据与可操作建议。
- 需要执行平台操作（建分支、提 PR、评论等）时，先核对仓库协作规范再动手。
