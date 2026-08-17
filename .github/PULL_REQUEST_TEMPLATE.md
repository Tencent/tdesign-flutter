### 🤔 这个 PR 的性质是？
> 勾选规则:
> 1.只要有新增参数，就勾选”新特性提交“
> 2.只修改内部bug，未新增参数，才勾选”日常 bug 修复“
> 3.其他选项视具体改动判断

- [ ] 日常 bug 修复
- [ ] 新特性提交
- [ ] 文档改进
- [ ] 演示代码改进
- [ ] 组件样式/交互改进
- [ ] CI/CD 改进
- [ ] 重构
- [ ] 代码风格优化
- [ ] 测试用例
- [ ] 分支合并
- [ ] 其他

### 🔗 相关 Issue

<!--
1. 描述相关需求的来源，如相关的 issue 讨论链接。
-->

### 💡 需求背景和解决方案

<!--
1. 要解决的具体问题。
2. 列出最终的 API 实现和用法。
3. 涉及UI/交互变动需要有截图或 GIF。
-->

### 📝 更新日志

<!--
从用户角度描述具体变化，以及可能的 breaking change 和其他风险。

格式要求：
- 若一个 PR 包含多个功能 / 修复，必须按条目分开列写，不能合并成一条笼统描述。
- 每条遵循 Conventional Commits 的 commit type，与最终分组对应：`breaking`→Breaking Changes、`feat`→Features、`fix`→Bug Fixes、`perf`/`refactor`→Performance、`docs`→Documentation、其他→Others。
- 修复缺陷用 `fix(组件名称): 修复 xxx 的问题`，新增能力用 `feat(组件名称): 添加了 xxx 功能`，其他用 `docs(...)` / `refactor(...)` / `chore(...)` 等。
- **Breaking change（改变公开 API 签名 / 默认行为 / 删除能力）使用 `breaking` commit type**，即 `- breaking(组件名称): 调整 xxx 默认行为`，会自动归入 Breaking Changes 分组（不再使用 ⚠️ 前缀）。
- 示例：
  - breaking(toast): 调整 xxx 默认行为
  - fix(TInput): 修复密文模式下无法粘贴的问题
  - feat(TButton): 新增渐变背景能力
  - docs: 更新主题生成器文档
-->

- 待补充

- [ ] 本条 PR 不需要纳入 Changelog

### ☑️ 请求合并前的自查清单

⚠️ 请自检并全部**勾选全部选项**。⚠️

- [ ] 标题遵循 Conventional Commits 格式：`type(scope): 修改描述`；`scope` 可填写组件、文档或 CI 模块。
      示例：`fix(TBottomTabBar): 修复 iconText 模式底部溢出`
- [ ] “相关 Issue”处带上修复的 Issue 链接或无关联 Issue
- [ ] 已添加对应的 Spec 链接，或已由 Review 确认本次改动无需 Spec
- [ ] 相关文档已补充或无须补充
