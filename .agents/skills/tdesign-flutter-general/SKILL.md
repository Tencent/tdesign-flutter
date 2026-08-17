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

据此区分**四种情况**：

1. **组件本身的修改**（改 API / 行为契约 / 样式交互，无论内部重构还是功能调整）→ **需要 Spec** 跟踪方案（先 Spec 后代码，提交时 PR 附 Spec 链接），且凡用户可感知的变更**都要写更新日志**。若属重构（行为不变）则写日志与否取决于用户是否可感知。
2. **简单外部改动**（不改动组件本身，如纯外部文档 / 依赖升级 / CI / 单行文案）→ **不需要 Spec**，也**不需要更新日志**（用户无感，勾选「本条 PR 不需要纳入 Changelog」）。
3. **用户可感知的行为变更**（API、样式、交互、性能、体验等）→ **必须写更新日志**；若是 breaking change（改公开 API 签名 / 默认行为 / 删除能力）还用 `breaking` commit type。
4. **既改组件、又产生用户可感知行为** → 第 1 与第 3 叠加：**既要 Spec**，**也要写更新日志**。

**最容易出错**：把"勾选不需要纳入 Changelog"等同于"不需要 Spec"——这是错误的。行为不变的纯内部重构（用户无感、不写日志）仍可能需要 Spec（Review 结合实际改动判定，属于重构）。

一句话记忆：**Spec 看"改动复不复杂 / 碰不碰公共契约"，更新日志看"用户感不感知得到"**。

## 二、提交 PR 与更新日志格式

- PR 正文**完整保留 `.github/PULL_REQUEST_TEMPLATE.md` 原模板结构**（所有勾选项含未选 `[ ]`、所有 HTML 注释原样保留），只打勾 / 填写，不删减。
- 更新日志条目遵循 Conventional Commits 的 commit type，与最终分组固定对应：`breaking`→Breaking Changes、`feat`→Features、`fix`→Bug Fixes、`perf`/`refactor`→Performance、`docs`→Documentation、其他→Others。
- **Breaking change 用 `breaking` commit type**（如 `- breaking(toast): 调整 xxx 默认行为`），自动归入 Breaking Changes 分组，不再使用 `⚠️` 前缀。
- `tdesign-component/CHANGELOG.md` 由 CLI 自动生成，**无需人工维护**。

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

## 七、代码质量 / lint 零告警

提交前过 `flutter analyze`，目标 **0 error / 0 warning**。能用 `const` 必须 `const`、优先 `final`、避免 lambda 代替 tear-off、遵循 `directives_ordering`、统一单引号、优先集合字面量、用 `.isEmpty`/`.isNotEmpty` 判空、统一 `${param}` 插值，全部对齐 `tdesign-component/analysis_options.yaml`；CI 的 `.cnb.yml` 已加 analyze 兜底。

## 回答风格

- 回答使用与提问相同的语言（中文 / 英文）。
- 结论先行，给出明确判断，再附必要依据与可操作建议。
- 需要执行平台操作（建分支、提 PR、评论等）时，先核对仓库协作规范再动手。
