# Form 验证范围与结论

<a id="record-008-input-contract-alignment"></a>
<a id="record-039-design-details"></a>

## 本次范围

2026-10-20：整理设计背景、决策和验收记录，重点冲突对照公开源码检查；本次未重新执行组件、Golden、设备或远端 CI。以下是原有范围内的证据摘要，不构成当前候选通过声明。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| Form 与 Input 职责及 API 对齐 | `044122f61d78ce1c122b8f66b38742b13554dcf4`；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |
| Form 受控状态、主题与 Demo 设计细节对齐 | `33fbe96d`；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |

同一原记录可能包含多个复验阶段；上表保留原文可识别的提交、源码/参考源标识与 SDK；这些标识不保证是同一个验证候选，不把它们合成为一次完整矩阵。未提供唯一候选或原始日志绑定的结果，须在实际交付时复核。

## 验证范围与未覆盖项

以下保留各事项原有的文字验收结论与未覆盖项。本次未重新执行组件验收；历史截图及独立对比附件已移除。

### 原记录明确描述的设备范围

- [x] iPhone 16 模拟器运行移动端集成测试并采集水平、竖向和禁用态截图

- [x] Android 16 真机（1220 × 2656）安装并运行最终源码，水平、竖向、禁用态和提交成功集成流程通过

这些是原记录对应候选的操作描述，不外推到其他设备或当前 head。

## 原记录提到的验证入口

- `flutter test test/components/input test/components/textarea test/components/form test/components/upload`
- `flutter analyze`
- `flutter test`
- `dart run tool/generate_example_code.dart --check`
- `flutter build web`
- `flutter build web --no-web-resources-cdn`
- `flutter test test/textarea_page_golden_test.dart`
- `flutter analyze --fatal-infos`
- `flutter test --no-pub test/components/form/t_form_test.dart`
- `flutter test --no-pub --exclude-tags golden test/form_demo_test.dart`
- `flutter test --no-pub test/tool/run_component_regression_test.dart`
- `flutter test test/form_demo_test.dart`
- `flutter analyze --no-pub --fatal-infos`
- `flutter test --coverage ...`
- `dart run tool/check_component_coverage.dart form`

入口仅用于追溯原记录；是否执行、对应环境和结果以原范围为准，不表示本轮重跑。

## 必要证据与追溯

原记录未给出可独立访问且绑定唯一候选的原始日志入口；保留的基线标识不能代替缺失证据。后续验证在此追加与最终方案相关的结论及必要链接，不重复保存每次运行流水。

明确待办统一见 [tasks.md](./tasks.md)。没有新证据时不变更完成状态；已有日期与 SHA 只描述原记录覆盖范围。
