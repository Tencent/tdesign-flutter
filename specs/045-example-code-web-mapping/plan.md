# 实施方案

## 技术方案

1. 将全部组件及基础入口移入 `page/<component>/<component>_page.dart`，页面入口直接保存 `ExampleModule` 分组、完整 `ExampleItem` 配置与顺序。
2. 将每个公开 `ExampleItem` 引用的 Widget 拆为组件目录下的语义 example 文件；文件内只定义独立 Widget 及其数据、状态、回调、helper 和生命周期，不导入 Example 页面基础设施。
3. 页面入口只保留元数据、分组信息、ExampleItem 配置及对独立 Widget 的引用，不再通过 `part` 共享页面 State，也不保留只承载分组的中间文件。
4. 把 Calendar 农历数据、Sidebar 子页以及既有 Form、Progress、Stepper、Tag、TreeSelect 辅助 example 收拢到所属目录，并由对应 example 显式依赖。
5. 用结构检查锁定 60 个入口、公开 ExampleItem 的独立文件、语义命名、配置引用、状态所有权和辅助文件归属，并阻止纯分组模块文件回流。
6. 用类级 `@ExampleCode` 标记每个公开 ExampleItem 的实际运行 Widget；生成器直接导出整个文件所需 imports、Widget 和匹配 State，不递归猜测页面依赖。
7. 生成公开示例清单，保留 ExampleModule / ExampleItem 顺序，并在站点 Markdown 转换时按清单展开源码。
   迁移期间只有显式标记 `@ExampleCodeManifest` 的已完成页面进入严格清单；其余组暂列入 `legacyGroups` 保持现有展示。最终合并前清空 `legacyGroups` 并删除目录扫描兼容分支。
8. 把资产读取和指令替换抽成无框架依赖的 `.mjs` 模块；用 Node 清单检查覆盖全部组件文档、公开示例一一对应、顺序和错误分支。
9. 将 57 份组件文档的手写 Dart 副本替换为单一组映射；保留 API 与组件专项说明。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | 无 | 不修改生产组件 |
| 测试 | Table Demo、生成器、站点映射测试 | 锁定入口、代码面板与映射完整性 |
| 示例 | `example/lib/page/*/` | 57 个组件、3 个基础页、页面分组、全部公开 ExampleItem 和辅助 example 的目录重构 |
| 文档 | 57 份组件 README、TDoc transform | 全部公开组件示例按运行顺序改为单源映射 |

## API 变化

- 无公开组件 API 变化；不属于 breaking change。

## 风险与取舍

- 独立类级示例会重复少量数据构造，但保证每份代码可独立复制，优先于通过页面私有状态实现 DRY。
- 全量迁移会形成较大的 rename diff，因此分别用 Demo 结构清单和 Web 映射清单确认 60 个页面入口、全部公开 ExampleItem、57 个文档组和生成资产一一覆盖。

## 验证策略

- 单元测试：生成器测试、Node 映射与全量文档清单测试。
- 集成或 Widget 测试：全组件公开 ExampleItem 清单、顺序、交互和全部代码面板；生成源码在最小宿主中解析或编译。
- 静态检查：Dart format、Flutter analyze、`git diff --check`、生成器 `--check`。
- 人工验收：抽查简单静态、受控交互和类级完整示例的转换结果；现有 Table Golden 无差异复跑。
