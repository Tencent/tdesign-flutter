---
name: tdesign-flutter-conventions
description: TDesign Flutter 仓库面向 CNB 平台 NPC 的协作约定（基于 Issue 创建分支的 cnb-issue-<issue.number> 命名、PR 模板填写、close #xx 关联 Issue、Flutter 3.32.0 与 latest 双版本兼容、组件 breaking change 分析、文档来源与注释规范、代码质量 / lint 零告警）。任何 NPC 在本仓库执行创建分支、提交 PR、分析组件改动、维护组件注释与文档、检查代码质量等任务时，都应先加载并遵守本约定。通用规范以 CONTRIBUTING.md / specs/README.md 为准，本文档只补充 CNB 平台特有的执行细则。
---

# TDesign Flutter 仓库协作约定（CNB NPC 版）

本 skill 是 CNB 平台 NPC 在本仓库执行任务时遵循的执行约定。通用开发 / 协作 / Spec 规范以 [`CONTRIBUTING.md`](../../../CONTRIBUTING.md) 与 [`specs/README.md`](../../../specs/README.md) 为准，本文档只补充 **CNB 平台 NPC 特有**的细则，避免重复维护。

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
- **更新日志（Changelog）**：`tdesign-component/CHANGELOG.md` 由 CLI 自动生成，**无需人工维护**。PR 描述「更新日志」小节**面向实际使用方的用户**（目标受众是用户，而非开发者 / 维护者），**只记录用户可感知的变更**；纯内部实现、CI/CD 配置、文档结构调整、重构（行为不变）等**用户无需感知**的改动，**不要凭空生成更新日志**，直接勾选「本条 PR 不需要纳入 Changelog」。一个 PR 含多个用户可感知变更时按条分开列写，完整格式规则见 [`CONTRIBUTING.md`](../../../CONTRIBUTING.md) 的「PR 更新日志规范」。
- **Breaking change 使用 `breaking` commit type**：更新日志中凡是 breaking change（改变公开 API 签名 / 默认行为 / 删除能力）的条目，应使用 `breaking` type（如 `- breaking(toast): 调整 xxx 默认行为`），它会自动归入 CHANGELOG 的 **Breaking Changes** 分组（不再使用 `⚠️` 前缀）。commit type 与最终分组对应关系见 [`CONTRIBUTING.md`](../../../CONTRIBUTING.md) 的「PR 更新日志规范」：`breaking`→Breaking Changes、`feat`→Features、`fix`→Bug Fixes、`perf`/`refactor`→Performance、`docs`→Documentation、其他→Others。

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

常见误区是**把"勾选「本条 PR 不需要纳入 Changelog」"等同于"不需要 Spec"**——这是错误的。两者由**两套不同标准**触发，判断维度正交，不能互相推导：

- **写不写 Spec** → 看**改动复杂度 / 是否碰公共契约**（面向开发者 / 维护者）：公共 API 变更、组件重构、跨目录改动、复杂 Bug 就写；单行文案、格式调整、简单局部修复不写。**由 Review 结合实际改动判定**。
- **写不写更新日志** → 看**用户感不感知得到**（面向用户）：只写用户可感知的变更；纯内部实现、CI/CD、文档结构调整、行为不变的重构不写日志。

据此区分**三种情况**，避免判断出错：

1. **行为不变的纯内部重构**（如重命名内部变量、抽取私有方法）：**要 Spec**（属于重构，Review 判定需设计文档则写），**不要更新日志**（用户感知不到，勾选「不需要纳入 Changelog」）。**最容易出错**——不要因"行为不变、不写日志"就认为不需要 Spec。
2. **不影响公共契约的简单改动 / 单文件局部修复**：**不需要 Spec**，也不写更新日志（用户无感）。
3. **改变了用户可感知行为的重构 / API 变更**：**既要 Spec**（涉及公共契约），**也要写更新日志**（用户能感知）；若是 breaking change，还需用 `breaking` commit type（见第二节）。

一句话记忆：**Spec 看"改动复不复杂 / 碰不碰公共契约"，更新日志看"用户感不感知得到"**——两者可以同时满足，也可以互不相关。

## 五、Flutter 版本双兼容

`tdesign-flutter` 需要同时兼容 `flutter@3.32.0` 与 `flutter@latest`（stable 通道最新版）。当前项目通过 CI（`.github/workflows/test-build.yml`）分别对两个版本执行构建。

- `flutter@3.32.0`：项目基线版本，`pubspec.yaml` 中声明 `flutter: ">=3.32.0"`，`.fvmrc` 固定为 3.32.0。
- `flutter@latest`：stable 通道最新版本，用于前瞻性兼容。

在分析或修改代码时，必须同时考虑两个版本的差异：

1. 检查使用的 Flutter / Dart API 在 3.32.0 与 latest 中是否都存在且行为一致。
2. 注意可能被弃用（deprecated）或行为变更的 API，避免在 low 版本不可用、high 版本已移除。
3. 若引入新依赖或新 API，需确认其最低要求不超过 3.32.0，且不破坏 latest 构建。
4. 结论中请明确标注改动对 `flutter@3.32.0` 与 `flutter@latest` 各自的兼容性影响。

## 六、组件变更的 breaking change 分析

当考虑组件（TDesign 组件，如 TButton、TInput 等）的修改时，必须分析是否会造成 breaking change：

