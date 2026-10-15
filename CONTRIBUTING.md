# 贡献指南

感谢参与 TDesign Flutter。本文介绍本地开发、编码规范、问题反馈、Pull Request 提交和验收流程。

涉及公共 API、组件行为或跨目录改动时，请先阅读[设计方案与验收记录规范](./specs/README.md)，并随实现维护相应记录。

## 目录结构

```text
tdesign-component/
├── demo_tool       // API 和演示代码
├── example         // 组件使用示例
├── lib             // 组件库
└── test            // 组件测试

tdesign-site/       // tdesign flutter 站点
```

## 本地开发

同时兼容 Flutter 3.32.0 与当前稳定版本。先安装目标 SDK，在仓库根目录执行：

```bash
cd tdesign-component
flutter pub get
cd example
flutter pub get
flutter run
```

在目标 Android/iOS 设备、模拟器或适用的 Web 环境运行。站点开发与右侧 Flutter Web 预览统一见[站点开发说明](./tdesign-site/README.md)，避免在此重复维护命令和端口配置。

## 开发规范

- TD 内置视觉和行为只接受受支持的组件实例配置、TD ThemeExtension 与 Token；外部 Material/M2/M3 默认及显式主题不作为隐式入口。内部原生能力可以使用，但其视觉、反馈、触发和选择配置由 TD 明确。保留 TD 显式定制、调用方自定义内容的主题、文本选择和原生编辑、反馈、触发、焦点、键盘与无障碍能力。内部原生控件局部隔离视觉，不重置用户内容树，不因防范样式干扰删除原生能力。

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

## 领取 Issue

### 一个 Issue 的完整流程

