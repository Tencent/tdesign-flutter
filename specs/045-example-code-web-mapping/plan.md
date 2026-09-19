# 实施方案

## 技术方案

1. 将全部组件及基础入口移入 `page/<component>/<component>_page.dart`，按 `ExampleModule` 标题拆成语义模块文件。
2. 页面入口保留元数据、模块顺序、状态与生命周期；模块文件通过同一 Dart library 的 `part` 访问页面状态，避免复制或改变交互所有权。
3. 把 Calendar 农历数据、Sidebar 子页以及既有 Form、Progress、Stepper、Tag、TreeSelect 辅助 example 收拢到所属目录。
4. 用结构检查锁定 60 个入口、141 个模块、语义命名、配置引用和辅助文件归属。
5. 用类级 `@ExampleCode` 表达每个可复制示例；示例使用类内数据和 helper，避免生成片段依赖页面私有声明。
6. 在站点 Markdown 转换前解析 `flutter-example-group` 指令，按组件展开 Example 生成目录中的全部源码并输出 Dart `td-code-block`。
7. 把资产读取和指令替换抽成无框架依赖的 `.mjs` 模块；用 Node 清单检查覆盖全部组件文档，并抽查多个组件与错误分支。
8. 将 57 份组件文档的 400 多段手写 Dart 副本替换为单一组映射；保留 API 与组件专项说明。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | 无 | 不修改生产组件 |
| 测试 | Table Demo、生成器、站点映射测试 | 锁定入口、代码面板与映射完整性 |
| 示例 | `example/lib/page/*/` | 57 个组件、3 个基础页、141 个模块和辅助 example 的目录重构 |
| 文档 | 57 份组件 README、TDoc transform | 404 份组件示例改为单源映射 |

## API 变化

- 无公开组件 API 变化；不属于 breaking change。

## 风险与取舍

- 类级示例会重复少量 Table 数据构造，但保证每份代码可独立复制，优先于隐藏依赖的 DRY。
- 全量迁移会形成较大的 rename diff，因此分别用 Demo 结构清单和 Web 映射清单确认 60 个页面入口、141 个模块、57 个文档组和生成资产一一覆盖。

## 验证策略

- 单元测试：生成器测试、Node 映射与全量文档清单测试。
- 集成或 Widget 测试：Table 页面结构、交互和全部代码面板，并抽查多种组件形态。
- 静态检查：Dart format、Flutter analyze、`git diff --check`、生成器 `--check`。
- 人工验收：抽查简单静态、受控交互和类级完整示例的转换结果；现有 Table Golden 无差异复跑。
