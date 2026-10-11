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
├── example         # 组件示例应用
├── lib             # 组件公开实现与主题
├── test            # 组件和工具测试
└── tool            # 测试登记与回归工具

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

`pnpm dev` 需要先完成上面的示例应用依赖安装，同时启动文档站点（默认 `19000`）和 Flutter Web 示例（默认 `19001`）；浏览器打开 `http://localhost:19000/flutter/getting-started`。如果右侧示例未显示，检查 Flutter Web 日志和端口占用。

只修改文档时，可用 `pnpm dev:site` 单独启动文档站点；需要组件预览时再使用 `pnpm dev`。构建官网使用 `pnpm site`，其中会先执行主题桥接和组件文档契约检查。

## 3. 讨论需求与领取 Issue

提交前先搜索[常见问题](https://tdesign.tencent.com/flutter/faq)、[更新日志](https://tdesign.tencent.com/flutter/changelog)和 [GitHub Issues](https://github.com/Tencent/tdesign-flutter/issues)，避免重复反馈。

- 在 Issue 中写明预期行为、当前行为、版本及复现方式；有意贡献时评论领取，并与负责人确认实现范围。
- 群内讨论得到的需求和验收结论应补充到 GitHub Issue，方便后续参与者追踪。
- 需要设计走查的改动，由负责人协调设计同学；PR 中保留相关验收记录。


## 4. 实现与文档

组件命名、主题所有权、国际化资源、公开 API 注释等规则请阅读[开发规范](https://github.com/Tencent/tdesign-flutter/blob/develop/CONTRIBUTING.md#开发规范)。公共 API 的 `///` dartdoc 是生成用户文档的来源，修改 API 时同步说明默认值、生效条件、空值语义及相关参数关系。

复杂需求、公共 API 变更、组件重构和跨目录改动按 [Spec 流程](https://github.com/Tencent/tdesign-flutter/blob/develop/specs/README.md)记录行为契约、实施方案和验收结果。是否需要 Spec 与是否需要更新日志分别判断。

### 修改文档来源

修改组件 API 时更新源码中的 `///` 注释，修改演示时更新示例源码，修改快速开始时更新根目录中文 README。API、示例片段和 README 副本由 PR 的 autofix 流水线生成，无需手工维护。

新增组件或排查生成问题时，参考 [API 与示例工具说明](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/demo_tool/README.md)和[生成产物说明](https://github.com/Tencent/tdesign-flutter/blob/develop/AGENTS.md)。

## 5. 按改动类型验证

| 改动类型 | 必要检查 |
| --- | --- |
| 只修改文档 | 预览改动页面，检查代码、链接和导航；官网改动执行 `pnpm site` |
| 修改组件或示例 | 静态分析、相关组件与示例测试，验证改动功能及边界情况 |
| 涉及视觉变化 | 在组件检查基础上补充明暗主题、局部主题和 Golden 验证 |
| 涉及平台能力 | 在目标 Android/iOS 设备验证，例如相册选择；Web 预览不能代替真机 |

组件或示例改动，从 `tdesign-component` 目录执行：

```bash
flutter analyze --fatal-infos
```

新增测试须登记到 [`tool/component_test_manifest.dart`](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/tool/component_test_manifest.dart)，让 CI 执行。功能回归覆盖 Flutter `3.32.0` 与最新 stable，生产 Dart 行覆盖率要求至少 95%；测试命令和登记方法见[组件测试与 CI 回归门禁](https://github.com/Tencent/tdesign-flutter/blob/develop/CONTRIBUTING.md#组件测试与-ci-回归门禁)。Golden 使用[视觉回归 CI](https://github.com/Tencent/tdesign-flutter/blob/develop/.github/workflows/test-build.yml)规定的 SDK 和平台。

记录实际验证结果和未覆盖项，写入 PR 或 Spec 的 `acceptance.md`。如使用 PR 预览包，以流水线日志和评论中的版本为准。

## 6. 提交 PR

使用仓库的 [PR 模板](https://github.com/Tencent/tdesign-flutter/blob/develop/.github/PULL_REQUEST_TEMPLATE.md)，完整保留小节、所有已选与未选选项以及 HTML 注释，只打勾和填写。PR 标题遵循 Conventional Commits；breaking change 使用 `breaking` type，并说明受影响 API、默认行为或删除能力及迁移方法。

关联 GitHub Issue，填写问题、解决方案和实际验证结果；需要 Spec 时附上目录链接。更新日志只描述用户可感知的变化，内部调整和行为不变的重构不写日志；判断与格式见 [PR 更新日志规范](https://github.com/Tencent/tdesign-flutter/blob/develop/CONTRIBUTING.md#pr-更新日志规范)。`CHANGELOG.md` 由发布工具生成，无需手动编辑。

等待 CI 和 Review，并基于最新 PR 提交确认验证结果。问题验收、设计走查和必要检查完成后，由负责人合并。
