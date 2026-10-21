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

## 共享 Theme 场景补充验收（2026-10-21，提交前本地验证）

PR #1181 的 28b0cf01 在远端共享 Theme 场景 `custom content retains its theme beside TD visuals` 中出现 6253px / 1.96% 差异：自定义内容里未配置样式的 TText 接收了 Dialog 正文默认，字号/行高由 14/22 变为 16/24，颜色由主文字色变为次文字色。此前仅执行 Dialog 所属视觉入口，未覆盖这一共享消费者；前文结论仅限原记录范围。

本轮仅修复测试场景。进入 Dialog 前捕获调用方 TD 文字默认，在内容内部通过显式局部 TTextThemeData 恢复；保留 Material 与图标主题。功能与 Golden 共用 `test/helpers/custom_content_theme_scene.dart`，避免两份场景漂移。原登记的 `t_strict_material_boundary_test.dart` 新增功能断言，同时验证 M2/M3 下 TD 字体、行高、颜色与自定义 Material 文字/图标主题，不需新增调度入口。不修改 Dialog 或全局 TText 生产代码。

| 本地检查 | Flutter 3.32.0 | Flutter 3.47.7 |
| --- | --- | --- |
| 聚焦新增回归 | 1项通过 | 1项通过 |
| 严格 analyze --fatal-infos | 零诊断 | 零诊断 |
| 完整登记 Theme 功能回归 | 184项通过 | 184项通过 |
| Theme 生产行覆盖率 | 841/868，96.89% | 838/868，96.54% |
| Dialog + TText契约 + 调度 | 94项通过 | 94项通过 |
| Theme Demo非视觉 | 14项通过 | 14项通过 |

功能稳定后，在既有 Linux Flutter 3.32.0 镜像、相同字体与依赖下执行完整 Theme Component 27项、Theme Demo 22项测试（含功能/结构与像素检查，非PNG数量），全部通过，`m3_custom_content.png`精确匹配原基线。未使用更新参数。

反向验证：在临时3.32.0副本移除局部主题，新功能断言按预期失败（期望14，实际16），随后已恢复副本。既有PNG哈希核对无变更；以上为提交前本地验证证据；后续按用户授权推送至 #1181，不能推定新提交的远端CI已经通过。完整命令、退出码、耗时和源码指纹在本地 `artifacts/pr1181-local-theme-fix-20261021/`。
