# Calendar 验证范围与结论

## 日历示例弹层生命周期（PR #1227）

- 弹层打开后卸载翻页示例，再重建弹层并确认，应安全关闭且不调用已卸载页面的状态更新。反向验证中，develop 的标题重建触发已卸载 context 异常，原 PR 的确认操作触发 `setState() called after dispose()`；本地候选两步均通过。
- 其余七个弹层示例分别反向复现卸载后标题重建及确认失败；本地候选保留页面存活时的确认行为，并在卸载后安全关闭弹层。
- Flutter 3.32.0、3.47.8 的 Calendar Demo 功能测试各 24 项通过，包含翻页示例正常选择并确认后提交日期；Example 严格静态分析、示例片段一致性及共享字体覆盖检查通过。截图记录单选示例在相同卸载与重建步骤下的真实测试渲染。
- Flutter 3.47.8 独立演示使用当前本地代码，在 Android 真机及桌面 Chrome 网页分别操作单选和翻页示例：选择日期并确认后页面更新；打开弹层后卸载示例，确认可关闭弹层。浏览器在卸载后改变窗口大小，弹层仍可显示并关闭。其余六个示例只进行自动化 Widget 验证；未覆盖 iOS 或其他浏览器，最终远端 CI 尚未覆盖本地候选。

## 本次范围

2026-10-20 原记录整理；未重跑组件、Golden、设备或远端CI。以下结论仅限原候选与范围。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| 既有记录 | `35b20b99`；Flutter 3.32.0 / 3.47.0 / 3.44.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |

各标识可能对应不同阶段，不能合成一次完整验证；候选或日志缺失时仍需复核。

## 验证范围与未覆盖项

- 按 componentTestSuites 当前登记逐文件运行 flutter test --no-pub --coverage，再执行 dart run tool/check_component_coverage.dart calendar。工具自测单独统计，不混入组件数。
- 运行真实 Demo 功能测试和 run_visual_regression.dart 登记的 Golden；没有更新图片。Android/iOS 真机尚未验证。
- 日期格快照更新回归验证旧快照不变、新内容与区间连接重建。公开 notifier 删除为 breaking；构造迁移见 plan.md，builder 读取 selectType 保持。

## 必要证据与追溯

未绑定唯一候选的结果不作为当前通过证明；旧命令与流水由Git历史追溯。

当前待办见 [tasks.md](./tasks.md)；实际执行入口见[贡献规范](../../../CONTRIBUTING.md#组件测试与-ci-回归门禁)。清理不关闭未完成项。

原始 [Figma 设计参考](evidence/figma-calendar-demo-top.png)作为独有设计依据保留；运行截图不重复归档。视觉回归引用 [Calendar Golden](../../../tdesign-component/example/test/calendar/calendar_demo_golden_test.dart)及其基线，历史结果不作为本次执行证明。
