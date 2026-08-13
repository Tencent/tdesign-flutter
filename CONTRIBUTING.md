# CONTRIBUTING

> **本文档是 `tdesign-flutter` 仓库开发 / 协作 / PR / 更新日志规范的唯一事实来源**。
> 其他文档（`AGENTS.md` 入口索引、`.agents/skills/.../SKILL.md`、`specs/README.md`）如需引用，统一指向本文档，避免重复维护。
> - Spec 专项规范 → [`specs/README.md`](./specs/README.md)

## 目录结构

```text
tdesign-component/
├── demo_tool       // API 和演示代码
├── example         // 组件使用示例
├── lib             // 组件库
└── test            // 组件测试

tdesign-site/       // tdesign flutter 站点
```

## 开发规范

- 组件命名规范：以 `T` 为前缀，组件名称、API 名称参考 TDesign 现有组件和 API 命名，可以根据 Flutter 原生 Widget 的特点进行修改。组件 API 以满足设计要求和使用为准，可根据 Flutter 特点做精简或定制。
- 组件库用到的所有色值、圆角、字体字号等样式属性需全部定义在主题中。
- 代码规范遵循腾讯 Dart 代码规范。
- 对于系统原有组件，如 `Text`、`Image` 等，应兼容系统原组件功能，只能扩展，不能阉割，以免业务需要使用系统功能时，必须放弃 TDesign 控件。
- 示例页面尽量使用 ExamplePage + ExampleModule + ExampleItem 组合，按照示例稿的布局实现。
- 组件 API 和演示代码，请参考 [demo_tool/README.md](./tdesign-component/demo_tool/README.md) 文件。
- 组件内部的固定文案，都应该抽离到 TResourceDelegate 中统一管理，方便业务进行国际化适配。
- 如果已有 TDesign 组件封装，尽量使用现有 T 组件，而非直接使用系统组件。
- `tdesign-component/CHANGELOG.md` 由 CLI 自动生成，**无需人工维护**；PR 的变更说明请在 PR 描述「更新日志」小节按条列写即可（格式见下文「PR 更新日志规范」）。

## PR 描述模板

提交 PR 时，正文必须**完整保留 `.github/PULL_REQUEST_TEMPLATE.md` 的原模板结构**，在此基础上只打勾 / 填写，不得删减模板本身的内容：

1. **所有选项一律保留**：如「🤔 这个 PR 的性质是？」下的全部勾选项（`日常 bug 修复`、`新特性提交`、`文档改进`、`CI/CD 改进` 等 11 项），无论是否选中都要保留；选中的用 `[x]`，未选中的用 `[ ]`。
2. **所有 HTML 注释一律保留**：模板中的 `<!-- ... -->` 注释（如「相关 Issue」「需求背景和解决方案」「更新日志」各小节的说明注释）必须原样保留在正文内，填写内容写在注释之后。
3. **各小节标题与引导语保留**：`### 🤔 这个 PR 的性质是？`、`> 勾选规则` 等标题、说明、勾选规则说明不得省略。
4. 只在实际对应的位置打勾 / 填写，未勾选的选项保持 `[ ]`，禁止删除未使用的小节或选项。

即 PR 正文形态为「完整模板 + 打勾 + 填写」，与模板逐行对应、无删减、无缺漏。

## PR 关联 Issue

Issue 的**主阵地是 GitHub**。CNB 是镜像平台，其 Issue 与 GitHub Issue 是两套体系、编号 / 状态不同步，因此：

1. **CNB 平台生成的 PR 不自动关联 / 不写死 `close #xx` 指向 CNB Issue**，避免与 GitHub 侧的 Issue 关联冲突、造成两边状态不一致。
2. **Issue 关联在 GitHub 侧保留**：`close #xx` 指向 GitHub Issue 的关联应在 GitHub 对应的 PR 中填写，合并后由 GitHub 自动关闭对应 Issue。
3. **非 Issue 平台（CNB）保留关联提示**：CNB 生成的 PR 应在「相关 Issue」小节给出**提示**，说明该需求的 Issue 关联在 GitHub 保留，提醒维护者到 GitHub PR 中补充，避免遗漏。
4. 自查清单「相关 Issue」处勾选时，明确该关联在 GitHub 保留。

