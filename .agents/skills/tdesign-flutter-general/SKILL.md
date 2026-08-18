---
name: tdesign-flutter-general
description: TDesign Flutter 仓库面向所有 AI 助手（通用 Codex / Cursor 等）的通用协作约定，重点给出「何时创建 Spec」与「何时写更新日志」的判断规则（含每次组件修改 / 简单外部改动 / 用户可感知行为的四种情况），以及 Flutter 3.32.0 与 latest 双版本兼容、组件 breaking change 分析、文档来源与注释规范、代码质量 / lint 零告警等平台无关约定。平台无关规范以 CONTRIBUTING.md / specs/README.md 为唯一事实来源，本文档只做面向 AI 的落地提炼；CNB 平台专属执行细则见 .agents/skills/tdesign-flutter-conventions/SKILL.md。
---

# TDesign Flutter 仓库通用协作约定（AI 版）

本文档面向**所有**在本仓库工作的 AI 助手（通用 Codex / Cursor，以及 CNB 平台 NPC），提供平台无关的协作约定提炼。通用规范的**唯一事实来源**是 [`CONTRIBUTING.md`](../../../CONTRIBUTING.md) 与 [`specs/README.md`](../../../specs/README.md)，本文档只做面向 AI 的落地提炼，不重复维护权威内容；CNB 平台专属细则（分支命名 `cnb-issue-<issue.number>`、PR 不携带 Issue 编号等）见 `.agents/skills/tdesign-flutter-conventions/SKILL.md`。

## 一、何时创建 Spec / 何时写更新日志（核心判断规则）

**「是否需要 Spec」与「是否需要更新日志」是两件独立的事**，由两套不同标准触发，不能互相推导：

- **要不要 Spec** → 看**改动复杂度 / 是否碰公共契约**（面向开发者 / 维护者）。
- **要不要写更新日志** → 看**用户感不感知得到**（面向用户，只写用户可感知的变更）。

两轴交叉即四种情况（完整细则见 [`CONTRIBUTING.md`](../../../CONTRIBUTING.md)「PR 更新日志规范」）：

| 用户是否可感知 ↓ | 可感知 | 无感 |
| --- | --- | --- |
| 碰组件 / 公共契约（要 Spec） | **两者都要** | **只要 Spec**、不写日志（纯内部重构） |
| 不碰组件（纯文档 / 依赖 / CI） | （罕见）只要日志 | **两者都不需要** |

**最容易出错**：把"勾选「本条 PR 不需要纳入 Changelog」"等同于"不需要 Spec"——这是错误的。行为不变的纯内部重构（用户无感、不写日志）仍属于组件修改，**需要 Spec**（Review 结合实际改动判定，属于重构）。

一句话记忆：**Spec 看"改动复不复杂 / 碰不碰公共契约"，更新日志看"用户感不感知得到"**。

## 二、提交 PR 与更新日志格式

- PR 正文**完整保留 `.github/PULL_REQUEST_TEMPLATE.md` 原模板结构**（所有勾选项含未选 `[ ]`、所有 HTML 注释原样保留），只打勾 / 填写，不删减。
- 更新日志条目遵循 Conventional Commits 的 commit type，与最终分组固定对应（完整见 [`CONTRIBUTING.md`](../../../CONTRIBUTING.md)）：

  | commit type | 最终分组 | 示例 |
  | --- | --- | --- |
  | `breaking` | Breaking Changes | `breaking(toast): 调整 xxx 默认行为` |
  | `feat` | Features | `feat(TButton): 新增渐变背景能力` |
  | `fix` | Bug Fixes | `fix(TInput): 修复密文模式下无法粘贴的问题` |
  | `perf`、`refactor` | Performance | `refactor(toast): 优化 xxx` |
  | `docs` | Documentation | `docs: 更新主题生成器文档` |
  | 其他（`chore` 等） | Others | `chore: 升级依赖` |

