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

- 验证候选：`43bf194d1604b73db774b4308e373c04cc50a7da`。刷新复位后的像素回归测试确认提示内容不再溢出，并验证修复前失败、修复后通过；测试已登记在组件回归清单中。
- macOS Flutter 3.32.0 / 3.47.8：`test/components/refresh/t_refresh_test.dart` 各 37 项通过，静态检查无问题。
- Linux amd64 Flutter 3.32.0：更新三个初始状态 Golden 后，无更新参数复跑 3 项通过，组件测试 37 项通过。基线差异仅为顶部 5 像素内的提示文字残留消失；验证使用缓存依赖，不代表远端 CI 结果。
- 基于 `d47a5433938ec703baa74d66e10c68f47c2666b3` 补充更新自定义提示语与超时场景的明暗 Demo Golden；变化为静止 Header 文字残留消失。Linux amd64 Flutter 3.32.0 更新后无更新参数复跑，Demo Golden 8 项和组件 Golden 3 项通过。
- 真机、同尺寸视觉对照和下拉小偏移的视觉效果未验证；最终候选 CI 以实际运行结果为准。待办见 [tasks.md](./tasks.md)。
