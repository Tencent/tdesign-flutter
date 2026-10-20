# NoticeBar 验证范围与结论

## 本次范围

2026-10-20：整理设计背景、决策和验收记录，重点冲突对照公开源码检查；本次未重新执行组件、Golden、设备或远端 CI。以下是原有范围内的证据摘要，不构成当前候选通过声明。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| 既有记录 | 未绑定唯一完整候选 SHA；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |

同一原记录可能包含多个复验阶段；上表保留原文可识别的提交、源码/参考源标识与 SDK；这些标识不保证是同一个验证候选，不把它们合成为一次完整矩阵。未提供唯一候选或原始日志绑定的结果，须在实际交付时复核。

## 验证范围与未覆盖项

- 水平滚动的真实帧级平滑度（依赖运行态视觉验证）。
- 真实设备上的垂直触摸、循环与 change 回调仍属于待确认/待实现契约。
- operation 自定义子组件同时处理自身点击与 NoticeBar 统一点击目标时的手势竞争仍需真机验证。
- 逐帧叠图与真实设备触摸循环仍未验证。

## 原记录提到的验证入口

- `flutter analyze lib/src/components/notice_bar/t_notice_bar.dart`
- `flutter analyze test/components/notice_bar/t_notice_bar_test.dart`
- `flutter test --no-pub test/components/notice_bar/t_notice_bar_test.dart --coverage`
- `flutter test --no-pub test/notice_bar_page_test.dart`
- `flutter analyze --fatal-infos --no-pub`
- `flutter test --no-pub test/components/notice_bar/t_notice_bar_test.dart`
- `dart analyze --fatal-infos`
- `dart run tool/generate_example_code.dart`
- `flutter test --no-pub test/notice_bar_page_golden_test.dart`
- `flutter analyze`

入口仅用于追溯原记录；是否执行、对应环境和结果以原范围为准，不表示本轮重跑。

## 必要证据与追溯

原记录未给出可独立访问且绑定唯一候选的原始日志入口；保留的基线标识不能代替缺失证据。后续验证在此追加与最终方案相关的结论及必要链接，不重复保存每次运行流水。

明确待办统一见 [tasks.md](./tasks.md)。没有新证据时不变更完成状态；已有日期与 SHA 只描述原记录覆盖范围。
