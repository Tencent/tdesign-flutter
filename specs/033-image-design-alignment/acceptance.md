# 验收记录

- 基线：Flutter `2ed620b9`；Figma `24386:5269`；小程序 `cc2384cc5`。
- Flutter 3.32.0：组件测试 12 项、Demo 测试 2 项、工具清单测试 17 项通过；组件生产代码覆盖率 `94/96 = 97.92%`；组件库和 Example 静态分析均无问题。
- Flutter 3.47.0：clean 后重新获取依赖；组件测试 12 项、Demo 测试 2 项通过；组件库和 Example 静态分析均无问题。测试定位同步兼容 Flutter 3.47 的额外框架 `ColoredBox`。
- 独立分支编译发现并修复 Footer、Empty Demo 两处遗留 `TImageVariant.fitWidth` 调用，统一迁移为 `BoxFit.fitWidth`。
- Linux Flutter 3.32.0：明暗 Demo Golden 先生成、人工检查，再以无更新模式复验，2 项通过；默认形状由旧圆角改为方形后，组件状态 Golden 更新并无更新复验，4 项通过。
- 生成物：示例代码与 API 文档已重新生成，示例代码 `--check` 通过。
