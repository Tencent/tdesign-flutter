> 2026-10-15 发布前核销：当前自动检查与历史阶段记录分开；证据和保留待办见 [Spec 057](../057-release-readiness-audit/acceptance.md)。

# 任务清单

- [x] 完成新版 Figma / 小程序 develop / Flutter 三方差异输出
- [x] 收敛组件公开契约与 Theme 所有权
- [x] 移除 `TSideBarItem` 无效 `key` 参数，保留 Widget Key 并记录 breaking 迁移
- [x] 收敛公开 Demo 与代码片段
- [x] 完成组件、Demo、覆盖率和严格 light/dark Golden
- [x] 完成 Flutter 3.32.0 / latest analyze 与构建
- [x] 完成 Android 真机热重启、操作、集成测试与持久安装
- [x] GitHub #1083/#1135 已合入，#1027 正文已有 SideBar 条目，见 Spec 057。
- [ ] 核对对应 CNB PR 的处理记录；本轮未取得 CNB 证据。
- [ ] 完成 CodeBuddy Review 并处理反馈
- [x] 修复 nullable Theme 字段在动画中间态制造临时显式样式，并补齐中间态回归测试
- [x] 明确并验证 `TSideBarItem.badge.child` 必须为空的契约
