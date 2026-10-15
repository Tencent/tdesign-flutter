> 阶段边界：本页记录上一轮只做审查和 Spec 清理的结果。维护者随后授权实施第1～4项；当前改动及验证见 [Spec 058](../058-release-preparation/acceptance.md)。CI修改继续排除。

# 2026-10-15 核销证据

## 固定基线

- 仓库：Tencent/tdesign-flutter，develop@30767a5521e871b1738040f854adf001e50e4774；本轮 API / 组件 / 依赖 / CI 均未修改。
- [原始开放任务](baseline-open-tasks.json)：87 份 tasks.md（排除模板），32 个目录包含 57 条开放任务。清单保存原始文本与行号，不等同于缺陷数量。
- 当前 [test-build run 38611030128](https://github.com/Tencent/tdesign-flutter/actions/runs/38611030128) 的 11 个 job 全部 success；逐 step 读取确认关键检查实际执行，非仅依赖 workflow 文字。
- 3.32.0 test job 116014097130 的日志包含 `All component regression suites passed.`，独立 consumer 的 pub get / analyze / test 均成功。登记工具与共享 Demo 功能步骤均成功。
- visual job 116014096966 日志确认 Linux Flutter 3.32.0、`All visual regression suites passed.`；未使用更新参数。通过范围严格限定为 visual manifest 实际调度的场景。
- 本会话上一轮本地 Flutter 3.32.0：严格 analyze 零诊断，57 组组件回归与每组 >=95% 生产行覆盖门禁全过；369 声明 API 审计零问题，370 个代码片段检查通过。生产源码、环境和测试入口未变，本轮复用结果。
- 本轮新增正式生成验证：锁文件 resolved-ref = 6bcf065e87a2fbd277c9b598205195f0a634414a，`node tool/generate_api.mjs --check` exit 0，57 份资产无差异。
- 工具 [PR #29](https://github.com/TDesignOteam/tdesign-flutter-tools/pull/29) 已于 2026-10-09 合入 main（6bcf065e）；文档 [PR #1149](https://github.com/Tencent/tdesign-flutter/pull/1149) 同日合入 develop（e724cd0c）。
- [#1027](https://github.com/Tencent/tdesign-flutter/issues/1027) 已关闭，正文列出 Indexes #1081/#1133、NavBar #1082/#1136、SideBar #1083/#1135、Skeleton #1094。关联提交已在本地 develop 历史中；PR 创建/推送待办可核销，CNB Review 不据此核销。

## 清理原则与边界

1. 将已完成的工具交付、生成检查、CI、GitHub PR 创建/合并等标记完成。
2. 混合待办拆开：GitHub/CI 完成；CNB Review、真机、设计对照仍保留。
3. 历史验收数字不删除；在相关记录顶部增加“历史检查点，当前状态见本记录”的说明，避免历史失败数继续误导发布判断。
4. 主题 677 项消费审查、跨端像素、完整状态矩阵和两张扩展 Popup 消费场景仍未闭环，不因当前登记矩阵通过而核销。
5. 本轮未读取 CNB Review 结果、未连接真实设备、未重新获取 Figma/小程序目标截图；这些均不是已完成项。

## 后续方案

- [0.2.7 → 1.0 迁移说明方案](migration-plan.md)
- [依赖检查与处理方案](dependency-plan.md)
- [全部开放 Spec 核验与操作方案](spec-validation-plan.md)
- [CI 正确性审查](ci-review.md)

所有方案均未修改生产实现或发布配置。

## 本轮补充验证

- 远端 latest job 116014097473 日志确认 Flutter 3.47.7；组件回归、独立 consumer 与 Demo 步骤实际成功。
- 展开共享 manifest 后，所有 *_golden_test.dart 文件均有文件级登记，但 Popup consumer 仅选择 drawer，actionSheet/dialog 不在执行集合。配置审查不能替代这两种场景的 Linux 运行。
- 三份未登记非视觉测试在本地 Flutter 3.32.0 实跑，20 项通过；此结果不代表已修复 CI 清单或已跑 latest。
- 当前可用设备仅 macOS、Chrome；未连接 Android/iOS 真实设备。
- 读取 develop classic branch protection 与 effective branch rules：必需状态检查为空、有效分支规则返回空集合；只报告，不修改远端权限或规则。
- 本轮没有更改生产 Dart、pubspec、Golden、workflow、公开指南或站点导航；所有实现性调整仍为方案。

## 文档核验

已修正 18 份任务清单，另为相关历史验收/迁移记录增加适用范围说明；原有 Spec 中开放任务由 57 条变为 38 条（含拆分后的真实待办，不代表缺陷数）。修改仅位于 specs/；git diff --check 和修改文档本地引用检查通过。
