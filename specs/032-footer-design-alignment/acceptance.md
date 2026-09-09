# 验收记录

- 基线：Flutter `2ed620b9`；Figma `24386:5265`；小程序 `cc2384cc5`。
- Footer 外层高度未设置时由内容自然撑开；Figma 未定义固定外层高度，小程序 Footer 也未提供 height 属性。
- Flutter 3.32.0：组件测试 7 项、Demo 测试 3 项、工具清单测试 17 项通过；组件生产代码覆盖率 `47/48 = 97.92%`；组件库和 Example 静态分析均无问题。
- Flutter 3.47.0：clean 后重新获取依赖；组件测试 7 项、Demo 测试 3 项通过；组件库和 Example 静态分析均无问题。
- Linux Flutter 3.32.0：明暗 Demo Golden 先生成、人工检查，再以无更新模式复验，2 项通过。
- 生成物：示例代码与 API 文档已重新生成，示例代码 `--check` 通过。
