# Theme 验证范围与证据

<a id="source-048"></a>
<a id="source-051"></a>
<a id="source-055"></a>
<a id="source-078"></a>
<a id="source-053"></a>
<a id="source-054"></a>

## 验证范围与本次边界

本次只验证结构、引用、数据格式与工具路径，不重新执行组件、Golden、设备或发布验收。原证据的日期、源码指纹、SDK 与未决状态保持原有范围。

<a id="token-runtime-verification"></a>

## Token 运行验证契约

<a id="source-047"></a>
<a id="source-059"></a>
<a id="source-060"></a>
<a id="source-077"></a>
<a id="source-079"></a>

### 目标与证据边界

补齐 Token 从冻结参考源、全局 Token、组件 Theme、实例覆盖到真实 Widget/布局/绘制的消费证据；默认同值不等于动态回退正确，源码映射或 getter 通过不等于实际渲染正确。

### 行为契约

- 每项区分：默认值已验证、Token/Theme/实例覆盖已验证、实际差异、目标歧义、未实现能力、设计/跨端视觉待验证。发现差异不把当前值写成期望值来消除失败。
- 运行断言检查真实Widget/布局/绘制输入，不能只检查getter、源码文字或行覆盖率。
- 原始小程序声明值与实际消费状态分开；例如Less中的2dp边框须追到实际绘制表达式，不能机械换算。
- 在现有已调度组件测试内扩展有缺口的场景，保持CI配置与调度清单不变。双SDK执行受影响功能检查与严格分析；本机macOS不生成或更新Golden。
- 证据绑定源码指纹、SDK、依赖和可重跑命令。finalPaintVerified只在对应视觉证据充分时更新，不把运行路径通过冒称像素已对齐。

### 证据组织

- `evidence/token-source/`：冻结源声明、Token 对照表与差异清单。
- `evidence/consumption/`：组件消费队列、映射与审查结果。
- `evidence/runtime/`：实际运行观察、源定位与可重跑命令。
- `evidence/differences/`：已发现差异的规则与处置结果，不把旧候选补丁视为已实施。
- `evidence/design/`：组件详情页、设计映射、实际消费及视觉审查依据。
- `evidence/defaults/`：已确认默认值变更及覆盖优先级的验证依据。
- 证据维护边界见 [证据说明](./evidence/README.md)：保留历史快照，不再维护专项生成脚本。

这些文件是有日期、源码指纹和 SDK 边界的证据快照。本次只迁移路径，不重新运行、不刷新哈希或把历史状态改为当前通过；迁移后重新运行的证据应另行绑定新候选。历史 PR 拆分和补丁草案不再作为独立 Spec。

### 验收要求

逐项区分默认值、全局 Token 回退、组件 Theme、实例覆盖、插值、设计差异、未实现能力和缺失证据；保留未决项。功能、Golden、设计和设备分别留证，禁止批量勾选或更改期望值消除差异。

## 运行结果入口

本轮只验证文档收敛、文件引用、数据格式和工具语法；未重新执行组件功能、Golden、设备或远端发布验证，不能据此宣称这些门槛通过。

实际运行观察与待验证项见 [运行报告](./evidence/runtime/runtime-review.md) 和 [差异处置](./evidence/differences/solutions.md)。证据保留原日期、源码指纹与 SDK 边界；路径迁移不刷新验收结论。

## 未完成事项

实现与运行验证待办统一见 [tasks.md](./tasks.md)；不将历史源码指纹或已迁移报告认定为新候选通过。

## 历史验证检查点

以下为已有记录的摘要，本次未重跑，也未重新查询 PR、CI 或合并状态。不同检查点不能拼接为当前候选通过。

| 检查点 / 证据身份 | 已记录范围 | 原始数据与边界 |
| --- | --- | --- |
| 2026-10-17，783aeaab8b6c4b113fdfcda1d508cdda1611d320，相对 3774df7de9647cf261fb0ec63062e0b363b23bcd | 3.32.0 / 3.47.7 各 565 项相关功能、115 项页面检查，四组覆盖率≥95%，严格分析与 API 审计；98 张 Golden 的哈希/差异归因审阅 | [源指纹、命令与结果](./evidence/design/pr-review-results.json)、[Golden 清单](./evidence/design/ci-golden-review.json)。本轮未改基线；未取得的 7 页及 Table 设计绑定不由这些结果补齐 |
| b374adc29503907bd51724c202d14eb3c8b44ab0 恢复检查点 | 原恢复点双 SDK 功能与页面结果 | [结果](./evidence/defaults/results.json)。仅属于恢复点，其旧远端待办不代表当前状态 |
| 后续 nullable 插值复核，源码指纹以数据文件为准 | 17 项新增回归、双 SDK 各 512 项组件 / 157 项页面检查、八组覆盖率>95%；25 组 Linux 3.32 无更新视觉比较 | [复核结果](./evidence/defaults/review-results.json)、[独立 CI 登记复核](./evidence/defaults/ci-registration-results.json)。不外推到随后字体和 Golden 补充 |
| 2026-10-19 字体与默认值 Golden 补充，基于 f5d8df2f2bc43224406319b4944930454458930c，原检查点 ca5c7c61379e9ef850b7cc6866089d4d90468f6b | 原 98 张中 2 张 BackTop 字体基线替换，新增 6 张 Cell/Tabs，共 104 张变更；8 项授权更新后无更新比较通过 | [图片哈希、场景、环境与验证](./evidence/defaults/golden-completion-results.json)。保留 Linux 3.32/DPR1 与字体范围，非 57 页全状态视觉覆盖 |

PR 拆分、重放、分支切换与重复推送记录已移除。影响最终实现的插值原因、配置优先级和视觉取舍并入 [设计说明](./spec.md#关键决策与取舍)。候选发布门槛仍由 [Release](../057-Release-readiness/readiness.md) 维护。

## 文字槽 patch 最终验收（2026-10-22）

本地候选基于 develop e02efbac；范围仅为已有组件文字槽漏接、Drawer 标题段落保留和 Popover 段落测量。Flutter 3.32.0 / 3.47.7 各通过 966 项组件/全局/清单测试、54 项页面测试，10 个相关覆盖率门槛≥95%，严格分析无诊断。Popover 收窄原生字体测量后另复跑两版相关 85 项测试；Linux 3.32 的 50 项 Popover Golden 通过，其他登记视觉套件全部通过。

API 57 份、文档同步 6 份和文档工具 9 项检查通过。相同 Linux 字体环境生成 48 组明暗前后截图，截图与完整日志位于工作区 artifacts/text-slot-patch-minor-split-20261022，不存入 Spec。全局 TText/Resolve/Scope、原生段落 reset/merge 边界、显式文字优先级保持原契约；无既有 Golden PNG 改动。仅本地验证，未推送、不代表远端 CI 已执行。
