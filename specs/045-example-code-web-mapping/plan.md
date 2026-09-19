# 实施方案

## 技术方案

1. 将 `t_table_page.dart` 移入 `page/table/table_page.dart`，入口文件按字母顺序位于模块文件之前。
2. 用类级 `@ExampleCode` 表达每个可复制示例；示例使用类内数据和 helper，避免生成片段依赖页面私有声明。
3. 在站点 Markdown 转换前解析 `flutter-example-group` 指令，按组件展开 Example 生成目录中的全部源码并输出 Dart `td-code-block`。
4. 把资产读取和指令替换抽成无框架依赖的 `.mjs` 模块；用 Node 清单检查覆盖全部组件文档，并抽查多个组件与错误分支。
5. 将 57 份组件文档的 400 多段手写 Dart 副本替换为单一组映射；保留 API 与组件专项说明。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | 无 | 不修改生产组件 |
| 测试 | Table Demo、生成器、站点映射测试 | 锁定入口、代码面板与映射完整性 |
| 示例 | `example/lib/page/table/` | 目录及状态所有权重构 |
| 文档 | 57 份组件 README、TDoc transform | 404 份组件示例改为单源映射 |

## API 变化

- 无公开组件 API 变化；不属于 breaking change。

## 风险与取舍

- 类级示例会重复少量 Table 数据构造，但保证每份代码可独立复制，优先于隐藏依赖的 DRY。
- 全量迁移会形成较大的删除 diff，因此通过自动清单确认 57 个文档组和 404 份生成资产一一覆盖，并保留两个非组件基础配置组。

## 验证策略

- 单元测试：生成器测试、Node 映射与全量文档清单测试。
- 集成或 Widget 测试：Table 页面结构、交互和全部代码面板。
- 静态检查：Dart format、Flutter analyze、`git diff --check`、生成器 `--check`。
- 人工验收：抽查简单静态、受控交互和类级完整示例的转换结果；现有 Table Golden 无差异复跑。
