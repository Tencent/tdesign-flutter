# Indexes 验证范围与结论

## 本次范围

2026-10-20 原记录整理；未重跑组件、Golden、设备或远端CI。以下结论仅限原候选与范围。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| 既有记录 | 未绑定唯一完整候选 SHA；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |

各标识可能对应不同阶段，不能合成一次完整验证；候选或日志缺失时仍需复核。

## 验证范围与未覆盖项

- CodeBuddy 基于 `db002a3a` 的专项复审未发现阻塞问题，并指出 reverse 定位、动态 indexList 降级、Theme nullable 插值、超大 tipSize 约束和字母代码片段数据说明五项边界。
- 聚焦测试复现 `reverse: true + initialIndex` 的目标内容中心落到视口外（修复前为 -60.5），现改为通过当前 Scrollable 逐步确保近端与未构建远端锚点可见；初始 B、选择 C 和八段内容选择 H 均通过可见区域断言。
- indexList 移除当前活动项时回退新列表首项、同步到最小滚动位置并发送一次 onChanged；initialIndex 继续只在首次创建时校验和生效。
- TIndexesThemeData 的 nullable 插值不再把 null 当作 0 或透明值；tipSize 超过默认 99px 上限时有效 maxWidth 同步扩展，避免无效 BoxConstraints。
- 字母示例生成片段已标明 `_list` 的“索引 -> 城市列表”结构和代表数据；生成器及 `--check` 通过。
- Flutter 3.32.0：Indexes 组件与 sticky-header 共 67 项、Demo 5 项通过；组件与 Example analyze 零诊断；生产代码覆盖率 699/732 = 95.49%。合并 develop 后共享导航 light/dark Golden 已在固定 Flutter 3.32 Linux 容器重建、人工检查，并无更新参数严格复跑 2/2 通过。
- 最新 head 补充 reverse 最近锚点未推进场景：当 `ensureVisible` 尚未构建更近锚点时按一个视口步进，抵达滚动边界仍无进展则结束任务，避免相同参数反复 post-frame 调度；Flutter 3.32.0 聚焦用例与 Indexes + sticky-header 68 项回归通过，相关源码与测试严格 analyze 零诊断。

### 原记录明确描述的设备范围

- 修复后的双版本 Example analyze、Demo 5/5、生成检查、真机 Hot Restart、人工数字/胶囊操作、设备集成 1/1 与普通 APK 重新构建/安装均通过。

这些是原记录对应候选的操作描述，不外推到其他设备或当前 head。

## 必要证据与追溯

未绑定唯一候选的结果不作为当前通过证明；旧命令与流水由Git历史追溯。

当前待办见 [tasks.md](./tasks.md)；实际执行入口见[贡献规范](../../../CONTRIBUTING.md#组件测试与-ci-回归门禁)。清理不关闭未完成项。
