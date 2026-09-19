# Example 示例代码与 Web 文档单源映射

## 背景

Example App 通过 `@ExampleCode` 生成 `example/assets/code/*.txt`，但部分示例方法依赖页面私有数据和 helper，生成片段无法独立复制。Web 组件文档又保存了手写代码或仅链接页面源码，容易与实际运行示例长期分叉。

Table 页面同时包含静态、受控交互、固定列和样式示例，作为目录拆分及自包含代码的完整样板；该结构进一步覆盖全部组件 Demo、基础页与其辅助 example，映射能力覆盖全部组件文档。

## 目标

- 将 57 个组件页面、3 个额外基础页及其公开模块统一整理到 `page/<component>/`，入口固定命名为 `<component>_page.dart`。
- 每个 `ExampleModule` 独立为一个语义文件；Calendar 农历数据、Sidebar 子页及既有 Form、Progress、Stepper、Tag、TreeSelect 辅助 example 归入所属组件目录。
- 每个 Table `ExampleItem` 映射到一份包含 imports、数据、状态和回调的完整生成片段。
- 57 份组件 Web Markdown 均按组件组引用全部生成资产，不再复制第二份 Dart 源码。
- Web 构建在映射格式非法或目标资产不存在时失败。
- 用自动清单验证所有组件文档，并抽查 Table、Stepper、Form 三类不同形态的示例。

## 非目标

- 不改变 `TTable` 公共 API、默认行为或视觉结果。
- 不修改 Golden 基线。
- 不把每个 `ExampleItem` 机械拆成文件；仅按公开 `ExampleModule` 划分，跨模块状态和生命周期仍由页面 State 持有。

## 范围

### 涉及

- 全部组件与基础 Example 页面目录、模块声明、辅助 example 和生成代码资产。
- Example 配置与 Demo 测试的入口引用。
- Web Markdown 转换器、映射测试及全部 57 份组件文档。

### 不涉及

- `tdesign-component/lib/` 下的生产组件实现。
- 站点导航和 API 文档生成。

## 行为契约

- 每个目录仅有一个 `<component>_page.dart` 页面入口；入口负责元信息、模块顺序、页面状态与生命周期，模块文件负责对应 `ExampleModule` 注册。
- 60 个入口覆盖 57 个组件和 Font、Radius、Shadows 三个额外基础页；141 个模块文件均使用 `type`、`status`、`style`、`size` 等业务语义命名，不使用序号前后缀。
- `table/table_page.dart` 保持 Table Demo 唯一入口；`table_type.dart` 与 `table_style.dart` 分别承载两个公开 `ExampleModule`，排序状态归属于排序示例自身。
- 每个代码面板显式使用与 `@ExampleCode` 产物一致的稳定 `methodName`。
- 组件 Web 指令格式为 `{{ flutter-example-group <group> }}`，展开该组全部生成资产；单片段指令 `{{ flutter-example <group>.<name> }}` 仅作为底层能力保留。
- 组件文档目录名与生成组按忽略 `-`、`_` 和大小写的规则一一匹配；每份文档必须且只能有一个组映射。
- 全部 57 份组件文档不得保留手写 Dart `td-code-block`；`radius`、`shadows` 属于 Example 基础配置页，没有组件 Web 路由，不纳入组件文档映射。
- 找不到资产时不得降级为“建设中”，必须抛出错误阻止发布过期文档。
- `dart run tool/check_demo_structure.dart` 必须阻止入口回退到 `page/` 根目录、模块重新内联、非语义模块名、缺失 config 引用和 Calendar 辅助文件漂移。

## 验收标准

- [x] Table 9 个公开示例的顺序、文案、尺寸、交互和 Golden 均保持不变。
- [x] 57 个组件、3 个额外基础页和关联辅助 example 均完成目录迁移，141 个 `ExampleModule` 独立成语义文件。
- [x] Table 9 个代码面板均显示自包含的类级示例源码。
- [x] 57 份组件 Web 文档直接映射 404 份生成资产。
- [x] 映射测试覆盖全部文档清单，并抽查 Table、Stepper、Form 以及非法键、缺失资产。
- [x] 结构检查、示例生成器 `--check`、多组件抽查、站点构建和双版本 analyze 通过。
