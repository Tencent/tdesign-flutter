---
title: 贡献指南
description: 运行项目、提交贡献并验证 TDesign Flutter 的改动。
spline: explain
---

本页介绍从运行项目到提交 PR 的操作流程。开发、协作、PR 和更新日志规则以仓库根目录的 [CONTRIBUTING.md](https://github.com/Tencent/tdesign-flutter/blob/develop/CONTRIBUTING.md) 为准；复杂需求和公共契约变更先阅读 [Spec 规范](https://github.com/Tencent/tdesign-flutter/blob/develop/specs/README.md)。

## 1. 准备项目

### 开发环境

- Flutter 最低版本为 `3.32.0`，Dart 最低版本为 `3.8.0`；代码需要同时兼容 Flutter `3.32.0` 和最新 stable。
- 官网使用 pnpm，版本见 [package.json](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-site/package.json) 的 `packageManager` 字段。
- Flutter 安装和设备配置请参考 [Flutter 官方文档](https://docs.flutter.cn/install)。

### 获取源码

```bash
git clone https://github.com/Tencent/tdesign-flutter.git
cd tdesign-flutter
git switch develop
git pull --ff-only
```

从最新 `develop` 创建功能分支，分支和 PR 命名按[仓库协作规范](https://github.com/Tencent/tdesign-flutter/blob/develop/AGENTS.md)执行。

### 目录结构

```text
tdesign-component/
├── demo_tool       # API 生成兼容入口
├── example         # 组件示例应用及生成的 API、代码片段
├── lib             # 组件公开实现与主题
├── test            # 组件和工具测试
└── tool            # API manifest、生成器、测试登记与回归 runner

tdesign-site/       # 官网、组件文档和本地预览
specs/              # 设计与验收记录
```

## 2. 运行与预览

### 组件示例应用

从仓库根目录执行：

```bash
cd tdesign-component
flutter pub get
cd example
flutter pub get
flutter devices
flutter run -d <device-id>
```

将 `<device-id>` 替换为 `flutter devices` 列出的设备 ID。Android 或 iOS 设备用于验证平台能力和移动端交互；Web 可以预览组件，但不能代替相册选择等平台能力的真机验收。

### 官网与 Flutter Web 示例

从仓库根目录执行：

```bash
cd tdesign-site
pnpm install --frozen-lockfile
pnpm dev
```

请先完成上面的示例应用依赖安装。`pnpm dev` 同时启动文档站点（默认 `19000`）和 Flutter Web 示例（默认 `19001`）；浏览器打开 `http://localhost:19000/flutter/getting-started`。如果右侧示例未显示，检查 Flutter Web 日志和端口占用。

只修改文档时，可用 `pnpm dev:site` 单独启动文档站点；需要组件预览时再使用 `pnpm dev`。构建官网使用 `pnpm site`，其中会先执行主题桥接和组件文档契约检查。

## 3. 讨论需求与领取 Issue

提交前先搜索[常见问题](https://tdesign.tencent.com/flutter/faq)、[更新日志](https://tdesign.tencent.com/flutter/changelog)和 [GitHub Issues](https://github.com/Tencent/tdesign-flutter/issues)，避免重复反馈。

- 在 Issue 中写明预期行为、当前行为、版本及复现方式；有意贡献时评论领取，并与负责人确认实现范围。
- 群内讨论得到的需求和验收结论应补充到 GitHub Issue，方便后续参与者追踪。
- 需要设计走查的改动，由负责人协调设计同学；PR 中保留相关验收记录。

Issue 标签由负责人维护：`issueShoot` 表示已评估、可领取，`Received` 表示已领取，`pre_x.x.x` 表示预计发布版本，`x.x.x` 表示已发布版本。Issue 关联与关闭按[仓库规范](https://github.com/Tencent/tdesign-flutter/blob/develop/CONTRIBUTING.md#pr-关联-issue)处理。

## 4. 实现与文档

组件命名、主题所有权、国际化资源、公开 API 注释等规则请阅读[开发规范](https://github.com/Tencent/tdesign-flutter/blob/develop/CONTRIBUTING.md#开发规范)。公共 API 的 `///` dartdoc 是生成用户文档的来源，修改 API 时同步说明默认值、生效条件、空值语义及相关参数关系。

复杂需求、公共 API 变更、组件重构和跨目录改动按 [Spec 流程](https://github.com/Tencent/tdesign-flutter/blob/develop/specs/README.md)记录行为契约、实施方案和验收结果。是否需要 Spec 与是否需要更新日志分别判断。

### API 和示例来源

- API 清单维护在 [`tdesign-component/tool/components.json`](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/tool/components.json)，公开范围以 `lib/tdesign_flutter.dart` 的导出为准。
- `demo_tool/all_build.sh` 调用 `tool/generate_api.mjs`，生成 `example/assets/api/*.md`。新增或迁移组件时更新 manifest；无需配置旧的 API 二进制。
- 示例方法标记 `@ExampleCode`，`group` 与页面的 `exampleCodeGroup` 一致，生成 `example/assets/code/*.txt`。
- 官网组件页通过 `flutter-example-group` 和 `flutter-api` 指令读取示例与 API 产物。新增组件时同时核对菜单、组件概览和页面指令的组件标识。
- 根目录 README 由 `scripts/sync-readme.mjs` 同步到组件包，中文 README 的接入部分生成官网快速开始。

PR 的 autofix 流水线会自动生成 API、代码片段和 README 副本，贡献者无需手工维护这些产物。需要本地排查时，从相应源文件修正后运行以下命令：

```bash
# 在 tdesign-component 目录执行
sh demo_tool/all_build.sh
node tool/generate_api.mjs --check
dart run tool/generate_example_code.dart
dart run tool/generate_example_code.dart --check

# 在仓库根目录执行
node scripts/sync-readme.mjs
```

生成方式见 [API 与示例工具说明](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/demo_tool/README.md)。autofix 更新 PR 后，应检查最新提交的生成差异和后续 CI 结果。

## 5. 验证改动

### 代码与自动化回归

从 `tdesign-component` 目录执行静态检查，要求零诊断：

```bash
flutter analyze --fatal-infos
```

新增或补充组件测试时，在 [`tool/component_test_manifest.dart`](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/tool/component_test_manifest.dart) 登记组件测试、生产源码覆盖率目标、Demo 功能测试和视觉回归。手写生产 Dart 行覆盖率要求 `LH/LF >= 95%`；详细字段和共享示例测试登记见[组件测试与 CI 回归门禁](https://github.com/Tencent/tdesign-flutter/blob/develop/CONTRIBUTING.md#组件测试与-ci-回归门禁)。

```bash
flutter test --no-pub test/tool/check_component_coverage_test.dart test/tool/run_component_regression_test.dart test/tool/run_visual_regression_test.dart
dart run tool/run_component_regression.dart
dart run tool/run_example_regression.dart
dart run tool/run_visual_regression.dart
```

功能回归需要覆盖 Flutter `3.32.0` 与最新 stable。Golden 按[视觉回归 CI](https://github.com/Tencent/tdesign-flutter/blob/develop/.github/workflows/test-build.yml)规定的 SDK 和平台运行；不能以本机另一平台生成的图片代替 CI 基线。测试文件存在或单独运行通过，不代表已进入集中式 CI 调度。

### 示例与人工验收

- 检查新增能力、受控状态回写、边界输入和 Controller 生命周期。
- 检查布局溢出、点击与滚动、浅色与深色主题、局部主题覆盖和英文环境。
- 在示例页打开 API 与源码面板，核对内容是否与实现一致；缺失时检查 manifest、注解分组及生成日志。
- 示例页的 `test` 区域用于补充交互验收场景，不能代替自动化测试。
- 涉及平台能力时在目标设备验证；涉及视觉变化时补充 Golden 和必要的设计走查。

PR 预览包是否生成以及使用哪个 SDK，以流水线实际日志和 PR 评论为准。拿到预览包后按上述场景验证，将结果和未覆盖项写入 PR 或 Spec 的 `acceptance.md`。

## 6. 提交 PR

使用仓库的 [PR 模板](https://github.com/Tencent/tdesign-flutter/blob/develop/.github/PULL_REQUEST_TEMPLATE.md)，完整保留小节、所有已选与未选选项以及 HTML 注释，只打勾和填写。PR 标题遵循 Conventional Commits；breaking change 使用 `breaking` type，并说明受影响 API、默认行为或删除能力及迁移方法。

关联 GitHub Issue，填写问题、解决方案和实际验证结果；需要 Spec 时附上目录链接。更新日志只描述用户可感知的变化，内部调整和行为不变的重构不写日志；判断与格式见 [PR 更新日志规范](https://github.com/Tencent/tdesign-flutter/blob/develop/CONTRIBUTING.md#pr-更新日志规范)。`CHANGELOG.md` 由发布工具生成，无需手动编辑。

等待 CI 和 Review，并基于最新 PR 提交确认验证结果。问题验收、设计走查和必要检查完成后，由负责人合并。