1. 判断该改动是否改变现有公开 API 的签名、默认行为或删除已有能力。
2. 新增参数：若仅新增可选参数且不改变既有行为，通常不算 breaking；若新增必填参数或改变默认值则需谨慎。
3. 删除 / 重命名 / 更改参数类型、回调签名、枚举取值：均属于 breaking change，需重点提示。
4. 组件样式 / 布局默认值变化：可能影响既有页面视觉表现，应作为潜在 breaking change 提醒。
5. 涉及公共 API 变更或组件重构时，按仓库规范应创建对应的 Spec（`specs/<编号>-<短名称>/`）。
6. 输出时明确给出结论：是 / 否 breaking change，影响范围、受影响的 API，以及建议的迁移或兼容策略。

## 七、文档来源与注释规范（注释即文档）

本仓库的"文档"有明确来源与分工，改动组件时须先弄清楚每条文档该写在哪，避免重复维护与分叉：

| 文档载体 | 来源 / 职责 | 何时维护 |
|---------|------------|---------|
| **dartdoc 注释**（`///`） | 组件公开 API 的**用户文档**，由代码注释承载，`dart doc` 生成站点文档 | 新增 / 修改公开 API（类、字段、参数、回调、枚举）时**必须同步**，与代码同一次提交 |
| **Spec**（`specs/<编号>-<短名称>/`） | 复杂需求 / 重构 / 公共 API 变更的**设计文档**（spec / plan / tasks / acceptance） | 见第五节，先 Spec 后代码，方案变更时同步更新 |
| **PR 更新日志** | 面向**使用方用户**的变更说明（目标受众是用户，非开发者 / 维护者），由 PR 描述承载 | 见第二节，只记录用户可感知的变更 |
| **CHANGELOG.md** | 由 CLI 自动生成，**无需人工维护** | 不手动编辑 |
| **CONTRIBUTING.md / specs/README.md** | 开发 / 协作 / PR / Spec 规范的**唯一事实来源** | 需引用时统一指向，避免重复维护 |

### 注释的必要性

- **公开 API 注释就是组件文档**：使用者（含站点文档生成）直接读到的是 `///` dartdoc，而非 Spec 或 CHANGELOG。因此每个公开字段 / 参数 / 回调 / 枚举 / 类，都要写清"是什么、默认值、生效条件、三态语义（省略 / 显式 null / 自定义）、与相关字段的关系"。
- **注释必须与实现一致**：改行为就要改注释，避免注释与代码长期分叉（注释过期会误导使用者，危害不亚于缺注释）。
- **内部实现注释**（非公开 API）：用于解释"为什么这么做"的边界条件、时序、避免踩坑点（如手势竞争、回调顺序、Completer 生命周期），帮助后续维护者与 AI 理解设计意图；无信息量的赘述应删除。
- **Review / 修改组件时**：把"注释是否随代码同步更新"作为与"代码是否正确"同等重要的自查项。

## 八、代码质量 / lint 零告警

写代码与提交 PR 前，必须把 **lint 零告警**当作硬性门槛（skill 是自查约定，真正兜底在 CI 的 `flutter analyze`，见 `.cnb.yml`）。目标：**0 error / 0 warning / 0 info**（至少 0 error + 0 warning）。

### 提交前自查（对照 `tdesign-component/analysis_options.yaml`）

1. **能用 `const` 的地方必须 `const`**：`prefer_const_constructors` / `prefer_const_declarations` / `prefer_const_literals_to_create_immutables`（不可变对象、集合字面量、构造、声明均用 `const`），同时避免多余的 `unnecessary_const`。
2. **优先 `final` 而非 `var`**：变量不会重新赋值时用 `final`，字段用 `final`（`prefer_final_fields`）。
3. **避免 lambda 代替 tear-off**：能直接传方法引用就用 tear-off，不包一层 `() =>`（`unnecessary_lambdas`）。
4. **导入顺序**：遵循 `directives_ordering`，按 dart / package / relative 分组排序。
5. **统一用单引号**：字符串用 `'...'`（仓库 lint 默认 single quotes）。
6. **集合字面量与判空**：优先 `[]`/`{}` 字面量（`prefer_collection_literals`），用 `.isEmpty`/`.isNotEmpty` 判空（`prefer_is_empty`）。
7. **字符串插值**：统一 `${param}` 插值，避免拼接（`prefer_interpolation_to_compose_strings`）。
8. **其余规则**：避免多余容器（`avoid_unnecessary_containers`）、`const` 构造函数与不可变对象（`prefer_const_constructors_in_immutables`）、类型命名规范（`camel_case_*` / `non_constant_identifier_names`）等，全部对齐 `analysis_options.yaml`。

### 为什么必须过 CLI

- skill / 约定属于**软约束**，NPC 可能漏查；只有 CI 里的 `flutter analyze`（`--fatal-infos`）才把它变成**机器硬门槛**，能拦截"漏写 const"这类问题。
- 提交前在本地跑 `cd tdesign-component && flutter analyze`，确认无告警再提交；CI 的 `.cnb.yml` 已加入 analyze 步骤做最终兜底。

## 回答风格

- 回答使用与提问相同的语言（中文 / 英文）。
- 结论先行，给出明确判断，再附必要依据与可操作建议。
- 涉及代码时给出可复制的最小示例。
- 需要执行平台操作（建分支、提 PR、评论等）时，先核对上述规范再动手。
