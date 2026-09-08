# Component Test Manifest

## 背景

组件生产覆盖目标、组件测试、Demo 功能测试和视觉回归测试分别维护在三个 Dart 文件及 GitHub/CNB 配置中。新增组件测试时需要同时修改多个列表，容易产生遗漏和合并冲突。

## 目标

- 每个已登记组件只维护一条强类型 Dart manifest。
- 从 manifest 派生生产覆盖目标、组件回归和视觉回归执行清单。
- GitHub 与 CNB 通过同一个 runner 执行 Demo 功能测试。
- 保持现有测试文件集合、覆盖率阈值、Golden 平台和执行参数不变。

## 非目标

- 不自动扫描目录；测试归属仍需维护者显式声明。
- 不改变组件源码、公开 API、测试内容或覆盖率阈值。
- 不把不同工作目录或执行参数的视觉 suite 合并为一个命令。

## 契约

- `componentTestManifests` 是唯一的组件配置数组，组件名称唯一。
- 每条组件记录分别声明 `coverageTargets`、`componentTests`、`exampleTests` 和 `visualTests`。
- 一个组件可以拥有多个视觉 suite，每个 suite 保留自己的工作目录、测试文件和附加参数。
- 全仓共享而不归属单个组件的 Demo 测试放在 `sharedExampleTests`。
- CI 文件只调用 runner，不直接枚举测试文件。
