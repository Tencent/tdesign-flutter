---
name: tdesign-flutter-conventions
description: TDesign Flutter 仓库的协作约定（分支/PR 命名规范、PR 模板填写、close #xx 关联 Issue、Flutter 3.32.0 与 latest 双版本兼容、组件 breaking change 分析）。任何 NPC 在本仓库执行创建分支、提交 PR、分析组件改动等任务时，都应先加载并遵守本约定。
---

# TDesign Flutter 仓库协作约定

本 skill 定义 `tdesign-flutter` 仓库的协作规范，适用于所有在本仓库被 `@` 提及的 NPC（包括系统 NPC 与自定义 NPC）。执行涉及分支 / PR / 组件改动的任务时，请先遵循以下约定。

## 一、分支与 PR 规范

在创建 PR / 分支时，必须严格遵守以下分支命名约定：

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

- **PR 正文**：以模板结构为准，依次填写「PR 性质」「相关 Issue」「需求背景和解决方案」「更新日志」「请求合并前的自查清单」等小节，不得省略。
- **PR 性质勾选**：按模板勾选规则选择正确类型。
- **自查清单**：逐项核对并勾选（标题格式、相关 Issue 链接、Spec 链接、文档补充）。
- **更新日志（Changelog）**：
  1. 从用户角度描述具体变化，标注可能的 breaking change；若无需纳入则勾选「本条 PR 不需要纳入 Changelog」。
  2. **若一个 PR 包含多个功能 / 修复，必须按条目分开列写**，不能合并成一条笼统描述。
  3. 每条遵循以下格式，说明改动类型与影响组件：
     - 修复缺陷：`fix(组件名称): 修复 xxx 的问题`
     - 新增能力：`feat(组件名称): 添加了 xxx 功能`
     - 其他：`docs(...)`、`refactor(...)`、`chore(...)` 等，遵循 Conventional Commits。
  4. 一个 PR 含多条变更时，使用无序列表逐条列出，例如：
     ```
     - fix(TInput): 修复密文模式下无法粘贴的问题
     - feat(TButton): 新增渐变背景能力
     - docs: 更新主题生成器文档
     ```
  5. 更新日志应与实际改动一一对应，不得遗漏也不得夸大。

## 三、PR 关联相关 Issue

提交 PR 时，如存在相关 Issue，必须在 PR 正文中携带关联，并以 `close #xx` 的形式提供（xx 为 Issue 编号，例如 `close #22`），确保合并后自动关闭对应 Issue。

## 四、Spec 规范对齐

涉及组件 API 变更、重构、跨目录改动时，须与 `specs/` 保持一致，具体遵循 `specs/README.md` 与 `CONTRIBUTING.md` 的 Spec 贡献流程：

1. **何时创建 Spec**：修改公共组件 API / 行为契约、组件重构、跨目录修复、同时改组件 + 测试 + 示例 + 文档时，先创建 `specs/<编号>-<短名称>/`；单行文案、格式调整、简单局部修复不要求。
2. **Spec 目录结构**：遵循模板 `specs/_template/`，包含 `spec.md`（背景 / 目标 / 范围 / 非目标 / 行为契约 / 验收标准）、`plan.md`（技术方案 / 影响范围 / API 变化 / 风险）、`tasks.md`（任务拆分与状态）、`acceptance.md`（验证记录）。编号按创建顺序递增，短名称用小写 kebab-case。
3. **提交的代码必须与 Spec 一致**：实现必须满足 `spec.md` 定义的行为契约与验收标准；Review 时同时检查实现是否满足 Spec，以及 Spec 是否准确反映最终实现。
4. **方案变更同步更新 Spec**：实现过程中若方案变化，先更新 Spec 再改代码，不让文档与实现长期分叉。
5. **提交 PR 时**：在正文附上 Spec 目录链接；自查清单中勾选「已添加对应的 Spec 链接」。

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

## 回答风格

- 回答使用与提问相同的语言（中文 / 英文）。
- 结论先行，给出明确判断，再附必要依据与可操作建议。
- 涉及代码时给出可复制的最小示例。
- 需要执行平台操作（建分支、提 PR、评论等）时，先核对上述规范再动手。
