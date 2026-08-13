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

## PR 更新日志规范

PR 描述「更新日志」小节是面向用户的本次变更说明（与仓库自动生成的 `CHANGELOG.md` 不是一回事）：

1. 从用户角度描述具体变化，标注可能的 breaking change；若无需纳入则勾选「本条 PR 不需要纳入 Changelog」。
2. **一个 PR 含多个功能 / 修复时，必须按条目分开列写**，不能合并成一条笼统描述。
3. 每条遵循以下格式，说明改动类型与影响组件：
   - 修复缺陷：`fix(组件名称): 修复 xxx 的问题`
   - 新增能力：`feat(组件名称): 添加了 xxx 功能`
   - 其他：`docs(...)`、`refactor(...)`、`chore(...)` 等，遵循 Conventional Commits。
4. 一个 PR 含多条变更时使用无序列表逐条列出，例如：
   ```
   - fix(TInput): 修复密文模式下无法粘贴的问题
   - feat(TButton): 新增渐变背景能力
   - docs: 更新主题生成器文档
   ```
5. 更新日志应与实际改动一一对应，不得遗漏也不得夸大。

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
