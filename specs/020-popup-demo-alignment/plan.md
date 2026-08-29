# Popup 公开 Demo 对齐 - 实施方案

## 技术方案

- 用两个 `ExampleItem` 表达小程序公开页的两个 Demo 块，每个块内部组合对应按钮。
- 通过现有 `TPopupOptions` 的 `headerBuilder: null`、`closeBuilder: null`、尺寸参数和 Widget 组合表达目标，不扩大公共 API。
- 删除公开嵌套入口及其生成片段，嵌套能力继续由组件测试覆盖。
- 拆分 `popup_demo_test.dart` 与 `popup_demo_golden_test.dart`，分别进入双版本功能测试和固定 Linux 视觉回归。
- 在组件回归、覆盖率目标和视觉回归注册表中登记 Popup。
- 将 `TPopupOptions` 及五个命名工厂的 `useSafeArea` 默认值统一改为 `false`，保留显式 `true` 的原有能力；调用方需要仅约束内容时组合 Flutter 原生 `SafeArea`。

## 影响范围

- Popup Example 页面与生成代码片段。
- Popup Demo 功能测试、Golden 及 CI 调度注册表。
- 不新增或删除 Popup 公开 API；调整 `useSafeArea` 默认行为并同步 dartdoc、Spec 与回归测试。

## 风险

- Golden 只允许由 Flutter 3.32.0 Linux 生成；其他平台仅运行非视觉断言。
- 页面结构对齐不等于所有平台像素完全一致，字体与系统渲染差异仍需真机抽查。
- 默认关闭安全区属于 breaking change；依赖旧默认值的调用方须显式传入 `useSafeArea: true`。

## 验证策略

- 双版本执行 Popup 组件测试、Demo 功能测试与严格 analyze。
- Flutter 3.32.0 Linux 生成并复跑明暗主题完整页面 Golden，以及顶部、左侧、居中、底部、右侧五个基础方向的展开态 Golden。
- 按 `lib/src/components/popup/` 过滤 LCOV，要求 LH/LF 不低于 95%。
- 运行生成器 check、调度器自测和 `git diff --check`。