- **Breaking change 一律用 `breaking` commit type**（如 `- breaking(toast): 调整 xxx 默认行为`），自动归入 Breaking Changes 分组。
- `tdesign-component/CHANGELOG.md` 由 CLI 自动生成，**无需人工维护**。
- **更新日志条目一律用普通列表项，不要用行内代码块（反引号 `` ` ``）包裹**：上文表格里的反引号（如 `` `breaking(toast): ...` ``）**只是用于展示格式的示例写法**，填写 PR 描述「更新日志」小节时要把这些反引号去掉，写成纯文本条目（`- breaking(TFab): 调整 xxx 默认行为`）。否则会污染自动生成的 CHANGELOG 与仓库既有口径。

## 三、Spec 流程

复杂需求 / 公共 API 变更 / 组件重构 / 跨目录改动，按 [`specs/README.md`](../../../specs/README.md) 创建 `specs/<编号>-<短名称>/`（spec / plan / tasks / acceptance）；提交代码须与 Spec 行为契约一致，方案变更先更新 Spec 再改代码。单行文案、格式调整、简单局部修复不要求。

## 四、Flutter 双版本兼容

同时兼容 `flutter@3.32.0` 与 `flutter@latest`（stable 最新版）。改动时确认所用 API 在两版本均可用且行为一致，避免 low 版不可用 / high 版已移除；结论中标注对两版本的兼容性影响。

## 五、组件变更的 breaking change 分析

- 改公开 API 签名 / 默认行为 / 删除能力 → breaking change，需重点提示并评估迁移策略。
- 仅新增可选参数且不改变既有行为，通常不算 breaking；新增必填参数或改变默认值需谨慎。
- 涉及公共 API 变更 / 组件重构时按规范创建 Spec。
- 输出时明确：是 / 否 breaking change、影响范围、受影响 API、迁移建议。

## 六、文档来源与注释规范（注释即文档）

| 文档载体 | 职责 | 何时维护 |
|---------|------|---------|
| **dartdoc 注释**（`///`） | 组件公开 API 的**用户文档** | 新增 / 修改公开 API 时**必须同步** |
| **Spec** | 复杂需求 / 重构的设计文档 | 见第一节，先 Spec 后代码 |
| **PR 更新日志** | 面向使用方用户的变更说明 | 见第一节，只写用户可感知的变更 |
| **CHANGELOG.md** | 由 CLI 自动生成 | 不手动编辑 |
| **CONTRIBUTING.md / specs/README.md** | 规范唯一事实来源 | 需引用时统一指向 |

公开字段 / 参数 / 回调 / 枚举 / 类的 `///` 注释要写清"是什么、默认值、生效条件、三态语义、与相关字段关系"，注释必须与实现一致。

## 七、API 文档 / 示例代码改动的脚本同步

本仓库存在**由脚本生成并需随源码一并提交**的产物，改动设计 API 或示例代码时，**必须运行对应生成脚本**，确保生成产物与源码同步后再提交，否则会出现源码与文档/示例不一致、CI 校验失败的问题：

1. **修改设计 / 组件 API 时** → 在 `tdesign-component` 目录运行 `sh ./demo_tool/all_build.sh`（即 `node tool/generate_api.mjs`），重新生成并提交 `example/assets/api/<component>_api.md`。新增或迁移组件时先更新 `tool/components.json` 再生成。
2. **修改示例代码（带 `@ExampleCode` 注解的示例方法）时** → 在 `tdesign-component` 目录运行 `dart run tool/generate_example_code.dart --verbose`，重新生成并提交 `example/assets/code/*.txt`。CI 会用 `dart run tool/generate_example_code.dart --check` 校验这些片段是否与源码同步。

提交前务必让本地生成的产物与源码同一次提交，不要漏提生成文件。

## 八、代码质量 / lint 零告警

提交前过 `flutter analyze`，目标 **0 error / 0 warning**。能用 `const` 必须 `const`、优先 `final`、避免 lambda 代替 tear-off、遵循 `directives_ordering`、统一单引号、优先集合字面量、用 `.isEmpty`/`.isNotEmpty` 判空、统一 `${param}` 插值，全部对齐 `tdesign-component/analysis_options.yaml`；CI 的 `.cnb.yml` 已加 analyze 兜底。

## 回答风格

- 回答使用与提问相同的语言（中文 / 英文）。
- 结论先行，给出明确判断，再附必要依据与可操作建议。
- 需要执行平台操作（建分支、提 PR、评论等）时，先核对仓库协作规范再动手。
