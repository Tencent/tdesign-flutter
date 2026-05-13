# TaskContract — issue #924 [TDFab] 暴漏onLongPress方法

## 基本信息

- issue: https://github.com/Tencent/tdesign-flutter/issues/924
- 组件：`TFab`（issue 标题中写作 `TDFab`）
- 分支：`fix/issue-924-fab-on-long-press`
- 目录：`requirements/issue-924-fab-on-long-press`
- 类型：feature / enhancement

## 问题描述

- `TFab` 目前仅暴露点击回调 `onClick`，无法响应长按交互，导致业务侧无法实现“长按 FAB”触发动作的需求。

## 根因分析

- 组件内部使用 `InkWell` 仅绑定了 `onTap`，未对外提供 `onLongPress` 参数，也未将长按事件透传到 `InkWell.onLongPress`。

## 修复方案

1. 在 `TFab` 组件上新增 `VoidCallback? onLongPress` 公共参数（API 注释使用 `///`）。
2. 在组件内部 `InkWell` 绑定 `onLongPress: onLongPress`，保持对现有 `onClick` 的兼容，不引入破坏性变更。
3. 更新 `example` 的 FAB 页面，补充长按示例用于人工验收与回归。

## 贡献指南对照

- 开发规范：遵循 `CONTRIBUTING.md`，对原生组件行为“只扩展不阉割”；本次为新增事件回调，属于向后兼容扩展。
- 代码 Review 自检：构造函数在字段前；公开 API 使用 `///`；组件样式仍来自 `TTheme.of(context)`，无额外硬编码。
- 文档自检：本次变更为 API 扩展，已同步更新 example 示范用法；不涉及 `tdesign-site/src/**/README.md` 生成物。

## 交付物清单

| 序号 | 交付物 | 说明 |
|------|--------|------|
| 1 | `requirements/issue-924-fab-on-long-press/test-cases.md` | 验收用例 |
| 2 | `requirements/issue-924-fab-on-long-press/code-review-report.md` | 代码审查结论 |
| 3 | `requirements/issue-924-fab-on-long-press/acceptance-report.md` | 验收报告 |
| 4 | `requirements/issue-924-fab-on-long-press/pr-body.md` | PR 摘要 |
