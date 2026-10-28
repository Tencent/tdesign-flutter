# PullDownRefresh 验证范围与结论

## 本次范围

2026-10-20 原记录整理；未重跑组件、Golden、设备或远端CI。以下结论仅限原候选与范围。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| 既有记录 | 未绑定唯一完整候选 SHA；Flutter 3.32.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |

各标识可能对应不同阶段，不能合成一次完整验证；候选或日志缺失时仍需复核。

## 验证范围与未覆盖项

- `TPullDownRefresh` 默认渲染对齐官方（loadingBarHeight=50 / maxBarHeight=80 / 触发阈值=50）
- 下拉 → 松手 → 刷新 → 完成四态文案正确（中文默认与官方一致）
- 下拉过程中刷新头与页面内容同步下移，释放后回弹
- 外部 `controller.refresh()`、`onStateChanged` 生效；`await controller.refresh()` 在成功、失败或超时后完成，不代表业务一定成功
- `refreshTimeout` 默认 3000ms，超时通过 `onStateChanged(timeout)` 上报；传入 null 关闭超时
- `onLoadMore` 非空时按 `lowerThreshold` 自动启用触底加载，且不渲染额外 Footer UI
- `onRefresh == null` 时禁用下拉刷新并保留滚动
- 暗色刷新文案默认使用 `textDisabledColor`，显式
  `TLoadingThemeData.textColor` 可覆盖；独立 `TLoading` 默认值不变

## 必要证据与追溯

未绑定唯一候选的结果不作为当前通过证明；旧命令与流水由Git历史追溯。

当前待办见 [tasks.md](./tasks.md)；实际执行入口见[贡献规范](../../../CONTRIBUTING.md#组件测试与-ci-回归门禁)。清理不关闭未完成项。

## 1.0.1 controller-binding 验收

- 保留 bind/unbind 签名和后绑定覆盖规则；旧组件卸载或更换 Controller 不清除新组件的刷新入口。
- 本组公开 API 签名及默认值未变，不包含 API 别名或废弃迁移。
- 原独立候选 `58cb2736`：Flutter 3.32.0 / 3.47.7 的本组件生产覆盖率均为 215/224 = 95.98%；原始结果见[验证数据](../001-Feedback-DropdownMenu/evidence/1.0.1-independent.json)。
- 整组验证环境、命令、指纹及本次补充回归结果统一记录在 [DropdownMenu 验收记录](../001-Feedback-DropdownMenu/acceptance.md#controller-binding-validation)，不以原候选结果替代新候选验证。

中文 API 注释及生成文档已补充推荐用法与原有绑定规则；本轮文档、字体覆盖及静态分析结果见[整组验收](../001-Feedback-DropdownMenu/acceptance.md#controller-api-doc-validation)，不改变实现或既有绑定限制。

## Header 静止态绘制回归

- 本地候选以 PR #1209 的 `4fc609f3c1d4138f70722c401c58b9f7499fea8e` 为基础，生产文件 SHA-256 为 `06d4ab3bd1e15e14934cf6547cb722cb6f6d79060920e1a08d2daabf77f31d04`，测试文件 SHA-256 为 `99fb2d71728e64dd11b8f365347f1b4f09b4814bc940a4d43c9ae3efc2f52b96`。
- macOS 本地 Flutter 3.32.0 和 3.47.8：分别离线解析依赖，执行 `flutter test --no-pub test/components/refresh/t_refresh_test.dart`，各 37 项通过；`flutter analyze --no-pub --fatal-infos` 均无问题。测试对比刷新前与复位后的像素，并确认 Header 高度为零；同文件的既有测试覆盖下拉、刷新及样式。
- Flutter 3.32.0 下临时使用 PR 父提交的生产文件时，该像素断言失败；恢复 PR 实现后通过。测试文件已在 `tool/component_test_manifest.dart` 登记。
- 未执行真实设备、同尺寸视觉对照或最终候选远端 CI；未单独验证下拉小偏移的视觉效果，相关待办见 [tasks.md](./tasks.md)。
- Linux amd64 Flutter 3.32.0 容器使用离线缓存依赖，对当前候选运行 `flutter test --no-pub test/components/refresh/t_refresh_golden_test.dart`：三张既有基线分别有 101、162、101 个像素差异，均位于顶部 5 像素。相同容器与依赖中，仅还原 PR 父提交的生产文件后 3 项通过，表明差异由此修复引入。更新三张基线后，在同一环境不带更新参数复跑 Golden，3 项通过；组件测试 37 项通过。图片变更仍仅涉及上述顶部区域的透明度。容器离线解析使用了缓存的工具依赖版本，非远端 CI 结果。
