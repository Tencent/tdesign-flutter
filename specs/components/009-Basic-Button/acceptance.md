# Button 验证范围与结论

<a id="record-009-contract-alignment"></a>
<a id="record-037-disabled-theme-alignment"></a>

## 本次范围

2026-10-20 原记录整理；未重跑组件、Golden、设备或远端CI。以下结论仅限原候选与范围。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| Button 尺寸、形状与原生交互契约对齐 | `24f6fea1`；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围） |
| Button 禁用态与浅色描边对齐 | 未绑定唯一完整候选 SHA；SDK 范围未完整标注 | Demo 与消费：未提取到可独立确认的通过结论；静态检查：有明确通过记录（限原范围） |

各标识可能对应不同阶段，不能合成一次完整验证；候选或日志缺失时仍需复核。

## 验证范围与未覆盖项

以下保留各事项原有的文字验收结论与未覆盖项。本次未重新执行组件验收；历史截图及独立对比附件已移除。

## 必要证据与追溯

未绑定唯一候选的结果不作为当前通过证明；旧命令与流水由Git历史追溯。

当前待办见 [tasks.md](./tasks.md)；实际执行入口见[贡献规范](../../../CONTRIBUTING.md#组件测试与-ci-回归门禁)。清理不关闭未完成项。

<a id="source-082"></a>

## 082 · 原联合验收

以下为#1180原72c0f13d检查点，文中的21文件、分支范围和计数仅指该独立阶段，不表示本次同步后的全分支范围或已经重新验证。


2026-10-21。分支 rss1102/breaking/button-navbar-text-defaults，独立副本 button-navbar-text-slots-clean，从原验证基线 d0de29e8 提取。21个变更文件（含4张PR审查证据图）只涉及两组件实现、原登记测试与两份必要测试辅助、文字dartdoc/生成API、站点主题说明及Spec082；无Spec081、其他组件修复、CI或工具链改动。本段记录发布前完成的本地验证；远端CI结果需以PR当前head为准。

Flutter3.32.0与3.47.7各通过：Button245、NavBar73、Dialog32、DropdownMenu95、Fab72、Upload50，合计567项组件；30项Demo非视觉；34项既有文字契约；17项调度；从[迁移说明](./text-slot-migration.md)直接提取的两段Dart核心片段1项验证（含旧正文外观显式恢复）。严格分析0诊断，57份API检查一致，文档同步6项无陈旧。Button行覆盖99.27%，NavBar100%。

两SDK正式生成button/navbar/text/theme一致，实际变更产物为button_api.md、navbar_api.md、text_api.md；TTextThemeData说明也在text_api.md中。源码注释与站点说明解释正文默认、组件默认、显式覆盖、外层/内层主题及inherit:false例外。

Linux3.32原Button视觉入口10项、NavBar组件2项/Demo14项共26项通过（含结构/交互），无更新参数。1052个已跟踪PNG保持不变。此分支未运行依赖此前Dialog修复的视觉场景，不把混合分支的108项结论移用。

Dart解析器token核对确认：全局TText及TTextThemeData仅有注释变化；Button/NavBar可执行代码与已完成前后截图版本相同。原Scope/Resolve、默认主题、字体及Linux包配置不变，复用此前固定环境截图；没有重新生成或更新图片。52组原生Text/52组完整显式TText像素不变、52组默认TText按预期变化，属于已确认默认行为breaking。兼容性及迁移详见[迁移说明](./text-slot-migration.md)。

完整命令、源码指纹、文件白名单与日志在本地 artifacts/button-navbar-clean-split-20261021/REPORT.md、boundary.json、token-comparison.json、source-hashes.json。双版本验证入口 validate.py / validate-consumers.py / verify-migration.py；API正式入口tool/generate_api.mjs；文档入口scripts/sync-readme.mjs --check；Linux入口run-linux.py。不将本地证据视为远端CI或设备验证。

## PR 审查截图

以下为同一 Linux Flutter3.32.0 固定环境的原始单元格截图，左侧前后顺序由表头标识；不是Golden基线，不参与比较器或更新。完整渲染对比沿用上述已核对证据。

| 场景 | 修改前 | 修改后 |
| --- | --- | --- |
| 中号primary按钮 | ![修改前](evidence/text-slots/button-before.png) | ![修改后](evidence/text-slots/button-after.png) |
| 配置紫色标题的NavBar | ![修改前](../031-Navigation-NavBar/evidence/text-slots/navbar-before.png) | ![修改后](../031-Navigation-NavBar/evidence/text-slots/navbar-after.png) |

本次发布只新增这四张审查证据图，不修改任何已有Golden。按钮14/22、w400主文字色变为16/24、w600白色；导航标题14/22、w400变为18/26、w600并接受场景配置的紫色。无样式文字的宽度/省略位置也可能变化；显式样式优先和全局隔离保持。


## 同步 develop 后的验证（2026-10-21）

合并 develop `fc099299c1ae11a56b204d260016580862d00e93`（含 #1178 Spec 归并和 #1181 Dialog 修复），无文本冲突。将082契约、计划、任务及证据归入 Button/NavBar 主 Spec；四张审查图片字节不变。相对 develop 的生产代码仍仅为原 Button/NavBar 增量及 TText/主题注释，全局隔离不变。

独立副本 Flutter3.32.0 / 3.47.7 各通过：严格分析；577项组件（Button245、NavBar73、Dialog42、DropdownMenu95、Fab72、Upload50）；64项文字/主题/调度检查；39项 Demo 非视觉；1项迁移示例验证。两版本 Button 覆盖547/551=99.27%，NavBar160/160=100%，六组件覆盖率门槛均通过。57份 API、6份文档同步检查一致；文档测试9项通过。

Linux Flutter3.32.0 通过共享 Theme/NavBar 29项、Dialog Popup 1项、Button/NavBar/Dialog Demo 71项，共101项（含结构/交互）。未更新任何 Golden 基线。435份 lib/test/tool Dart 源文件指纹与三个验证副本一致。日志与指纹保存在本地 artifacts/pr1180-merge-develop-20261021/；仅代表上述本地范围，远端 CI 需检查推送后的当前 head，不代表设备或平台构建验证。
