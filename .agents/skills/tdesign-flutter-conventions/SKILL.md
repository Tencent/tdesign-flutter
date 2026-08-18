---
name: tdesign-flutter-conventions
description: TDesign Flutter 仓库面向 CNB 平台 NPC 的执行约定（基于 Issue 创建分支的 cnb-issue-<issue.number> 命名、PR 模板填写、close #xx 关联 Issue 等平台特有细则）。通用规范（何时建 Spec / 何时写更新日志、Flutter 双版本兼容、breaking change 分析、文档与注释、lint 零告警）以 CONTRIBUTING.md / specs/README.md 及通用 skill .agents/skills/tdesign-flutter-general/SKILL.md 为准，本文档只补充 CNB 平台特有的执行细则、不重复通用规则。任何 CNB 平台 NPC 在本仓库执行创建分支、提交 PR、分析组件改动、维护组件注释与文档、检查代码质量等任务时，都应先加载并遵守本约定。
---

# TDesign Flutter 仓库协作约定（CNB NPC 版）

本 skill 是 CNB 平台 NPC 在本仓库执行任务时遵循的执行约定。通用开发 / 协作 / Spec 规范以 [`CONTRIBUTING.md`](../../../CONTRIBUTING.md) 与 [`specs/README.md`](../../../specs/README.md) 为准，**平台无关的落地提炼**见通用 skill [`../tdesign-flutter-general/SKILL.md`](../tdesign-flutter-general/SKILL.md)（含「何时建 Spec / 何时写更新日志」四种情况、Flutter 双版本、breaking change、文档注释、lint 等），本文档**只补充 CNB 平台 NPC 特有**的细则、不重复通用规则。

## 一、分支与 PR 规范

在创建 PR / 分支时，必须严格遵守以下分支命名约定。

> **与 AGENTS.md 的区别**：本 skill 是 CNB 平台专属约定，能获取到 CNB 平台的 Issue 编号，因此基于 Issue 创建时使用 `cnb-issue-<issue.number>` 格式；而 AGENTS.md 面向无法获取 CNB Issue 编号的通用 AI 工具（Codex / Cursor 等），故统一使用不携带 Issue 编号的通用格式 `<cnb.username/>/<types>/<功能需求>`。两者不冲突：**CNB 平台上的 NPC 以本 skill 为准**，通用工具以 AGENTS.md 为准。

- **根据 Issue 创建的分支 / PR**（最常见）：格式 `<cnb.username/>/cnb-issue-<issue.number>/<types>/<功能需求>`
  - `<cnb.username/>`：当前操作者的 CNB 用户名（不要猜测，通过环境变量或平台信息获取）。
  - `cnb-issue-<issue.number>`：固定前缀 `cnb-issue-` + 所关联 Issue 的编号，用于把分支 / PR 与具体需求绑定、便于回溯，并明确标识该需求来源于 CNB Issue。
  - `<types>`：改动类型，从以下取值中选择一个最贴切的：
    - `feat`：新特性 / 新组件
    - `fix`：缺陷修复
    - `docs`：文档改进
    - `refactor`：重构（不改变行为）
    - `chore`：构建、工具、依赖等杂项
    - `ci`：CI/CD 相关改动
    - `test`：测试用例
    - `style`：样式 / 交互改进
    - `release`：版本发布
  - `<功能需求>`：用简短、小写、以连字符分隔的英文短语描述本次改动要解决的功能需求。
  - 示例：`rss1102/cnb-issue-31/fix/branch-auto-close-issue`、`rss1102/cnb-issue-22/feat/add-badge-component`
- **无关联 Issue 的独立改动**：格式 `<cnb.username/>/<types>/<功能需求>`
  - 仅当本次改动确实没有对应 Issue 时使用，例如 `rss1102/chore/update-ci-config`。
- **PR 标题**遵循 Conventional Commits 格式：`type(scope): 修改描述`，scope 可填写组件、文档或 CI 模块，例如 `fix(TButton): 修复按钮溢出问题`。
- 在创建分支、提交 PR 前，先复核分支名是否符合上述规范（有 Issue 则必须带上 Issue 编号）。

## 二、提交 PR 遵守项目模板

提交 PR 时，必须遵守当前项目预设的 PR 模板 `.github/PULL_REQUEST_TEMPLATE.md`，并逐项补充完整内容：

