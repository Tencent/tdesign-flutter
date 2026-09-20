# 验收记录

## 验证环境

- 分支：`rss1102/refactor/demo-example-web-mapping`
- 基线：`origin/develop@66aa15d17`
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0 / Dart 3.13.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `dart run tool/check_demo_structure.dart` | PASS | 60 个入口、0 个旧分组文件；375 个公开 ExampleItem 与 375 个独立 `@ExampleCode` 文件、生成资产一一对应 |
| `dart run tool/generate_example_code.dart --check` | PASS | 375 份片段与 manifest 完全同步，`legacyGroups: []` |
| `flutter test test/tool/generate_example_code_test.dart` | PASS | Flutter 3.32，11/11；覆盖整文件导出、显式辅助文件合并、严格页面、拒绝缺失页面清单及内部条件模块 |
| `flutter analyze --no-pub --fatal-infos` | PASS | Flutter 3.32，根包与 example 子包均 0 issues |
| Flutter 3.47 `flutter analyze --no-pub --fatal-infos` | PASS | 根包与 example 子包均 0 issues |
| example 全量非视觉测试 | PASS | 排除独立 Golden 文件和 `golden` tag 后，69 个测试文件、294/294 |
| `npm run test:example-code` | PASS | Node 映射测试 6/6；57 份组件文档映射 365 份组件示例，另有 fonts/radius/shadows 10 份基础示例 |
| `npm run site` | PASS | 站点生产构建完成，108 modules transformed |
| `git diff --check` | PASS | 无空白错误 |
| Linux 3.32 Golden / 远端 CI | PASS | PR #1142，`42bdd37a`：Linux Flutter 3.32 全量视觉回归、Flutter 3.32/latest analyze/test、Android/iOS/Web 构建、站点构建、autofix、CodeCC、拼写与 CLA 全部通过 |

## 人工与结构抽查

- [x] ExampleModule 分组和完整 ExampleItem 配置已合并到 60 个页面入口，纯分组模块文件全部移除。
- [x] 375 个公开 ExampleItem 各自对应一个独立语义文件，运行页面和 Web 代码面板引用同一 Widget。
- [x] state、Controller、helper 与生命周期归属于对应示例；Progress、Stepper、Calendar、FAB、BackTop、Theme、Toast、Popover 等复杂页面已分别复测。
- [x] Sidebar 的四个辅助详情页通过显式 `includes` 合并进相应可复制代码，不由解析器猜测隐藏依赖。
- [x] Popover 仅跳过完全由 `ignoreCode: true` 项组成的内部条件模块；公开条件模块仍会被严格解析拒绝。
- [x] 生成资产不含本地相对导入，也不依赖 `CodeWrapper`、`ExamplePageModel` 或 `ExamplePageInheritedTheme`。
- [x] Web 严格按 manifest 恢复公开分组、描述和顺序；缺少描述时才以示例类名兜底。
- [x] Table、Stepper、Form、Calendar、Sidebar、Popover、Progress、Tag、TreeSelect 等不同复杂度代码面板已由 Widget 测试实际加载。
- [x] 57 份组件文档均只有一个组映射，无手写 Dart `td-code-block`，未注册资产不会进入文档。
- [x] `42bdd37a` 的 Linux 3.32 Golden 与全部远端 CI 通过。

## 复杂示例归属判断

- 示例自身可拥有的状态、Controller、局部数据、回调和生命周期全部迁入独立 example Widget/State。
- 页面壳必须拥有的跨示例宿主行为保留在页面，例如 FAB 当前悬浮层、BackTop 页面滚动容器；独立示例通过显式回调或公开工厂连接，不依赖页面私有字段。
- 只有一个公开示例需要的同文件 helper 由整文件生成直接保留；Sidebar 这类真实的多文件辅助页面通过显式 `includes` 声明。
- 解析器只处理语法结构和显式依赖，不通过名字或调用链猜测业务依赖；解析不合理时优先修正示例所有权，只有合法完整源码仍无法表达时才扩展解析能力。

## Golden 说明

- macOS 本地 Golden 会因平台字体栅格差异产生批量像素差异，因此没有更新 Linux 权威基线。
- `42bdd37a` 的 PR Linux Flutter 3.32 全量 Golden 已通过；没有更新任何 Golden 基线。
- 迁移后首次失败来自示例宿主边界而非解析器：Picker/Calendar 弹层需从页面 Navigator 上下文打开，Sidebar 辅助页需保留独立页面壳，Icon 需保留公开数量描述。修复后对应旧 Golden 全部通过。
