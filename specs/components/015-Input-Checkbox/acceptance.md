# Checkbox 验证范围与结论

<a id="record-015-demo-card-alignment"></a>
<a id="record-016-theme-token-sizes"></a>
<a id="record-041-design-details"></a>

## 本次范围

2026-10-20：整理设计背景、决策和验收记录，重点冲突对照公开源码检查；本次未重新执行组件、Golden、设备或远端 CI。以下是原有范围内的证据摘要，不构成当前候选通过声明。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| Checkbox Demo 与卡片角标对齐 | 未绑定唯一完整候选 SHA；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |
| Checkbox 样式尺寸 token 化 | `fab17971`；Flutter 3.32.0 / 3.47.0 | Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围） |
| Checkbox 设计细节对齐 | `bd3574220`；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：未提取到可独立确认的通过结论；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |

同一原记录可能包含多个复验阶段；上表保留原文可识别的提交、源码/参考源标识与 SDK；这些标识不保证是同一个验证候选，不把它们合成为一次完整矩阵。未提供唯一候选或原始日志绑定的结果，须在实际交付时复核。

## 验证范围与未覆盖项

以下保留各事项原有的文字验收结论与未覆盖项。本次未重新执行组件验收；历史截图及独立对比附件已移除。

### 原记录明确描述的设备范围

> 二次修复已基于官方站内小程序实际运行画面完成；Android 真机最终截图因设备进入 Dozing 且禁止 ADB 注入唤醒事件而待补。

- Android 16 二次修复安装成功，但设备随后进入 Dozing，ADB 无 `INJECT_EVENTS` 权限无法唤醒；本次黑屏图不作为验收证据。

这些是原记录对应候选的操作描述，不外推到其他设备或当前 head。

## 原记录提到的验证入口

- `flutter test test/components/checkbox/t_check_box_group_test.dart test/components/checkbox/t_checkbox_test.dart`
- `flutter test test/checkbox_page_test.dart`
- `flutter analyze`
- `dart run tool/generate_example_code.dart --check`
- `flutter test --no-pub --exclude-tags demo test/components/checkbox/t_check_box_group_test.dart test/components/checkbox/t_checkbox_test.dart`
- `dart run tool/check_component_coverage.dart checkbox`
- `flutter test --no-pub --exclude-tags golden test/checkbox_page_test.dart`
- `flutter build apk --debug`

入口仅用于追溯原记录；是否执行、对应环境和结果以原范围为准，不表示本轮重跑。

## 必要证据与追溯

原记录未给出可独立访问且绑定唯一候选的原始日志入口；保留的基线标识不能代替缺失证据。后续验证在此追加与最终方案相关的结论及必要链接，不重复保存每次运行流水。

明确待办统一见 [tasks.md](./tasks.md)。没有新证据时不变更完成状态；已有日期与 SHA 只描述原记录覆盖范围。