- **PR 正文**：**完整保留原模板结构**，只打勾 / 填写，不删减模板内容——所有勾选项（含未选中的 `[ ]`）与所有 HTML 注释（`<!-- ... -->`）一律原样保留在正文内，填写内容写在对应位置；各小节标题与勾选规则说明不得省略。详细规则见 [`CONTRIBUTING.md`](../../../CONTRIBUTING.md) 的「PR 描述模板」小节。
- **PR 性质勾选**：按模板勾选规则选择正确类型（所有选项保留，选中的 `[x]`、未选中的 `[ ]`）。
- **自查清单**：逐项核对并勾选（标题格式、相关 Issue 链接、Spec 链接、文档补充）。
- **更新日志（Changelog）**：`tdesign-component/CHANGELOG.md` 由 CLI 自动生成，**无需人工维护**。PR 描述「更新日志」小节**面向实际使用方的用户**（目标受众是用户，而非开发者 / 维护者），**只记录用户可感知的变更**；纯内部实现、CI/CD 配置、文档结构调整、重构（行为不变）等**用户无需感知**的改动，**不要凭空生成更新日志**，直接勾选「本条 PR 不需要纳入 Changelog」。一个 PR 含多个用户可感知变更时按条分开列写，完整格式规则（含 commit type 与最终分组对应表）见 [`CONTRIBUTING.md`](../../../CONTRIBUTING.md) 的「PR 更新日志规范」。
- **Breaking change 一律用 `breaking` commit type**（如 `- breaking(toast): 调整 xxx 默认行为`），自动归入 CHANGELOG 的 **Breaking Changes** 分组。其余 type 的对应关系见 [`CONTRIBUTING.md`](../../../CONTRIBUTING.md)「PR 更新日志规范」或通用 skill 第二节。
- **更新日志条目一律用普通列表项，不要用行内代码块（反引号 `` ` ``）包裹**：上文及模板注释里的反引号（如 `` `breaking(toast): ...` ``）**只是用于展示格式的示例写法**，填写 PR 描述「更新日志」小节时要把这些反引号去掉，写成纯文本条目（如 `- breaking(TFab): 调整 xxx 默认行为`），避免污染自动生成的 CHANGELOG。

## 三、PR 关联相关 Issue

**CNB 平台生成的 PR 不携带任何 Issue 编号**（CNB 的 Issue 与 GitHub Issue 是两套体系，关联可能不一致 / 冲突），且**不写任何差异 / 关联提示**，正文内容**仅按 `.github/PULL_REQUEST_TEMPLATE.md` 原始模板填写**：

1. **不携带 Issue 编号**：CNB 生成的 PR 正文**不写死 `close #CNB_ISSUE_NUMBER`**，也**不在正文任何小节写明 CNB Issue 编号**，避免与 GitHub 侧冲突、造成两边状态不同步。
2. **不写差异 / 关联提示**：CNB 生成的 PR 正文**不额外追加**任何"该需求来源于某 Issue / 请在 GitHub 侧保留关联"之类的提示说明，按模板原样保留各小节（含 HTML 注释），无实际内容可填时留空，不凭空补充。
3. **Issue 关联在 GitHub 侧保留**：真正的 Issue 主阵地是 **GitHub**，`close #xx` 指向 GitHub Issue 的关联在 GitHub 对应的 PR 中填写，合并后由 GitHub 自动关闭对应 Issue；该关联与 CNB 侧无关。
4. **自查清单**：按模板原样勾选「相关 Issue」处，不额外填写 CNB Issue 编号。

## 四、Spec 规范对齐

涉及组件 API 变更、重构、跨目录改动时，须与 `specs/` 保持一致，完整流程见 [`specs/README.md`](../../../specs/README.md) 与 [`CONTRIBUTING.md`](../../../CONTRIBUTING.md) 的 Spec 贡献流程。要点：

1. **何时创建 Spec**：修改公共组件 API / 行为契约、组件重构、跨目录修复、同时改组件 + 测试 + 示例 + 文档时，先创建 `specs/<编号>-<短名称>/`；单行文案、格式调整、简单局部修复不要求。
2. **提交的代码必须与 Spec 一致**：实现须满足 `spec.md` 定义的行为契约与验收标准；Review 时同时核对实现与 Spec 是否相符。
3. **方案变更同步更新 Spec**：先更新 Spec 再改代码，不让文档与实现长期分叉。
4. **提交 PR 时**：在正文附上 Spec 目录链接；自查清单中勾选「已添加对应的 Spec 链接」。

### 「写不写 Spec」与「写不写更新日志」是两件独立的事

**「是否需要 Spec」与「是否需要更新日志」由两套不同标准触发，不能互相推导**：Spec 看「改动复杂度 / 碰公共契约」，更新日志看「用户感不感知」。四种情况的完整判断见通用 skill [`../tdesign-flutter-general/SKILL.md`](../tdesign-flutter-general/SKILL.md) 第一节，此处不重复。

