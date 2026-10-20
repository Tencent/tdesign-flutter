# DropdownMenu 验证范围与结论

<a id="record-001-anchored-overlay"></a>
<a id="record-011-official-demos"></a>

## 本次范围

2026-10-20：整理设计背景、决策和验收记录，重点冲突对照公开源码检查；本次未重新执行组件、Golden、设备或远端 CI。以下是原有范围内的证据摘要，不构成当前候选通过声明。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| TDropdownMenu：稳定锚定浮层与菜单切换动画 | `542d1b4c9da7e201ee9a2af35e71f67b4e79983a`；Flutter 3.32.0 | 组件与布局：未提取到可独立确认的通过结论；设备：仅按下文的实际操作与未覆盖范围解释 |
| DropdownMenu Figma、Demo 与组件契约对齐 | `fb26b8d5`、`c5ef738d`；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |

同一原记录可能包含多个复验阶段；上表保留原文可识别的提交、源码/参考源标识与 SDK；这些标识不保证是同一个验证候选，不把它们合成为一次完整矩阵。未提供唯一候选或原始日志绑定的结果，须在实际交付时复核。

## 验证范围与未覆盖项

以下保留各事项原有的文字验收结论与未覆盖项。本次未重新执行组件验收；历史截图及独立对比附件已移除。

- 未新增公共 API；单选值和多选值继续由 `value` / `values` 与回调管理，`controller` 只承担跨树开关命令，避免重复状态源。
- `placement`、overlay 配置、自定义 trigger/panel 仍有独立职责，本次不删除既有公开能力；默认视觉变化不构成公开 API 签名 breaking change。
- 已复现的边界拉伸仿射滤镜与跨 Overlay Follower 几何分离已修复，结果见末节；非仿射 Impeller shader 路径与真机像素表现仍未验证，不能由当前测试推断通过。
- 向上展开、custom trigger、scrollable 与局部 Theme 属于 Flutter 扩展能力，不作为小程序公开矩阵的一对一视觉场景；组件聚焦测试继续覆盖这些路径。

普通滚动及方向翻转的严格断言通过，不等于边界拉伸问题已修复。不能通过加厚接缝、扩大容差，或静默禁用用户页面的拉伸效果来宣称修复。仿射滤镜问题已在第二阶段处理；Impeller shader 路径及真机像素表现仍未验证。

## 原记录提到的验证入口

- `flutter test --no-pub test/components/dropdown_menu --coverage`
- `flutter test --no-pub test/dropdown_menu_page_test.dart`
- `flutter analyze --fatal-infos --no-pub`
- `dart run tool/generate_example_code.dart`
- `flutter test --no-pub test/components/dropdown_menu test/tool/check_component_coverage_test.dart test/tool/run_component_regression_test.dart test/tool/run_visual_regression_test.dart --coverage`
- `dart run tool/check_component_coverage.dart dropdown_menu`
- `flutter analyze --no-pub --fatal-infos`

入口仅用于追溯原记录；是否执行、对应环境和结果以原范围为准，不表示本轮重跑。

## 必要证据与追溯

原记录未给出可独立访问且绑定唯一候选的原始日志入口；保留的基线标识不能代替缺失证据。后续验证在此追加与最终方案相关的结论及必要链接，不重复保存每次运行流水。

明确待办统一见 [tasks.md](./tasks.md)。没有新证据时不变更完成状态；已有日期与 SHA 只描述原记录覆盖范围。
