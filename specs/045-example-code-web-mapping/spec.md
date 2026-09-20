# Example 示例代码与 Web 文档单源映射

## 背景

Example App 通过 `@ExampleCode` 生成 `example/assets/code/*.txt`，但部分示例方法依赖页面私有数据和 helper，生成片段无法独立复制。Web 组件文档又保存了手写代码或仅链接页面源码，容易与实际运行示例长期分叉。

Table 页面同时包含静态、受控交互、固定列和样式示例，作为目录拆分及自包含代码的完整样板；该结构进一步覆盖全部组件 Demo、基础页与其辅助 example，映射能力覆盖全部组件文档。

## 目标

- 将 57 个组件页面、3 个额外基础页及其公开模块统一整理到 `page/<component>/`，入口固定命名为 `<component>_page.dart`。
- `<component>_page.dart` 统一保存页面元信息、`ExampleModule` 分组、完整 `ExampleItem` 配置和顺序；每个公开 `ExampleItem` 引用的实际 Widget 独立为一个语义 example 文件。
- 每个公开示例文件只保存可运行 Widget 及其 imports、数据、状态、回调、helper 和适用的生命周期，不包含 `ExampleItem` 或其他 Example 页面基础设施，也不依赖页面入口或其他示例的私有声明。
- 示例没有跨帧可变状态、Controller 或生命周期时必须使用 `StatelessWidget`；只有确实需要 `setState`、资源释放或生命周期协调时才使用 `StatefulWidget`，避免把样板 State 暴露给复制代码的用户。
- Calendar 农历数据、Sidebar 子页及既有 Form、Progress、Stepper、Tag、TreeSelect 辅助 example 归入所属组件目录，并由对应示例显式引用。
- 57 份组件 Web Markdown 均按组件组引用全部生成资产，不再复制第二份 Dart 源码。
- Web 构建在映射格式非法或目标资产不存在时失败。
- 用自动清单验证所有组件文档，并抽查 Table、Stepper、Form 三类不同形态的示例。

## 非目标

- 不改变 `TTable` 公共 API、默认行为或视觉结果。
- 不修改 Golden 基线。
- 不为每个 `ExampleItem` 再创建一层目录；示例文件直接位于组件目录内。
- 不由生成器猜测或递归拼装隐藏依赖；可复制代码的完整性必须由实际运行的示例文件保证。

## 范围

### 涉及

- 全部组件与基础 Example 页面目录、页面分组声明、辅助 example 和生成代码资产。
- Example 配置与 Demo 测试的入口引用。
- Web Markdown 转换器、映射测试及全部 57 份组件文档。

### 不涉及

- `tdesign-component/lib/` 下的生产组件实现。
- 站点导航和 API 文档生成。

## 行为契约

- 每个目录仅有一个 `<component>_page.dart` 页面入口；入口负责页面元信息、`ExampleModule` 分组、`ExampleItem` 配置和顺序，不另建只承载分组的模块文件。
- 60 个入口覆盖 57 个组件和 Font、Radius、Shadows 三个额外基础页；每个公开 `ExampleItem` 使用场景语义命名的独立文件，不使用序号前后缀。
- 页面入口只持有 `ExampleItem` 的 key、描述、布局选项、代码映射名和 Widget 构建入口，不得持有公开示例运行所需的可变状态、Controller、业务数据或私有 helper；这些声明必须归属于对应 example 文件内的 Widget/State。
- 只承担页面占位、滚动背景或测试支撑的辅助内容必须使用 `ignoreCode: true`，不得登记 `methodName` 或 `@ExampleCode`；Web 清单只包含用户可复制的公开组件示例。
- `table/table_page.dart` 保持 Table Demo 唯一入口并直接承载两个公开 `ExampleModule`；排序状态归属于排序示例自身。
- 每个公开 `ExampleItem` 显式映射到自身文件中的类级 `@ExampleCode`，运行 Demo 和代码面板使用同一个 Widget 类。
- `@ExampleCode` 只标记源码生成边界，不进入生成资产；生成器不得通过改写 Widget 类型来“美化”代码，示例源码本身必须是可复制的规范实现。
- 组件 Web 指令格式为 `{{ flutter-example-group <group> }}`，按公开模块和 ExampleItem 顺序展开该组生成资产；不得按文件名排序混入测试专用或未注册片段。单片段指令 `{{ flutter-example <group>.<name> }}` 仅作为底层能力保留。
- Flutter 专属清单解析与渲染由 `tdesign-site/site/flutter-example-docs/` 适配层负责；严格组必须显示 `ExampleModule.title` 和 `ExampleItem.desc`，内部 Widget 类名只作为缺少公开描述时的兜底。可复用的 `vite-plugin-tdoc`、本地插件封装和 `td-code-block` 不承担 Flutter 业务语义。
- 组件文档目录名与生成组按忽略 `-`、`_` 和大小写的规则一一匹配；每份文档必须且只能有一个组映射。
- 全部 57 份组件文档不得保留手写 Dart `td-code-block`；`radius`、`shadows` 属于 Example 基础配置页，没有组件 Web 路由，不纳入组件文档映射。
- 找不到资产时不得降级为“建设中”，必须抛出错误阻止发布过期文档。
- Web 代码面板必须显示并复制解码后的完整 Dart 源码；站点代码块不支持 Dart grammar 时，由 Flutter 文档适配层选择兼容 grammar，不得把 URL 编码文本直接暴露给用户。
- `tdesign-site` 的默认开发命令必须同时启动文档站和 Flutter Web 示例，并让右侧预览指向同一开发主机的 Flutter 服务；生产构建仍使用 `/flutter/example/` 静态产物。
- `dart run tool/check_demo_structure.dart` 必须阻止入口回退到 `page/` 根目录、纯分组模块文件残留、ExampleItem 实现未独立成文件、页面持有示例私有状态、非语义命名、缺失 config 引用和辅助文件漂移。
- CI 必须验证全部公开 ExampleItem 与生成资产一一对应、顺序一致，并验证每份类级示例源码在最小宿主中可解析或编译；仅检查文件存在和数量不算通过。

## 验收标准

- [x] Table 9 个公开示例的顺序、文案、尺寸、交互和 Golden 均保持不变。
- [x] 57 个组件、3 个额外基础页和关联辅助 example 均完成目录迁移。
- [x] 57 个组件及 3 个基础页的全部公开 ExampleItem 均独立成语义文件，并由页面入口中的对应模块按原顺序引用。
- [x] 每个公开 ExampleItem 均显示来自同一运行 Widget 的自包含类级源码，不存在未定义字段、helper、Controller 或页面 State 依赖。
- [x] 57 份组件 Web 文档按公开 ExampleItem 顺序映射生成资产，不混入测试专用或未注册片段。
- [x] 映射测试覆盖全部文档清单、ExampleItem 一一对应、顺序以及非法键和缺失资产；Flutter Widget 回归覆盖生成代码面板的真实加载。
- [x] 结构检查、示例生成器 `--check`、全组件测试、站点构建、双版本 analyze 和 Linux Golden 通过。
- [x] Web 代码面板显示可复制源码，开发模式右侧 Flutter Web 预览可实际加载。
- [x] Button、Divider、Fab、Icon、Link、Text 基础组件示例按真实状态需求选择 Widget 类型；19 个无状态示例已移除空 State 样板，确有交互状态的 Icon 示例仍保留 `StatefulWidget`。
- [x] FAB 页面骨架仅作为悬浮按钮的滚动背景，不进入公开示例清单或 Web 代码面板。