**最容易出错**：把"勾选「本条 PR 不需要纳入 Changelog」"等同于"不需要 Spec"。行为不变的纯内部重构（用户无感、不写日志）仍可能需要 Spec（属于重构，Review 结合实际改动判定）。

## 五、Flutter 版本双兼容

`tdesign-flutter` 需同时兼容 `flutter@3.32.0` 与 `flutter@latest`（stable 通道最新版），通用判断规则见通用 skill [`../tdesign-flutter-general/SKILL.md`](../tdesign-flutter-general/SKILL.md) 第四节。CNB 平台落地要点：

- `flutter@3.32.0`：项目基线版本，`pubspec.yaml` 声明 `flutter: ">=3.32.0"`，`.fvmrc` 固定为 3.32.0。
- `flutter@latest`：stable 通道最新版本，用于前瞻性兼容。

## 六、组件变更的 breaking change 分析

通用判断规则（是否改公开 API 签名 / 默认行为 / 删除能力、迁移策略等）见通用 skill 第五节。CNB 平台落地时：涉及公共 API 变更或组件重构须创建对应 Spec，并在 PR 自查清单勾选「已添加对应的 Spec 链接」；若为 breaking change，更新日志用 `breaking` commit type（见第二节）。

## 七、文档来源与注释规范（注释即文档）

本仓库的"文档"有明确来源与分工，改动组件时须先弄清楚每条文档该写在哪，避免重复维护与分叉（通用规则见通用 skill 第六节，此处列 CNB 平台落地时的速查）：

| 文档载体 | 职责 | CNB 平台何时维护 |
|---------|------|-----------------|
| **dartdoc 注释**（`///`） | 组件公开 API 的**用户文档** | 新增 / 修改公开 API 时**必须同步**，与代码同一次提交 |
| **Spec**（`specs/<编号>-<短名称>/`） | 复杂需求 / 重构 / 公共 API 变更的**设计文档** | 见第四节，先 Spec 后代码，方案变更时同步更新 |
| **PR 更新日志** | 面向使用方用户的变更说明 | 见第二节，只记录用户可感知的变更 |
| **CHANGELOG.md** | 由 CLI 自动生成 | 不手动编辑 |
| **CONTRIBUTING.md / specs/README.md** | 规范唯一事实来源 | 需引用时统一指向，避免重复维护 |

## 八、API 文档 / 示例代码 / README 的脚本同步

本仓库存在**由脚本生成并需随源码一并提交**的产物，改动设计 API、示例代码或根目录 README 时，**必须运行对应生成 / 同步脚本**，把生成的产物与源码同一次提交（通用规则与命令见通用 skill [`../tdesign-flutter-general/SKILL.md`](../tdesign-flutter-general/SKILL.md) 第七节）。CNB 平台落地要点：

1. **修改设计 / 组件 API 时** → 在 `tdesign-component` 目录运行 `sh ./demo_tool/all_build.sh`，重新生成并提交 `example/assets/api/<component>_api.md`；新增或迁移组件时先更新 `tool/components.json` 再生成。
2. **修改示例代码（带 `@ExampleCode` 注解的示例方法）时** → 在 `tdesign-component` 目录运行 `dart run tool/generate_example_code.dart --verbose`，重新生成并提交 `example/assets/code/*.txt`；CI 会用 `dart run tool/generate_example_code.dart --check` 校验同步。
3. **修改根目录 `README.md` 或 `README_zh_CN.md` 时** → 在仓库根目录运行 `node scripts/sync-readme.mjs`，将内容同步到 `tdesign-component/README.md`、`tdesign-component/README_zh_CN.md` 与 `tdesign-site/site/docs/getting-started.md`，同步产物与源码同一次提交。

**容易漏**：只改了源码没运行脚本 / 运行了却没把生成文件提交，都会导致源码与产物分叉、CI 校验失败。提交 PR 前先在本地重跑脚本并确认生成文件已一并提交。

## 九、代码质量 / lint 零告警

通用自查清单（`const`/`final`、tear-off、`directives_ordering`、单引号、集合字面量、字符串插值等，对齐 `tdesign-component/analysis_options.yaml`）见通用 skill 第八节。CNB 平台落地要点：**lint 零告警是硬性门槛**，skill / 约定属软约束，只有 CI 的 `flutter analyze`（`.cnb.yml`，`--fatal-infos`）才是机器硬门槛；提交前在本地跑 `cd tdesign-component && flutter analyze` 确认无告警再提交。

## 回答风格

- 回答使用与提问相同的语言（中文 / 英文）。
- 结论先行，给出明确判断，再附必要依据与可操作建议。
- 涉及代码时给出可复制的最小示例。
- 需要执行平台操作（建分支、提 PR、评论等）时，先核对上述规范再动手。
