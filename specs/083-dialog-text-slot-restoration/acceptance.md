# 独立分支验收

2026-10-21。分支 rss1102/fix/dialog-text-slots，基线d0de29e8；不含另一分支、Button/NavBar、ActionSheet、CI优化或工具链升级。以下为提交前独立副本的本地验证记录；后续按用户授权独立发布，远端状态以PR页面为准。

## 双版本非视觉检查

Flutter3.32.0/3.47.7各通过 42 项登记组件/工具归属测试、16 项Demo非视觉、18 项调度、34 项既有文字契约；严格analyze --fatal-infos零诊断，57份API与6份文档一致。

| 组件覆盖率 | 3.32.0 | 3.47.7 |
| --- | --- | --- |
| dialog | 98.68% | 98.68% |

## 视觉与边界

纯分支Linux Flutter3.32.0所属视觉入口 48 项通过（含结构/交互，不等于相同数量PNG）；共享PopupProgress入口去重。未使用更新参数，1052张既有PNG未变。
Dialog旧Popup图差4.00%/9996px，修复后恢复原基线；Demo前后均通过，详见baseline-matrix.md。

全局TText/Resolve/Scope、原生工具链和工作流未改。源代码与测试由纯分支重新执行，没有移用另一分支通过结论。未验证远端CI、全57组件、设备前台或APK/Web/iOS。

## 执行入口

本地 artifacts/text-slot-split-matrix-20261021/validate-split.py 调用严格分析、登记组件flutter test --coverage、check_component_coverage、Demo --exclude-tags golden、调度/文字契约及正式API --check；run-split-goldens.py执行纯分支原视觉入口。具体命令/退出码/耗时在该目录按版本的results.json和split-linux-results.json，矩阵见split-matrix.md。