## PR 更新日志规范

PR 描述「更新日志」小节是**面向实际使用方的用户**的本次变更说明（与仓库自动生成的 `CHANGELOG.md` 不是一回事），其**目标受众是「用户」而非开发者 / 维护者**。因此：

1. **只记录用户可感知的变更**：仅当本次改动会改变用户在使用组件 / 库时能观察到的行为（如 API、样式、交互、性能、体验等）时才写入更新日志；从用户角度描述具体变化，标注可能的 breaking change。
2. **内部 / CI 改动不写日志**：纯内部实现、CI/CD 配置、文档结构调整、重构（行为不变）等**用户无需感知**的改动，**不应凭空生成更新日志**，而是勾选「本条 PR 不需要纳入 Changelog」，避免产生无用日志。判断标准是：**这个用户在使用产品时能否感知到这次变化？** 感知不到就不写。
3. **一个 PR 含多个功能 / 修复时，必须按条目分开列写**，不能合并成一条笼统描述。
4. 每条遵循以下格式，说明改动类型与影响组件：
   - 修复缺陷：`fix(组件名称): 修复 xxx 的问题`
   - 新增能力：`feat(组件名称): 添加了 xxx 功能`
   - 其他：`docs(...)`、`refactor(...)`、`chore(...)` 等，遵循 Conventional Commits。
5. 一个 PR 含多条变更时使用无序列表逐条列出，例如：
   ```
   - fix(TInput): 修复密文模式下无法粘贴的问题
   - feat(TButton): 新增渐变背景能力
   - docs: 更新主题生成器文档
   ```
6. 更新日志应与实际改动一一对应，不得遗漏也不得夸大；**只写用户可感知的变更，内部 / CI 类改动明确勾选「本条 PR 不需要纳入 Changelog」**。

## 示例代码片段

示例 App 的代码查看和 Web Markdown 都读取 `tdesign-component/example/assets/code/` 中的源码片段。将示例方法标记为 `@ExampleCode`，其中 `group` 必须与页面的 `exampleCodeGroup` 完全一致：

```dart
@ExampleCode(group: 'button')
Widget _buildPrimaryButton(BuildContext context) {
  return const TButton(child: TText('按钮'));
}
```

在 `tdesign-component` 目录执行以下命令生成片段，并将变更后的 `.txt` 文件与示例源码一起提交：

```bash
dart run tool/generate_example_code.dart
dart run tool/generate_example_code.dart --check
```

第二条命令不会写文件，用于本地和 CI 校验片段是否与源码同步。

## 贡献指南

请参考：[贡献指南](https://tdesign.tencent.com/flutter/develop)

复杂需求、公共 API 变更、组件重构和跨目录改动请先阅读并创建对应的 [Spec](./specs/README.md)；是否可以不创建 Spec，由 Review 根据实际改动判断。

## Spec 贡献流程

复杂需求、公共 API 变更、组件重构和跨目录改动，请按 [`specs/README.md`](./specs/README.md) 的完整流程创建并维护 Spec：

1. 从 `specs/_template/` 复制模板，创建 `specs/<编号>-<短名称>/` 目录；编号按顺序递增，短名称使用小写 kebab-case。
2. 在 `spec.md`（背景 / 目标 / 范围 / 非目标 / 行为契约 / 验收标准）、`plan.md`（技术方案 / 影响范围 / API 变化 / 风险）、`tasks.md`（任务拆分与状态）、`acceptance.md`（验证记录）中按模板填写。
3. 提交代码必须与 Spec 定义的行为契约 / 验收标准一致，Review 时同时核对实现与 Spec 是否相符；方案变更时先更新 Spec 再改代码。
4. 提交 PR 时，在正文附上 Spec 目录链接；PR 描述「更新日志」须与 Spec 描述一致（格式见上文「PR 更新日志规范」）。

简单文案、格式调整和单文件局部修改不要求创建完整 Spec。Spec 只描述设计和验收，不替代代码、测试或生成文档。
