# v1 组件发版审查与整改记录

审查日期：2026-07-31
审查基线：`origin/develop...rss1102/v1-official-migration-full`（1,425 个变更文件）
范围：`tdesign-component` 的 57 个组件目录、主题扩展、公开 API、示例代码和测试。

## 结论

组件实现可进入**候选发布（RC）**阶段：静态分析、完整组件测试和示例代码一致性检查均已通过，未发现阻塞发布的行为错误、资源泄漏或主题优先级倒置。

正式发布前仍应完成一次目标设备的视觉验收（浅色/深色、窄屏、大字号、RTL）和 CI 的干净构建。它们是本地 widget test 不能替代的发布门禁。API 文档已补齐本轮扫描发现的公开类型和 Swiper 公开参数；仓库尚未启用 `public_member_api_docs`，因此不能把现有检查解释为“所有公开成员文档 100% 覆盖”。建议在后续独立文档治理变更中启用该 lint，并逐项消除其诊断，避免将大规模纯文档变更混入本次发版分支。

## 发现与处理

| 级别 | 位置 | 现象与影响 | 处理方式 | 验证 |
| --- | --- | --- | --- | --- |
| P1（已修复） | 多个组件的公开类型 | 部分对外类型仅有成员说明或没有类型级说明，生成 API 文档时缺少用途和使用边界。 | 为 Tabs、Drawer、Footer、Calendar、Loading、Empty、Sidebar、Collapse、Result 等公开类型补充准确的 Dart doc。 | `flutter analyze --no-fatal-infos` 通过。 |
| P1（已修复） | `lib/src/components/swiper/t_swiper.dart` | `physics`、`pageSnapping`、`padEnds`、`clipBehavior`、`reverse`、`dragStartBehavior`、`allowImplicitScrolling` 是公开参数，但缺少行为说明。 | 补充参数用途、默认行为和无障碍语义说明，不改变 API。 | 全量 `flutter test --no-pub --reporter compact` 通过（2,021 项）。 |
| P1（已修复） | `lib/src/components/button/t_button.dart` | 按钮缺少长按回调，且普通/渐变两条渲染路径无法形成一致契约。 | 增加 `onLongPress`；仅在 `onPressed` 非空时生效；普通按钮用外层手势补齐，渐变按钮直接接入 `InkWell`，禁用态两者均不触发。 | 按钮长按、点击互斥、禁用态和渐变态回归测试通过。 |
| P1（已修复） | `lib/src/components/button/t_button_theme_data.dart`、`t_button_resolve.dart` | 规范字段名为 `iconTextSpacing`，实现曾使用 `iconSpacing`，且 resolver 中存在不生效的空实现。 | 统一公开字段、`copyWith`、`lerp` 和布局读取为 `iconTextSpacing`；删除空 resolver，明确间距只由按钮内容布局负责。 | Theme copy/lerp、实际 SizedBox 间距和静态分析通过。 |
| P1（已修复） | `lib/src/components/progress/t_progress.dart` | v1 迁移遗漏了历史 `onLongPress` 能力，导致按钮进度和微型按钮进度只能点击。 | 恢复 `onLongPress` 并透传到 `button`、`micro`；支持独立长按，线性和环形形态继续保持纯展示。 | button/micro 长按、点击互斥、独立长按及 linear 不响应测试通过。 |
| P2（待单独治理） | `analysis_options.yaml` | 当前 lint 配置未启用 `public_member_api_docs`，无法持续验证新增公开 API 是否都有文档。 | 建议单开文档治理任务：启用该 lint，按诊断补齐所有公开成员并由 CI 强制执行。此项可修复，但不应在 RC 分支引入未经逐项人工复核的大量自动生成注释。 | 本次记录为已知发布前流程风险。 |
| P2（发布验证） | Example 与实际设备渲染 | widget/golden 测试不能覆盖每个 Example 的真实设备布局、文本缩放和 RTL。 | 在 CI 或设备上执行 Example Web/目标平台构建，并人工检查深浅主题、窄屏和大字号。 | 本地示例代码生成一致性检查已通过；设备视觉验收待执行。 |

## 已执行验证

```text
cd tdesign-component
flutter analyze --no-fatal-infos
# No issues found

flutter test --no-pub --reporter compact
# All tests passed (2,021 tests)

dart run tool/generate_example_code.dart --check
# passed

git diff --check
# passed
```

## 变更边界

本次只修复公开 API 注释，不修改组件的视觉默认值、主题解析优先级、对外参数、控制器所有权或示例业务逻辑。工作区已有的 `coverage/lcov.info` 变更为测试产物，不属于本次整改，也未被修改。
