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

## 相同内容附件合并

下列历史输出经逐字节比对完全相同，各组只保留一份共享数据。不同 SDK、批次的候选、命令、环境和执行结果仍由对应 acceptance、指纹与矩阵记录；共享 payload 不合并执行身份，也不新增任何通过结论。冻结 JSON 中的原输出文件名仍是当时的来源元数据，可用下表找到同内容附件。

| 保留数据 | 原输出名 | SHA-256 |
| --- | --- | --- |
| [three-results.json](design/three-results.json) | `three-results-3.32.0.json`、`three-results-3.47.7.json` | `d1d8fb1be49e386ba18fea80be6af7987a80feee33bcea7fe6f21a06c761b396` |
| [radius-results.json](design/radius-results.json) | `radius-results-3.32.0.json`、`radius-results-3.47.7.json` | `818603a758c89963feae9085592fa14007d082cf904423cc2b73b659f6e6564a` |
| [fixed-component-token-results.json](design/fixed-component-token-results.json) | `fixed-results-3.32.0.json`、`fixed-results-3.47.7.json`、`component-token-results-3.32.0.json`、`component-token-results-3.47.7.json` | `1a616429c9abb84afe93f758472b82fa4c92bde0371c496ae3e2a0cd2929e9bd` |
| [baseline-results.json](design/baseline-results.json) | `results-3.32.0.json`、`results-3.47.7.json` | `48e6dc0feafde7b4d8a81f45ff48569adde0f8287978103a78e9a1d55df7664e` |
| [three-coverage.txt](design/three-coverage.txt) | `three-coverage-3.32.0.txt`、`three-coverage-3.47.7.txt` | `4c9b877b9c51d49249aa8788332387ad53dcbeb942e4f5dd40ab3851507206ad` |
| [design-results.json](design/design-results.json) | `design-results-3.32.0.json`、`design-results-3.47.7.json` | `a4c0d3ea254b9fe8b315983e43f8a4a30acf52c6c39838bf2a7dfdfe49eb7fe3` |
