# 独立分支验收

2026-10-21。分支 rss1102/fix/component-text-slots，基线d0de29e8；不含另一分支、Button/NavBar、ActionSheet、CI优化或工具链升级。以下为提交前独立副本的本地验证记录；后续按用户授权独立发布，远端状态以PR页面为准。

## 双版本非视觉检查

Flutter3.32.0/3.47.7各通过 778 项登记组件/工具归属测试、55 项Demo非视觉、17 项调度、34 项既有文字契约；严格analyze --fatal-infos零诊断，57份API与6份文档一致。

| 组件覆盖率 | 3.32.0 | 3.47.7 |
| --- | --- | --- |
| avatar | 98.63% | 98.63% |
| progress | 98.63% | 98.63% |
| calendar | 98.69% | 98.69% |
| popover | 98.14% | 98.14% |
| collapse | 96.51% | 96.51% |
| divider | 100.0% | 100.0% |
| drawer | 95.76% | 95.41% |
| link | 98.28% | 98.28% |
| popup | 97.38% | 96.45% |
| table | 99.56% | 99.56% |

内部TToolbarPressable单文件25/26=96.15%（双版本），也已纳入Popup生产coverageTargets；不是只看其他Popup代码的汇总。

## 视觉与边界

纯分支Linux Flutter3.32.0所属视觉入口 148 项通过（含结构/交互，不等于相同数量PNG）；共享PopupProgress入口去重。未使用更新参数，1052张既有PNG未变。
本分支所列既有视觉入口修复前后均匹配原基线；无样式TText、局部主题和段落场景仍可能改变外观，不能把PNG未变视为零兼容风险。内部工具没有独立Golden，功能证据与消费者视觉证据分开。

全局TText/Resolve/Scope、原生工具链和工作流未改。源代码与测试由纯分支重新执行，没有移用另一分支通过结论。未验证远端CI、全57组件、设备前台或APK/Web/iOS。

## 执行入口

本地 artifacts/text-slot-split-matrix-20261021/validate-split.py 调用严格分析、登记组件flutter test --coverage、check_component_coverage、Demo --exclude-tags golden、调度/文字契约及正式API --check；run-split-goldens.py执行纯分支原视觉入口。具体命令/退出码/耗时在该目录按版本的results.json和split-linux-results.json，矩阵见split-matrix.md。
