# Popover 验证范围与结论

<a id="record-003-contract-hardening"></a>
<a id="record-015-color-scheme-instance-ownership"></a>
<a id="record-022-public-api-convergence"></a>
<a id="record-027-controller-theme-lerp"></a>

## 本次范围

2026-10-20：整理设计背景、决策和验收记录，重点冲突对照公开源码检查；本次未重新执行组件、Golden、设备或远端 CI。以下是原有范围内的证据摘要，不构成当前候选通过声明。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| TPopover：交互、主题、尺寸与浮层边界契约补强 | `fb26b8d5`；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |
| Tag 与 Popover 视觉选择器实例所有权收敛 | `f4bcfddc`；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围） |
| TPopover 公开 API 收敛 | `230140c1`；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |
| TPopover 双层控制模式与主题插值 | `682c563d`；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：未提取到可独立确认的通过结论；设备：仅按下文的实际操作与未覆盖范围解释 |

同一原记录可能包含多个复验阶段；上表保留原文可识别的提交、源码/参考源标识与 SDK；这些标识不保证是同一个验证候选，不把它们合成为一次完整矩阵。未提供唯一候选或原始日志绑定的结果，须在实际交付时复核。

## 验证范围与未覆盖项

以下保留各事项原有的文字验收结论与未覆盖项。本次未重新执行组件验收；历史截图及独立对比附件已移除。

- 锚点 Element unmounted 后会通过私有生命周期守卫复用幂等 dismiss，自动移除 OverlayEntry、清理监听器并完成 showPopover Future；已由 Widget 测试覆盖。
- placement 仅做同轴反向翻转，不会在纵向和横向之间跨轴选择。
- 超长文本在 maxHeight 下的滚动、裁切或省略策略尚未形成公共契约，本次不扩展。
- 目标设备人工验收尚未执行，因此本 Spec 暂不标记为完全关闭。

- 尚未执行远端 CI 与代码审查；需在提交、推送并创建 PR 后由平台完成。

## 原记录提到的验证入口

- `flutter test --no-pub --exclude-tags golden test/components/popover/t_popover_test.dart test/tool/run_visual_regression_test.dart`
- `flutter analyze lib/src/components/popover test/components/popover`
- `flutter test test/popover_page_test.dart`
- `dart run tool/generate_example_code.dart --check`
- `flutter analyze lib/page/t_popover_page.dart test/popover_page_test.dart`
- `flutter build web`
- `node scripts/check-flutter-component-contracts.mjs`
- `flutter test test/popover_demo_test.dart`
- `flutter test --no-pub --update-goldens test/popover_demo_golden_test.dart --name ' light '`
- `flutter test --no-pub --update-goldens test/popover_demo_golden_test.dart --name ' dark '`
- `flutter test test/components/tag/t_tag_test.dart test/components/tag/t_select_tag_test.dart test/components/popover/t_popover_test.dart`
- `flutter test test/components/theme/t_material_theme_priority_test.dart`
- `flutter test --exclude-tags golden test/popover_page_test.dart test/tag_page_test.dart`
- `flutter test test/tool/check_component_coverage_test.dart test/tool/run_component_regression_test.dart test/tool/run_visual_regression_test.dart`
- `flutter test test/components/tag/t_tag_test.dart test/components/tag/t_select_tag_test.dart --coverage`
- `flutter test test/components/popover/t_popover_test.dart --coverage`
- `flutter analyze`
- `flutter test --exclude-tags golden test/components/popover/t_popover_test.dart`
- `flutter test --no-pub test/popover_demo_golden_test.dart`
- `flutter test --no-pub --coverage test/components/popover/t_popover_test.dart`
- `dart run tool/check_component_coverage.dart popover`
- `flutter analyze --fatal-infos`

入口仅用于追溯原记录；是否执行、对应环境和结果以原范围为准，不表示本轮重跑。

## 必要证据与追溯

原记录未给出可独立访问且绑定唯一候选的原始日志入口；保留的基线标识不能代替缺失证据。后续验证在此追加与最终方案相关的结论及必要链接，不重复保存每次运行流水。

明确待办统一见 [tasks.md](./tasks.md)。没有新证据时不变更完成状态；已有日期与 SHA 只描述原记录覆盖范围。
