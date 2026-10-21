# Calendar 验证范围与结论

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
