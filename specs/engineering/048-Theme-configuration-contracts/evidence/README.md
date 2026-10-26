# Theme 历史证据与维护边界

本目录保留冻结参考、静态审计、实际运行观察和有候选范围的验证结果。数据不代表当前源码或发布候选已通过；未完成事项统一见 [tasks.md](../tasks.md)，结果范围见 [acceptance.md](../acceptance.md)。

## 已退役的专项工具

以下工具服务于已结束的审计批次，没有接入现行 CI，已从维护目录移除：

| 原工具 | 原用途 | 移除原因 |
| --- | --- | --- |
| `audit_miniprogram_tokens.mjs` | 提取小程序全局/组件变量，对照 Flutter 默认值，生成表格 | 依赖外部小程序源码和阶段性映射规则，属于专项数据提取 |
| `audit_component_token_consumption.mjs` | 扫描 Flutter Theme/getter 的静态消费候选 | 目录匹配不证明运行消费，内含历史人工判定和固定行号 |
| `audit_compiled_token_consumption.mjs` | 编译冻结 Less，定位 CSS 变量消费 | 依赖外部源码快照和 Less 环境，只证明该冻结版本的编译引用 |
| `summarize_component_token_evidence.mjs` | 汇总双 SDK 日志、观察值及消费队列 | 固定 46 项聚焦检查及历史批次规则，不能通用验证后续候选 |
| `verify_token_difference_resolutions.mjs` | 复核原 32 项差异、日志和候选补丁 | 固定 47/440/21 项测试数量、历史处置数量、日期及本地补丁，已不适合作为现行门禁 |

历史 JSON 中的工具路径、命令和 SHA 是当次执行的来源元数据，保留原样；这些字段不是当前可运行入口，不改写旧路径或哈希来伪造可复现性。需要追溯脚本时使用对应历史 Git 版本；旧批次的完整外部源码、日志及补丁并不保证仍可获得。

## 后续验证

使用仓库现行的 [组件功能回归](../../../../tdesign-component/tool/run_component_regression.dart) 和 [Golden 回归](../../../../tdesign-component/tool/run_visual_regression.dart)，按已登记范围核对实际组件行为。缺失消费证据须补真实 Widget/布局/绘制断言、设计裁定或设备验证；常规回归通过不自动关闭历史缺口。

新结果记录最终候选、SDK、依赖、命令及适用环境；旧快照不原地覆盖成新候选通过，不再要求重建已退役的专项审计流水。
