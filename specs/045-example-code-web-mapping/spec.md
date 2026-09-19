# Example 示例代码与 Web 文档单源映射

## 背景

Example App 通过 `@ExampleCode` 生成 `example/assets/code/*.txt`，但部分示例方法依赖页面私有数据和 helper，生成片段无法独立复制。Web 组件文档又保存了手写代码或仅链接页面源码，容易与实际运行示例长期分叉。

Table 页面同时包含静态、受控交互、固定列和样式示例，作为目录拆分及自包含代码的完整样板；映射能力覆盖全部组件文档。

## 目标

- 将 Table 页面入口和两类公开模块整理到 `page/table/`，页面入口保持易发现。
- 每个 Table `ExampleItem` 映射到一份包含 imports、数据、状态和回调的完整生成片段。
- 57 份组件 Web Markdown 均按组件组引用全部生成资产，不再复制第二份 Dart 源码。
- Web 构建在映射格式非法或目标资产不存在时失败。
- 用自动清单验证所有组件文档，并抽查 Table、Stepper、Form 三类不同形态的示例。

## 非目标

- 不改变 `TTable` 公共 API、默认行为或视觉结果。
- 不修改 Golden 基线。
- 不在本次机械重构其他组件的 Dart 页面目录；其运行源码保持不变，只移除 Web 中的手写副本。

## 范围

### 涉及

- Table Example 页面目录、示例状态和生成代码资产。
- Example 配置与 Table Demo 测试的入口引用。
- Web Markdown 转换器、映射测试及全部 57 份组件文档。

### 不涉及

- `tdesign-component/lib/` 下的生产组件实现。
- 其他组件 Demo 的 Dart 目录重构和运行行为。
- 站点导航和 API 文档生成。

## 行为契约

- `table/table_page.dart` 是 Table Demo 唯一页面入口；`table_type.dart` 与 `table_style.dart` 分别承载两个公开 `ExampleModule`。
- 页面只负责元信息和模块装配；排序状态归属于排序示例自身。
- 每个代码面板显式使用与 `@ExampleCode` 产物一致的稳定 `methodName`。
- 组件 Web 指令格式为 `{{ flutter-example-group <group> }}`，展开该组全部生成资产；单片段指令 `{{ flutter-example <group>.<name> }}` 仅作为底层能力保留。
- 组件文档目录名与生成组按忽略 `-`、`_` 和大小写的规则一一匹配；每份文档必须且只能有一个组映射。
- 全部 57 份组件文档不得保留手写 Dart `td-code-block`；`radius`、`shadows` 属于 Example 基础配置页，没有组件 Web 路由，不纳入组件文档映射。
- 找不到资产时不得降级为“建设中”，必须抛出错误阻止发布过期文档。

## 验收标准

- [x] Table 9 个公开示例的顺序、文案、尺寸、交互和 Golden 均保持不变。
- [x] Table 9 个代码面板均显示自包含的类级示例源码。
- [x] 57 份组件 Web 文档直接映射 404 份生成资产。
- [x] 映射测试覆盖全部文档清单，并抽查 Table、Stepper、Form 以及非法键、缺失资产。
- [x] 示例生成器 `--check`、聚焦 Demo 测试、站点构建和 analyze 通过。
