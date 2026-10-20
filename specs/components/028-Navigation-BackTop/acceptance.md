# BackTop 验证范围与结论

## 本次范围

2026-10-20：整理设计背景、决策和验收记录，重点冲突对照公开源码检查；本次未重新执行组件、Golden、设备或远端 CI。以下是原有范围内的证据摘要，不构成当前候选通过声明。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| 既有记录 | `f3e14c43`；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |

同一原记录可能包含多个复验阶段；上表保留原文可识别的提交、源码/参考源标识与 SDK；这些标识不保证是同一个验证候选，不把它们合成为一次完整矩阵。未提供唯一候选或原始日志绑定的结果，须在实际交付时复核。

## 验证范围与未覆盖项

- 浏览器连接器的安全策略拒绝访问本机 `127.0.0.1` Demo，因此没有把 Web
  实际浏览器点击冒充为已完成；Web release 构建、真实 Widget 滚动交互和 Linux
  Golden 已通过。
- iOS 真机未验证；移动端操作验收以 Xiaomi Android 16 设备 `40302eeb` 为准。
- Figma 只提供浅色移动端画板，Flutter 深色主题是基于语义 Token 的扩展；系统状态栏也不在 Flutter Golden 边界内。两项差异均已在 `visual-comparison.md` 明示，并须由真机截图补证。
- GitHub PR #1079 在完整验收前已创建；本记录明确纠正交付顺序。最终真机、双 SDK、覆盖率与生成检查现已完成，仍须更新该 PR，并在 CNB 独立创建 PR、完成 CodeBuddy Review 后才可签收。

## 原记录提到的验证入口

- `flutter test ...backtop... --no-pub --coverage`
- `flutter test test/backtop_demo_test.dart test/backtop_demo_golden_test.dart --no-pub`
- `flutter test ...backtop... --no-pub --exclude-tags golden`
- `flutter analyze`
- `dart run tool/generate_example_code.dart --check`
- `sh ./demo_tool/all_build.sh`
- `flutter build web --release`
- `flutter test integration_test/backtop_example_test.dart -d 40302eeb`

入口仅用于追溯原记录；是否执行、对应环境和结果以原范围为准，不表示本轮重跑。

## 必要证据与追溯

原记录未给出可独立访问且绑定唯一候选的原始日志入口；保留的基线标识不能代替缺失证据。后续验证在此追加与最终方案相关的结论及必要链接，不重复保存每次运行流水。

明确待办统一见 [tasks.md](./tasks.md)。没有新证据时不变更完成状态；已有日期与 SHA 只描述原记录覆盖范围。
