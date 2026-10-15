> 2026-10-15 发布前核销：当前自动检查与历史阶段记录分开；证据和保留待办见 [Spec 057](../057-release-readiness-audit/acceptance.md)。

# 实施任务

- [x] DONE 冻结新版 Figma H5/Flutter、小程序 develop 与当前 Flutter 差异
- [x] DONE 明确默认返回、高度、边框模式、Theme 和安全区所有权
- [x] DONE 收敛 TNavBar 与 TNavBarThemeData 公开契约
- [x] DONE 按 Figma H5/Flutter 画板调整公开 Demo
- [x] DONE 更新组件与 Demo 行为测试
- [x] DONE 建立并人工核对组件、Demo、共享导航 light/dark 严格 Golden
- [x] DONE 执行双 SDK analyze、覆盖率、生成检查和构建
- [x] DONE 最终代码 Android 真机 Hot Restart、可见操作与普通 APK 持久安装
- [x] DONE 修复 TNavBarThemeData 类型安全与连续视觉字段插值
- [x] DONE 补齐 dartdoc、站点文档及可独立理解的 Demo 代码片段
- [x] GitHub #1082/#1136 已合入，#1027 正文已有 NavBar 条目；当前基线 CI 通过，见 Spec 057。
- [ ] 核对 CNB PR 与 CodeBuddy Review 的处理记录；本轮未取得 CNB 证据。
