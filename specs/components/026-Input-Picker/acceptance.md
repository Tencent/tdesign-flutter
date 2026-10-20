# Picker 验证范围与结论

<a id="record-026-demo-alignment"></a>
<a id="record-043-popup-layout"></a>

## 本次范围

2026-10-20：整理设计背景、决策和验收记录，重点冲突对照公开源码检查；本次未重新执行组件、Golden、设备或远端 CI。以下是原有范围内的证据摘要，不构成当前候选通过声明。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| Picker 平铺滚轮与 Figma Demo 对齐 | `e06b247d`、`5d75a033d`；Flutter 3.32.0 / 3.47.0 / 3.44.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |
| Picker 弹层布局契约 | 未绑定唯一完整候选 SHA；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：未提取到可独立确认的通过结论；Golden：有明确通过记录（限原范围） |

同一原记录可能包含多个复验阶段；上表保留原文可识别的提交、源码/参考源标识与 SDK；这些标识不保证是同一个验证候选，不把它们合成为一次完整矩阵。未提供唯一候选或原始日志绑定的结果，须在实际交付时复核。

## 验证范围与未覆盖项

以下保留各事项原有的文字验收结论与未覆盖项。本次未重新执行组件验收；历史截图及独立对比附件已移除。

- 按 componentTestSuites 当前登记逐文件运行 flutter test --no-pub --coverage，再执行 dart run tool/check_component_coverage.dart picker。工具自测单独统计，不混入组件数。
- 运行真实 Demo 功能测试和 run_visual_regression.dart 登记的 Golden；没有更新图片。Android/iOS 真机尚未验证。
- 修复前真实消费测试在自定义 fontBodyLarge=19/27 时读到 Material 默认字号而失败，修复后两消费组件的 token 与显式子树 TextTheme 均通过。共享源码及测试在两个 PR 中相同。

- 四个代码入口通过现有 methodName 展示实际 `_cell` 核心组合，包含 Cell 触发、标签解析、Popup/Header、Picker 草稿、取消/确认。片段注明参数、初始值和父级接入；它是核心片段，不是独立应用，不提供外部源码地址指引。
- 新增代码面板 Widget 回归，实际打开四个入口读取渲染的 Markdown；沿用 picker_demo_test.dart 在 GitHub/CNB 的双版本登记。Flutter 3.32.0 与 3.47.0 各 10 项 Demo 回归通过，严格 analyze --fatal-infos 无诊断；生成器及 --check 通过。未改组件生产源码或公开 API，本轮无新增 breaking change。
- 抽取时曾因 builder context 与 State.context 的主题层级差异造成标题文字 Golden 差异，已恢复原 State.context。Flutter 3.32.0 Linux 最终 10 项 Demo + 14 项 Golden 测试通过，18 张基线精确比较，差异 0，未更新基线或容差。
- Android 16 真机运行当前应用及集成测试通过：五个示例逐一滚动、取消、重开恢复、确认、重开保留；四个代码面板显示核心组合，实际向下滚动可看到 Popup 与确认逻辑；深色地区弹层亦检查滚轮高 200，浅色五个示例检查默认项高 40。浅/深色截图人工检查无高亮错位、黄色下划线或缺字；不等同于与 Figma 逐像素一致，也不是人工手指拖动的性能测量。
- 真机复跑：在 tdesign-component/example 执行 `flutter drive --driver=test_driver/picker_example.dart --target=integration_test/picker_example_test.dart -d <device-id>`。需要连接已授权设备；integration_test 来自 Flutter SDK，仅为开发依赖。截图写入 `build/picker-device-evidence/`，driver 返回 true 仅表示截图已保存，不代表自动视觉通过。手机测试恢复原主题设置。
- 真机截图：picker-page.png、picker-area.png、picker-area-dark.png、picker-code.png、picker-code-composition.png（以上输出目录）。以上为本地验证结果，远端 CI 状态须在推送后独立确认。

## 原记录提到的验证入口

- `flutter analyze --fatal-infos --fatal-warnings`
- `flutter drive --driver=test_driver/picker_example.dart --target=integration_test/picker_example_test.dart -d <device-id>`
- `flutter test test/components/picker`
- `dart analyze --fatal-infos`
- `flutter analyze --fatal-infos`
- `dart run tool/generate_example_code.dart --check`

入口仅用于追溯原记录；是否执行、对应环境和结果以原范围为准，不表示本轮重跑。

## 必要证据与追溯

原记录未给出可独立访问且绑定唯一候选的原始日志入口；保留的基线标识不能代替缺失证据。后续验证在此追加与最终方案相关的结论及必要链接，不重复保存每次运行流水。

明确待办统一见 [tasks.md](./tasks.md)。没有新证据时不变更完成状态；已有日期与 SHA 只描述原记录覆盖范围。