- 用户发现功能不满足，查看 API 文档确认不支持，然后提 Issue。[常见问题](https://tdesign.tencent.com/flutter/faq)
- 提了 Issue 后，在群里发出 Issue 链接，方便后续直接沟通，确认详细需求。然后将最终确认结果贴到 GitHub 的 Issue 上。
- 负责人评估开发工作量，打 `help want` 和 `issueShoot` 标签。
- 贡献者确认要领取，在 Issue 下评论领取，并通知负责人。负责人打上 `Received` 标签，讨论确认实现方案。
- 贡献者参考开发规范开发完功能，按照文档自检，然后提 PR，并同步负责人验收。
- PR 自动构建测试包。【自动构建流水线】
- 负责人拉设计一起视觉走查（如果需要的话），走查完成后，合并 PR。Issue 打上下一个版本的标签。
- 版本发布后，Issue 关闭。

### 标签管理

- 无标签：未评估
- `issueShoot`：已评工作量，可领取
- `Received`：已领取
- `pre_x.x.x`：预计某个版本发布
- `x.x.x`：某个版本已发布

## PR 关联 Issue

Issue 的**主阵地是 GitHub**。CNB 是镜像平台，其 Issue 与 GitHub Issue 是两套体系、编号 / 状态不同步，因此：

1. **CNB 平台生成的 PR 不关联 CNB Issue**：CNB 生成的 PR 正文**不携带任何 Issue 编号**（既不以 `close #xx` 形式关联 CNB Issue，也不在正文任何小节写明 CNB Issue 编号），避免与 GitHub 侧的 Issue 关联冲突、造成两边状态不一致。
2. **不写差异 / 关联提示**：CNB 生成的 PR 正文**不额外追加**任何"该需求来源于某 Issue / 请在 GitHub 侧保留关联"之类的提示说明，内容**仅按 `.github/PULL_REQUEST_TEMPLATE.md` 原始模板填写**，模板有「相关 Issue」小节则按模板原样保留（含其 HTML 注释），无实际内容可填时留空即可，不凭空补充说明。
3. **Issue 关联在 GitHub 侧保留**：真正的 `close #xx` 指向 GitHub Issue 的关联应在 GitHub 对应的 PR 中填写，合并后由 GitHub 自动关闭对应 Issue；该关联与 CNB 侧无关。
4. 自查清单「相关 Issue」处按模板原样勾选，不额外填写 CNB Issue 编号。

## PR 更新日志规范

PR 描述「更新日志」小节是**面向实际使用方的用户**的本次变更说明（与仓库自动生成的 `CHANGELOG.md` 不是一回事），其**目标受众是「用户」而非开发者 / 维护者**。因此：

1. **只记录用户可感知的变更**：仅当本次改动会改变用户在使用组件 / 库时能观察到的行为（如 API、样式、交互、性能、体验等）时才写入更新日志；从用户角度描述具体变化，标注可能的 breaking change。
2. **内部 / CI 改动不写日志**：纯内部实现、CI/CD 配置、文档结构调整、重构（行为不变）等**用户无需感知**的改动，**不应凭空生成更新日志**，而是勾选「本条 PR 不需要纳入 Changelog」，避免产生无用日志。判断标准是：**这个用户在使用产品时能否感知到这次变化？** 感知不到就不写。
3. **组件 PR 不单列 Demo 配套改动**：组件 PR 的更新日志只描述组件 / 库使用方在实际接入中可感知的行为变化。Demo 页面布局、示例文案、示例代码、Golden 和测试等配套改动，即使在示例中可见，也不单独写入 Changelog；应写在「需求背景和解决方案」中，并按实际情况勾选「演示代码改进」或「测试用例」。同一 PR 同时修改组件与其 Demo 时，更新日志只保留组件行为条目。此规则不影响以文档、站点或示例应用本身为交付目标的独立 PR 按实际受众判断更新日志。
4. **分别判断 Spec 与更新日志的要求**：两者用途不同，应独立评估。

   **Spec 用于说明设计与验收。** 公共 API 或行为契约变更、复杂需求、组件重构及跨目录改动，应按 [Spec 规范](./specs/README.md)创建或更新设计与验收记录。简单文案、格式调整和单文件局部修改通常不需要完整 Spec，具体由 Review 结合改动范围确认。

   **更新日志用于说明用户可感知的变化。** 公开接口、行为、样式等变化应记录；行为不变的内部重构、CI 配置和文档结构整理无需单列更新日志，在 PR 中说明即可。

   例如，组件内部重构可能需要 Spec，但无需更新日志；公开 API 变更通常两者都需要。勾选“本条 PR 不需要纳入 Changelog”仅说明无需更新日志，不影响 Spec 的要求。

5. **一个 PR 含多个功能 / 修复时，必须按条目分开列写**，不能合并成一条笼统描述。
6. 每条遵循 Conventional Commits 的 commit type，**与最终分组（CHANGELOG 章节）固定对应**，写日志按实际 type 归入对应分组：

   | commit type | 最终分组 | 示例 |
   | --- | --- | --- |
   | `breaking` | Breaking Changes | `breaking(toast): 调整 xxx 默认行为` |
   | `feat` | Features | `feat(TButton): 新增渐变背景能力` |
   | `fix` | Bug Fixes | `fix(TInput): 修复密文模式下无法粘贴的问题` |
   | `perf`、`refactor` | Performance | `refactor(toast): 优化 xxx` |
   | `docs` | Documentation | `docs: 更新主题生成器文档` |
   | 其他（`chore` 等） | Others | `chore: 升级依赖` |

   **Breaking change 一律用 `breaking` type**（改变公开 API 签名 / 默认行为 / 删除能力），自动归入 Breaking Changes 分组，同时配合 PR 性质勾选中的 `重构` / `组件样式/交互改进` 等选项说明风险。
7. 更新日志应与实际改动一一对应，不得遗漏也不得夸大；**只写用户可感知的变更，内部 / CI 类改动明确勾选「本条 PR 不需要纳入 Changelog」**。

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

## 组件测试与 CI 回归门禁

新增组件或为既有组件新增测试时，测试文件不会因为放入 `test/` 目录就自动进入集中式 CI 回归。贡献者只需在 `tdesign-component/tool/component_test_manifest.dart` 的 `componentTestManifests` 数组中维护该组件的一条记录：

1. **组件测试**：`componentTests` 声明按组件执行并生成覆盖率的测试文件。
2. **生产源码覆盖率**：`coverageTargets` 声明纳入覆盖率统计的生产源码目录或文件；手写生产 Dart 行覆盖率须达到 `LH/LF >= 95%`。
3. **Demo 功能测试**：`exampleTests` 声明在 `example` 工程执行且不包含 Golden 的共享功能测试。
4. **Demo 与 Golden**：`visualTests` 可以声明一个或多个视觉回归 suite，并分别保留工作目录、测试文件和附加参数。

不归属单个组件的 Example smoke test 放在同文件的 `sharedExampleTests`。GitHub 与 CNB 只调用公共 runner，不直接维护测试文件长列表。

登记后在 `tdesign-component` 目录执行：

```bash
flutter test --no-pub test/tool/check_component_coverage_test.dart test/tool/run_component_regression_test.dart test/tool/run_visual_regression_test.dart
dart run tool/run_component_regression.dart
dart run tool/run_example_regression.dart
dart run tool/run_visual_regression.dart
```

调度器自测会检查组件名唯一、各类测试能力完整、登记文件存在，以及 GitHub/CNB 使用公共 runner。CI job 成功仅代表数组中已登记的测试通过；测试文件存在、Golden 已提交或本地单独运行通过，均不能替代 CI 回归登记。

## Spec 贡献流程

复杂需求、公共 API 变更、组件重构和跨目录改动，请按 [`specs/README.md`](./specs/README.md) 的完整流程创建并维护 Spec：

1. 从 `specs/_template/` 复制模板，创建 `specs/<编号>-<短名称>/` 目录；编号按顺序递增，短名称使用小写 kebab-case。
2. 在 `spec.md`（背景 / 目标 / 范围 / 非目标 / 行为契约 / 验收标准）、`plan.md`（技术方案 / 影响范围 / API 变化 / 风险）、`tasks.md`（任务拆分与状态）、`acceptance.md`（验证记录）中按模板填写。
3. 提交代码必须与 Spec 定义的行为契约 / 验收标准一致，Review 时同时核对实现与 Spec 是否相符；方案变更时先更新 Spec 再改代码。
4. 提交 PR 时，在正文附上 Spec 目录链接；PR 描述「更新日志」须与 Spec 描述一致（格式见上文「PR 更新日志规范」）。

简单文案、格式调整和单文件局部修改不要求创建完整 Spec。Spec 只描述设计和验收，不替代代码、测试或生成文档。

## 人工验收与合并

- 检查真实操作、布局溢出、明暗主题、英文环境、文字缩放和适用的焦点/键盘/无障碍能力。
- 在 Example App 检查对应API和代码查看入口；文档有误时修复源码注释、组件清单或示例源码，再重新生成，勿手工修改产物。
- 测试包或预览构建成功后，根据PR中的构建结果完成适用的Android/iOS验收；构建失败应先检查实际日志。
- 视觉改动由负责人协调设计走查，并附目标、状态、平台与版本证据。Golden要求见[组件Review规范](./.agents/skills/tdesign-component-align-review/SKILL.md)。
- Issue验收完成后由负责人合并PR；更新发布版本标签，正式发布后关闭对应Issue。

## 文档维护

| 内容 | 唯一来源 | 使用与生成方式 |
|---|---|---|
| 项目介绍和最短示例 | 根README.md、README_zh_CN.md | 中英文分别维护，包内副本生成 |
| 安装、主题（含明暗模式）、国际化、FAQ、迁移 | tdesign-site/site/docs/ | 站点直接读取，迁移另生成包内MIGRATION.md |
| 贡献规范 | 本文件 | 站点直接读取并适配页面元信息与相对链接 |
| 站点开发方式 | [tdesign-site/README.md](./tdesign-site/README.md) | 其他说明链接到此处 |
| API | lib中的公开dartdoc注释 | 生成example/assets/api，站点和示例App共用 |
| 示例 | example/lib中的标注源码 | 生成example/assets/code，站点和示例App共用 |
| 设计决策与验收 | specs/ | 保留历史证据，现行用户用法写入用户指南 |
| 发布流程与记录 | PUBLISH.md及既有CHANGELOG生成入口 | 发布步骤与历史记录分开维护 |

执行 `node scripts/sync-readme.mjs` 更新迁移、主题及国际化指南中的可运行示例片段和包内副本；执行 `node scripts/sync-readme.mjs --check` 只检查，不改文件。包内副本顶部标注来源，不手工修改。站点普通指南使用小写连字符命名，迁移文件名写清起止版本。

新增指南后在站点导航登记；内部文档链接使用相对路径，站点渲染时转换为既有路由，包内副本转换为可访问的线上入口。完整文档来源和边界见[整理记录](./specs/062-documentation-source-consolidation/spec.md)。
